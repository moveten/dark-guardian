-- 하드코어 랭킹 (Supabase 에 적용됨 — migration: dd_rank_hardcore)
-- hc      : 하드코어 캐릭터 여부 (일반 랭킹은 hc=is.false 로만 조회)
-- dead_at : 사망 시각 (null 이면 생존). 죽은 캐릭터도 삭제할 때까지 랭킹에 남음
-- 하드코어 순위: clear desc → kills desc → lvl desc
alter table public.dd_rank add column if not exists hc boolean not null default false;
alter table public.dd_rank add column if not exists dead_at timestamptz;
create index if not exists dd_rank_hc_idx on public.dd_rank (clear desc, kills desc, lvl desc) where hc;
