-- =============================================================
-- W1: DB 보안·성능 하드닝 (Phase 3 / Task 007 마감)
--
-- get_advisors 권고 해소:
--  - [SECURITY] SECURITY DEFINER 함수의 API(RPC) 노출 제거
--  - [PERFORMANCE] RLS 정책의 auth.<fn>() 행별 재평가 제거
--  - [INFO] UNIQUE 제약과 중복되는 미사용 인덱스 제거
-- =============================================================

-- ----------------------------------------------------------------
-- 1) is_admin() 을 노출되지 않는 private 스키마로 이동
--    PostgREST 는 public 스키마만 노출하므로 /rest/v1/rpc 노출이 사라진다.
--    RLS 정책 평가를 위해 authenticated 에만 권한을 부여한다.
--    SECURITY DEFINER 를 유지해 profiles 조회 시 RLS 재귀를 방지한다.
-- ----------------------------------------------------------------
create schema if not exists private;

create or replace function private.is_admin()
returns boolean
language sql
security definer
stable
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles
    where id = (select auth.uid()) and role = 'admin'
  );
$$;

-- 기본 PUBLIC EXECUTE 권한 회수 후 authenticated 에만 부여
revoke execute on function private.is_admin() from public;
grant usage on schema private to authenticated;
grant execute on function private.is_admin() to authenticated;

-- ----------------------------------------------------------------
-- 2) RLS 정책 재작성
--    - auth.uid() -> (select auth.uid()) : 행별 재평가 방지 (initplan 최적화)
--    - public.is_admin() -> private.is_admin()
-- ----------------------------------------------------------------
alter policy "profiles_insert_self" on public.profiles
  with check ((select auth.uid()) = id);
alter policy "profiles_update_self" on public.profiles
  using ((select auth.uid()) = id or private.is_admin());
alter policy "profiles_delete_admin" on public.profiles
  using (private.is_admin());

alter policy "events_insert_owner" on public.events
  with check ((select auth.uid()) = created_by);
alter policy "events_update_owner" on public.events
  using ((select auth.uid()) = created_by or private.is_admin());
alter policy "events_delete_owner" on public.events
  using ((select auth.uid()) = created_by or private.is_admin());

alter policy "participants_insert_self" on public.event_participants
  with check ((select auth.uid()) = user_id);
alter policy "participants_delete_self" on public.event_participants
  using ((select auth.uid()) = user_id or private.is_admin());

-- ----------------------------------------------------------------
-- 3) 더 이상 참조되지 않는 public.is_admin() 제거
-- ----------------------------------------------------------------
drop function if exists public.is_admin();

-- ----------------------------------------------------------------
-- 4) handle_new_user(): 외부 RPC 노출 차단 + search_path 강화
--    (트리거는 함수 소유자 권한으로 실행되므로 EXECUTE 회수는 안전)
-- ----------------------------------------------------------------
-- 기본 PUBLIC EXECUTE 권한까지 회수해야 RPC 노출이 완전히 사라진다.
revoke execute on function public.handle_new_user() from public, anon, authenticated;
alter function public.handle_new_user() set search_path = '';

-- ----------------------------------------------------------------
-- 5) UNIQUE 제약(events_invite_code_key)과 중복되는 미사용 인덱스 제거
-- ----------------------------------------------------------------
drop index if exists public.idx_events_invite_code;
