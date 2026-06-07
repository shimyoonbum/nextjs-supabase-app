-- =============================================================
-- W2: event_participants 실시간 구독 활성화 (Phase 3 / Task 010)
--
-- 참여자 목록을 새로고침 없이 실시간 갱신하기 위해
-- supabase_realtime publication 에 테이블을 추가한다.
-- REPLICA IDENTITY FULL: DELETE 이벤트에서도 event_id 가 페이로드에
-- 포함되어 클라이언트의 event_id 필터가 동작하도록 한다.
-- (참여 취소 시 목록에서 즉시 제거 가능)
-- =============================================================
alter publication supabase_realtime add table public.event_participants;
alter table public.event_participants replica identity full;
