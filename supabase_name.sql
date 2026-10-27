-- 닉네임 전체 중복 방지 (어둠의 수호자) — Supabase SQL Editor 또는 마이그레이션으로 실행
-- 클라이언트: index.html 의 NAME_SRV 를 true 로 바꾸면 이 테이블/함수를 사용해요.
create table if not exists public.dd_name (
  key text primary key,            -- 공백 제거 + 소문자로 정규화한 이름
  id text not null unique,         -- 이 이름을 가진 캐릭터 id (캐릭터 1명 = 이름 1개)
  name text not null,
  created_at timestamptz not null default now()
);
alter table public.dd_name enable row level security;           -- 정책 없음 = 앱에서 직접 읽고 쓸 수 없음 (함수로만)
revoke all on public.dd_name from anon, authenticated;

create or replace function public.claim_name(p_id text, p_name text) returns text
language plpgsql security definer set search_path = public as $$
declare k text := lower(regexp_replace(coalesce(p_name,''), '\s', '', 'g'));
begin
  if coalesce(p_id,'') = '' or k = '' or length(k) > 16 then return 'bad'; end if;
  perform pg_advisory_xact_lock(hashtext('dd_name:' || k));      -- 같은 이름을 동시에 잡아도 한 명만 성공
  if exists (select 1 from dd_name where key = k and id <> p_id) then return 'taken'; end if;
  delete from dd_name where id = p_id and key <> k;               -- 이름 변경: 예전 이름 해제
  insert into dd_name(key, id, name) values (k, p_id, left(p_name, 16)) on conflict (key) do nothing;
  if exists (select 1 from dd_name where key = k and id = p_id) then return 'ok'; end if;
  return 'taken';
end $$;

create or replace function public.release_name(p_id text) returns text
language plpgsql security definer set search_path = public as $$
begin
  delete from dd_name where id = p_id;                            -- 캐릭터 삭제: 이름 해제
  return 'ok';
end $$;

revoke all on function public.claim_name(text, text) from public;
revoke all on function public.release_name(text) from public;
grant execute on function public.claim_name(text, text) to anon, authenticated;
grant execute on function public.release_name(text) to anon, authenticated;

-- 이미 있는 랭킹 이름은 '먼저 만든 캐릭터'(id 시각이 빠른 쪽)가 선점해요.
-- 중복된 나머지 캐릭터(전사 2명, 팔라왕 1명, 컹컹 1명)는 다음 접속 때 새 닉네임을 정해야 해요.
insert into public.dd_name(key, id, name)
select lower(regexp_replace(name, '\s', '', 'g')), id, left(name, 16)
from public.dd_rank
where coalesce(name,'') <> ''
  and id not in ('cmv3297ak7io', 'cmv39bs8216h', 'cmv39bs836yd', 'cmvcdycnz7da')
on conflict do nothing;
