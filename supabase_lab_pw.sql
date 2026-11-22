-- 연구실(관리자) 비밀번호 확인을 한 곳(dd_lab_ok)으로 모으고, 서버에는 비밀번호 대신 SHA-256 해시만 둡니다.
-- (비밀번호는 이 파일·노트·커밋 어디에도 적지 않아요. 바꿀 땐 아래 해시 값만 새 비밀번호의 SHA-256 으로 교체)
create or replace function public.dd_lab_ok(p_pw text) returns boolean
language sql immutable security definer set search_path = public as $$
  select p_pw is not null and encode(sha256(convert_to(p_pw,'UTF8')),'hex') = '9d10e2eb8dcee761c27f051658c4e8d0734504fb434050828a17d6ddb708b40e'
$$;
revoke all on function public.dd_lab_ok(text) from public, anon, authenticated;

create or replace function public.dd_lab_list(p_pw text, p_limit integer default 200)
returns table(kind text, names text, created_at timestamptz)
language plpgsql security definer set search_path to 'public' as $$
begin
  if not public.dd_lab_ok(p_pw) then return; end if;
  return query select l.kind, l.names, l.created_at from dd_charlog l order by l.created_at desc, l.id desc limit least(greatest(coalesce(p_limit,200),1),500);
end $$;

create or replace function public.dd_lab_log(p_pw text, p_kind text, p_names text, p_at timestamptz default now())
returns text language plpgsql security definer set search_path to 'public' as $$
begin
  if not public.dd_lab_ok(p_pw) then return 'denied'; end if;
  if p_kind not in ('in','out') then return 'bad'; end if;
  insert into dd_charlog(kind, names, created_at)
  values (p_kind, left(coalesce(p_names,''), 400), least(coalesce(p_at, now()), now()));
  return 'ok';
end $$;

create or replace function public.dd_lab_save_count(p_pw text)
returns integer language plpgsql security definer set search_path to 'public' as $$
begin
  if not public.dd_lab_ok(p_pw) then return null; end if;
  return (select count(*)::int from public.dd_save);
end $$;

create or replace function public.dd_lab_save_row(p_pw text, p_id text)
returns jsonb language plpgsql security definer set search_path to 'public' as $$
declare r record;
begin
  if not public.dd_lab_ok(p_pw) then return null; end if;
  if p_id is null or p_id !~ '^[0-9a-f]{16}$' then return null; end if;
  select ver, updated_at, left(md5(data::text),8) h, data into r from public.dd_save where code_hash like p_id || '%' limit 1;
  if not found then return null; end if;
  return jsonb_build_object('ver', r.ver, 'at', r.updated_at, 'hash', r.h, 'data', r.data);
end $$;
