-- 랭킹 직업 제한에 강령술사('necro') 추가 : 이미 dd_rank 가 있다면 이것만 한 번 실행
alter table public.dd_rank drop constraint if exists dd_rank_chk;
alter table public.dd_rank add constraint dd_rank_chk check (
  char_length(id) <= 40 and char_length(name) <= 8
  and cls in ('war','pal','sorc','necro')
  and lvl between 1 and 999
  and kills between 0 and 100000000
  and clear between 0 and 30
);
