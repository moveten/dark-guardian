-- 클라우드 저장본 정리 (Supabase 에 적용됨 · migration: dd_save_invalid_audit, 11/22)
--  · dd_save.invalid_at      : 같은 캐릭터(dkdef2.c.<id>)를 가진 더 새로운 행이 생겨서 '무효'가 된 시각 (null = 유효)
--  · 새 행 INSERT 시 트리거   : 지금 들어온 행의 dkdef2.c.<id> 와 같은 키를 가진 기존 행(아직 무효가 아닌 것)에 invalid_at = now() 기록
--  · dd_save_audit            : 행이 삭제될 때 남기는 기록 (id · reason · target · names · trig_at · created_at)
--      reason  INVALID_EXPIRED(무효 48시간 경과) / UPLOAD_EXPIRED(마지막 저장 61일 경과) / REQ_BY_ADMIN(그 밖의 직접 삭제)
--      target  삭제된 행의 dkdef2.list 값 · names  dkdef2.nmv.<id> 값들(목록 순서, 쉼표) · trig_at  삭제 기준 시각(invalid_at 또는 updated_at)
--  · dd_lab_save_clean(p_pw)  : 연구실 [클라우드 정리하기] — ① 같은 캐릭터 키 행끼리 가장 최근 행만 남기고 invalid_at 기록(이미 무효인 행은 건드리지 않음)
--                               ② invalid_at 48시간 이상 지난 행 삭제 ③ 마지막 저장(updated_at) 61일 이상 지난 행 삭제
--  · dd_lab_save_list(p_pw)   : 목록에 inv(invalid_at) · fn(첫 캐릭터 이름) · cn(캐릭터 수) 추가
-- 관리자 비밀번호는 이 파일에 없어요 (기존 dd_lab_save_count 로 확인).
alter table public.dd_save add column if not exists invalid_at timestamptz;

create table if not exists public.dd_save_audit (
  id bigint generated always as identity primary key,
  reason text not null check (reason in ('INVALID_EXPIRED','UPLOAD_EXPIRED','REQ_BY_ADMIN')),
  target text,
  names text,
  trig_at timestamptz,
  created_at timestamptz not null default now()
);
alter table public.dd_save_audit enable row level security;
revoke all on public.dd_save_audit from anon, authenticated;

create or replace function public.dd_save_info(p jsonb) returns jsonb
language plpgsql immutable set search_path = public as $$
declare l jsonb;
begin
  begin l := (p->>'dkdef2.list')::jsonb; exception when others then l := null; end;
  if l is null or jsonb_typeof(l) <> 'array' then return jsonb_build_object('fn','','cn',0); end if;
  return jsonb_build_object('fn', coalesce(p->>('dkdef2.nmv.' || (l->>0)),''), 'cn', jsonb_array_length(l));
end $$;

create or replace function public.dd_save_names(p jsonb) returns text
language plpgsql immutable set search_path = public as $$
declare l jsonb;
begin
  begin l := (p->>'dkdef2.list')::jsonb; exception when others then return ''; end;
  if l is null or jsonb_typeof(l) <> 'array' then return ''; end if;
  return coalesce((select string_agg(coalesce(p->>('dkdef2.nmv.' || e.v),''), ',' order by e.o) from jsonb_array_elements_text(l) with ordinality e(v,o)), '');
end $$;

create or replace function public.dd_save_invalidate_trg() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  update public.dd_save o set invalid_at = now()
   where o.code_hash <> new.code_hash and o.invalid_at is null
     and exists (select 1 from jsonb_object_keys(new.data) k where k like 'dkdef2.c.%' and o.data ? k);
  return new;
end $$;
drop trigger if exists dd_save_invalidate on public.dd_save;
create trigger dd_save_invalidate after insert on public.dd_save for each row execute function public.dd_save_invalidate_trg();

create or replace function public.dd_save_audit_trg() returns trigger
language plpgsql security definer set search_path = public as $$
declare r text := coalesce(nullif(current_setting('dd.reason', true),''),'REQ_BY_ADMIN');
begin
  insert into public.dd_save_audit(reason, target, names, trig_at)
  values (r, old.data->>'dkdef2.list', public.dd_save_names(old.data), case when r = 'INVALID_EXPIRED' then old.invalid_at else old.updated_at end);
  return old;
end $$;
drop trigger if exists dd_save_audit_del on public.dd_save;
create trigger dd_save_audit_del before delete on public.dd_save for each row execute function public.dd_save_audit_trg();

create or replace function public.dd_save_clean_core() returns jsonb
language plpgsql security definer set search_path = public as $$
declare r record; seen text[] := '{}'; ks text[]; n1 int := 0; n2 int := 0; n3 int := 0;
begin
  for r in select code_hash, data from public.dd_save where invalid_at is null order by updated_at desc, code_hash loop   -- 최근 행부터
    select coalesce(array_agg(k), '{}') into ks from jsonb_object_keys(r.data) k where k like 'dkdef2.c.%';
    if ks && seen then update public.dd_save set invalid_at = now() where code_hash = r.code_hash; n1 := n1 + 1;
    else seen := seen || ks; end if;
  end loop;
  perform set_config('dd.reason', 'INVALID_EXPIRED', true);
  delete from public.dd_save where invalid_at is not null and invalid_at <= now() - interval '48 hours'; get diagnostics n2 = row_count;
  perform set_config('dd.reason', 'UPLOAD_EXPIRED', true);
  delete from public.dd_save where updated_at <= now() - interval '61 days'; get diagnostics n3 = row_count;
  perform set_config('dd.reason', '', true);
  return jsonb_build_object('invalidated', n1, 'deleted_invalid', n2, 'deleted_old', n3, 'rows', (select count(*) from public.dd_save));
end $$;

create or replace function public.dd_lab_save_clean(p_pw text) returns jsonb
language plpgsql security definer set search_path = public as $$
begin
  if public.dd_lab_save_count(p_pw) is null then return null; end if;   -- 비밀번호 확인
  return public.dd_save_clean_core();
end $$;

create or replace function public.dd_lab_save_list(p_pw text) returns jsonb
language plpgsql security definer set search_path = public as $$
begin
  if public.dd_lab_save_count(p_pw) is null then return null; end if;
  return coalesce((select jsonb_agg(jsonb_build_object('n', t.n, 'id', t.id, 'h', t.h, 'ver', t.ver, 'at', t.updated_at, 'kb', t.kb, 'inv', t.invalid_at, 'fn', t.i->>'fn', 'cn', (t.i->>'cn')::int) order by t.n)
    from (select row_number() over (order by updated_at, code_hash) n, left(code_hash,16) id, left(md5(data::text),8) h, ver, updated_at, invalid_at, round(length(data::text)/1024.0,1) kb, public.dd_save_info(data) i from public.dd_save) t), '[]'::jsonb);
end $$;

revoke all on function public.dd_save_info(jsonb), public.dd_save_names(jsonb), public.dd_save_invalidate_trg(), public.dd_save_audit_trg(), public.dd_save_clean_core(), public.dd_lab_save_clean(text), public.dd_lab_save_list(text) from public;
grant execute on function public.dd_lab_save_clean(text), public.dd_lab_save_list(text) to anon, authenticated;
