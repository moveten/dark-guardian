-- 어둠의 수호자 랭킹 테이블 (Supabase > SQL Editor 에서 한 번 실행)
create table if not exists public.dd_rank (
  id text primary key,
  name text not null default '',
  cls text not null default 'war',
  lvl int not null default 1,
  kills int not null default 0,
  clear int not null default 0,
  updated_at timestamptz not null default now(),
  constraint dd_rank_chk check (
    char_length(id) <= 40 and char_length(name) <= 8
    and cls in ('war','pal','sorc')
    and lvl between 1 and 999
    and kills between 0 and 100000000
    and clear between 0 and 10
  )
);
create index if not exists dd_rank_kills_idx on public.dd_rank (kills desc, lvl desc);
create index if not exists dd_rank_clear_idx on public.dd_rank (clear desc, lvl desc, kills desc);

alter table public.dd_rank enable row level security;
drop policy if exists "dd_rank read" on public.dd_rank;
drop policy if exists "dd_rank insert" on public.dd_rank;
drop policy if exists "dd_rank update" on public.dd_rank;
create policy "dd_rank read"   on public.dd_rank for select to anon using (true);
create policy "dd_rank insert" on public.dd_rank for insert to anon with check (true);
create policy "dd_rank update" on public.dd_rank for update to anon using (true) with check (true);
grant select, insert, update on public.dd_rank to anon;

-- (v2) 레벨/전투력/장비 상세
alter table public.dd_rank add column if not exists cp int not null default 0;
alter table public.dd_rank add column if not exists data jsonb;
alter table public.dd_rank drop constraint if exists dd_rank_chk2;
alter table public.dd_rank add constraint dd_rank_chk2 check (cp between 0 and 999999999 and (data is null or pg_column_size(data) < 12000));
create index if not exists dd_rank_lvl_idx on public.dd_rank (lvl desc, kills desc);
create index if not exists dd_rank_cp_idx on public.dd_rank (cp desc, lvl desc);
