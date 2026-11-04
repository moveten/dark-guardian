-- 연구실 출입 기록 (Supabase 에 적용됨 — migration: dd_charlog)
-- 비밀번호는 실제 DB 함수 안에만 있어요. 이 파일의 '****' 자리에 관리자 비밀번호가 들어가 있어요.
-- 테이블은 RLS 로 막혀 있고(앱에서 직접 읽기/쓰기 불가) 아래 두 함수로만 접근해요.
--   dd_lab_log(p_pw, p_kind, p_names, p_at) : 기록 추가 (kind: 'in' 획득 / 'out' 반납)
--   dd_lab_list(p_pw, p_limit)              : 최신순 목록
create table if not exists public.dd_charlog (
  id bigint generated always as identity primary key,
  kind text not null check (kind in ('in','out')),
  names text not null default '' check (char_length(names) <= 400),
  created_at timestamptz not null default now()
);
alter table public.dd_charlog enable row level security;
revoke all on public.dd_charlog from anon, authenticated;

create or replace function public.dd_lab_log(p_pw text, p_kind text, p_names text, p_at timestamptz default now()) returns text
language plpgsql security definer set search_path = public as $$
begin
  if p_pw is distinct from '****' then return 'denied'; end if;
  if p_kind not in ('in','out') then return 'bad'; end if;
  insert into dd_charlog(kind, names, created_at)
  values (p_kind, left(coalesce(p_names,''), 400), least(coalesce(p_at, now()), now()));
  return 'ok';
end $$;

create or replace function public.dd_lab_list(p_pw text, p_limit int default 200) returns table(kind text, names text, created_at timestamptz)
language plpgsql security definer set search_path = public as $$
begin
  if p_pw is distinct from '****' then return; end if;
  return query select l.kind, l.names, l.created_at from dd_charlog l order by l.created_at desc, l.id desc limit least(greatest(coalesce(p_limit,200),1),500);
end $$;

revoke all on function public.dd_lab_log(text, text, text, timestamptz) from public;
revoke all on function public.dd_lab_list(text, int) from public;
grant execute on function public.dd_lab_log(text, text, text, timestamptz) to anon, authenticated;
grant execute on function public.dd_lab_list(text, int) to anon, authenticated;
