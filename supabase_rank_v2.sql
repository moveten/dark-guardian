-- 랭킹 확장 (레벨/전투력/상세 보기) : 이미 dd_rank 가 있다면 이것만 한 번 실행
alter table public.dd_rank add column if not exists cp int not null default 0;
alter table public.dd_rank add column if not exists data jsonb;
alter table public.dd_rank drop constraint if exists dd_rank_chk2;
alter table public.dd_rank add constraint dd_rank_chk2 check (cp between 0 and 999999999 and (data is null or pg_column_size(data) < 12000));
create index if not exists dd_rank_lvl_idx on public.dd_rank (lvl desc, kills desc);
create index if not exists dd_rank_cp_idx on public.dd_rank (cp desc, lvl desc);
