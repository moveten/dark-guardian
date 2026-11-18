-- 연구실 클라우드 저장본 조회 (Supabase 에 적용됨 — migration: dd_lab_save_view)
-- 비밀번호는 실제 DB 함수 안에만 있어요. 이 파일의 '****' 자리에 관리자 비밀번호가 들어가 있어요.
--   dd_lab_save_count(p_pw)      : dd_save 행 수
--   dd_lab_save_list(p_pw)       : 행 목록(번호 · 코드 해시 앞 16자 · 내용 해시(md5 앞 8자) · 버전 · 저장 시각 · KB) — 내용(data)은 빼고 줘요
--   dd_lab_save_row(p_pw, p_id)  : 한 행의 JSON(ver · at · hash · data) — p_id 는 목록의 id
create or replace function public.dd_lab_save_count(p_pw text) returns int
language plpgsql security definer set search_path = public as $$
begin
  if p_pw is distinct from '****' then return null; end if;
  return (select count(*)::int from public.dd_save);
end $$;

create or replace function public.dd_lab_save_list(p_pw text) returns jsonb
language plpgsql security definer set search_path = public as $$
begin
  if p_pw is distinct from '****' then return null; end if;
  return coalesce((select jsonb_agg(jsonb_build_object('n', t.n, 'id', t.id, 'h', t.h, 'ver', t.ver, 'at', t.updated_at, 'kb', t.kb) order by t.n)
    from (select row_number() over (order by updated_at, code_hash) n, left(code_hash,16) id, left(md5(data::text),8) h, ver, updated_at, round(length(data::text)/1024.0,1) kb from public.dd_save) t), '[]'::jsonb);
end $$;

create or replace function public.dd_lab_save_row(p_pw text, p_id text) returns jsonb
language plpgsql security definer set search_path = public as $$
declare r record;
begin
  if p_pw is distinct from '****' then return null; end if;
  if p_id is null or p_id !~ '^[0-9a-f]{16}$' then return null; end if;
  select ver, updated_at, left(md5(data::text),8) h, data into r from public.dd_save where code_hash like p_id || '%' limit 1;
  if not found then return null; end if;
  return jsonb_build_object('ver', r.ver, 'at', r.updated_at, 'hash', r.h, 'data', r.data);
end $$;

revoke all on function public.dd_lab_save_count(text) from public;
revoke all on function public.dd_lab_save_list(text) from public;
revoke all on function public.dd_lab_save_row(text, text) from public;
grant execute on function public.dd_lab_save_count(text) to anon, authenticated;
grant execute on function public.dd_lab_save_list(text) to anon, authenticated;
grant execute on function public.dd_lab_save_row(text, text) to anon, authenticated;
