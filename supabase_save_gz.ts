// 클라우드 저장 압축 업로드 — Supabase Edge Function "dd-save-gz" (verify_jwt: false) 배포본
// 클라이언트가 {code,data,ver} JSON 을 gzip 으로 보내면(헤더 x-dd-enc: gzip) 여기서 풀어서 dd_save_put RPC 에 그대로 넘겨 저장해요.
// 저장 결과는 RPC 와 같은 모양({ok,ver,at} / {conflict,ver}). 내려받기는 예전처럼 dd_save_get RPC 를 쓰고 따로 압축하지 않아요.
const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'apikey, authorization, content-type, x-client-info, x-dd-enc',
  'Access-Control-Max-Age': '86400',
};
const MAX_RAW = 3_000_000; // 풀었을 때 최대 크기(압축 폭탄 방지) — dd_save_put 의 3MB 제한과 같아요
const json = (o: unknown, status = 200) =>
  new Response(JSON.stringify(o), { status, headers: { ...CORS, 'Content-Type': 'application/json' } });

async function gunzipLimited(body: ReadableStream<Uint8Array>): Promise<string> {
  const reader = body.pipeThrough(new DecompressionStream('gzip')).getReader();
  const chunks: Uint8Array[] = [];
  let total = 0;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    total += value.byteLength;
    if (total > MAX_RAW) { await reader.cancel(); throw new Error('too large'); }
    chunks.push(value);
  }
  const all = new Uint8Array(total);
  let off = 0;
  for (const c of chunks) { all.set(c, off); off += c.byteLength; }
  return new TextDecoder().decode(all);
}

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS });
  if (req.method !== 'POST' || !req.body) return json({ error: 'bad request' }, 400);
  const apikey = req.headers.get('apikey') || '';
  if (!apikey) return json({ error: 'no key' }, 401);
  let p: { code?: string; data?: unknown; ver?: number };
  try {
    const txt = req.headers.get('x-dd-enc') === 'gzip' ? await gunzipLimited(req.body) : await req.text();
    p = JSON.parse(txt);
  } catch (_e) {
    return json({ error: 'bad body' }, 400);
  }
  if (!p || typeof p.code !== 'string' || !p.data || typeof p.data !== 'object') return json({ error: 'bad body' }, 400);
  const headers: Record<string, string> = { apikey, 'Content-Type': 'application/json' };
  const auth = req.headers.get('authorization');
  if (auth) headers['Authorization'] = auth;
  const r = await fetch(`${Deno.env.get('SUPABASE_URL')}/rest/v1/rpc/dd_save_put`, {
    method: 'POST',
    headers,
    body: JSON.stringify({ p_code: p.code, p_data: p.data, p_ver: p.ver ?? 0 }),
  });
  const out = await r.text();
  return new Response(out, { status: r.status, headers: { ...CORS, 'Content-Type': 'application/json' } });
});
