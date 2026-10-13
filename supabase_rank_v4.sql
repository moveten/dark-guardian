-- 캐릭터를 삭제하면 랭킹에서도 삭제 : 이미 dd_rank 가 있다면 이것만 한 번 실행
drop policy if exists "dd_rank delete" on public.dd_rank;
create policy "dd_rank delete" on public.dd_rank for delete to anon using (true);
grant delete on public.dd_rank to anon;
