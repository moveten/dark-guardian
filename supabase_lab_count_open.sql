-- dd_lab_save_count: 비밀번호 없이 행 수만 응답 (p_pw 는 예전 클라이언트 호환용으로 받기만 하고 무시).
-- 주의: dd_lab_save_list / dd_lab_save_clean 은 예전에 dd_lab_save_count 로 비밀번호를 확인했기 때문에,
--       count 를 열면 함께 열려 버려요 → 두 함수가 dd_lab_ok(해시 확인)를 직접 쓰도록 바꿈.
create or replace function public.dd_lab_save_count(p_pw text default null)
returns integer language plpgsql security definer set search_path to 'public' as $$
begin
  return (select count(*)::int from public.dd_save);
end $$;

create or replace function public.dd_lab_save_list(p_pw text)
returns jsonb language plpgsql security definer set search_path to 'public' as $$
begin
  if not public.dd_lab_ok(p_pw) then return null; end if;
  return coalesce((select jsonb_agg(jsonb_build_object('n', t.n, 'id', t.id, 'h', t.h, 'ver', t.ver, 'at', t.updated_at, 'kb', t.kb, 'inv', t.invalid_at, 'fn', t.i->>'fn', 'cn', (t.i->>'cn')::int) order by t.n)
    from (select row_number() over (order by updated_at, code_hash) n, left(code_hash,16) id, left(md5(data::text),8) h, ver, updated_at, invalid_at, round(length(data::text)/1024.0,1) kb, public.dd_save_info(data) i from public.dd_save) t), '[]'::jsonb);
end $$;

create or replace function public.dd_lab_save_clean(p_pw text)
returns jsonb language plpgsql security definer set search_path to 'public' as $$
begin
  if not public.dd_lab_ok(p_pw) then return null; end if;
  return public.dd_save_clean_core();
end $$;
