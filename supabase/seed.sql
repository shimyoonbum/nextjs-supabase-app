-- 이 파일은 scripts/gen-seed.ts 로 자동 생성됩니다. 직접 수정하지 마세요.
-- 더미 사용자 10명 + 테스트 계정 2명, 이벤트 20개, 참여 115건

-- 비밀번호 해싱(crypt/gen_salt)에 필요한 pgcrypto 확장 (Supabase: extensions 스키마)
create extension if not exists pgcrypto with schema extensions;

-- 멱등성을 위해 기존 데이터 정리 (auth.users 삭제 시 cascade)
delete from public.event_participants;
delete from public.events;
delete from auth.users where id in ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000010', '20000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002');

-- auth.users (비밀번호: qwer1234)
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000001', 'authenticated', 'authenticated', 'minjun@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000001', 'email', 'minjun@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000002', 'authenticated', 'authenticated', 'seoyeon@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000002', 'email', 'seoyeon@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000003', 'authenticated', 'authenticated', 'junseo@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000003', 'email', 'junseo@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000004', 'authenticated', 'authenticated', 'jiwoo@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000004', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000004', 'email', 'jiwoo@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000005', 'authenticated', 'authenticated', 'sua@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000005', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000005', 'email', 'sua@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000006', 'authenticated', 'authenticated', 'hayoon@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000006', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000006', 'email', 'hayoon@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000007', 'authenticated', 'authenticated', 'dohyun@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000007', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000007', 'email', 'dohyun@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000008', 'authenticated', 'authenticated', 'jimin@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000008', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000008', 'email', 'jimin@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000009', 'authenticated', 'authenticated', 'yejun@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000009', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000009', 'email', 'yejun@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000010', 'authenticated', 'authenticated', 'seojun@gather.dev', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000010', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000010', 'email', 'seojun@gather.dev'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '20000000-0000-0000-0000-000000000001', 'authenticated', 'authenticated', 'gymcoding@gmail.com', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '20000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', jsonb_build_object('sub', '20000000-0000-0000-0000-000000000001', 'email', 'gymcoding@gmail.com'), 'email', now(), now(), now());
insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '20000000-0000-0000-0000-000000000002', 'authenticated', 'authenticated', 'bruce.lean17@gmail.com', extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');
insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '20000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', jsonb_build_object('sub', '20000000-0000-0000-0000-000000000002', 'email', 'bruce.lean17@gmail.com'), 'email', now(), now(), now());

-- profiles
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000001', 'minjun@gather.dev', '김민준', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=minjun', null, 'user', '2026-05-08T06:59:38.065Z'::timestamptz, '2026-05-08T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000002', 'seoyeon@gather.dev', '이서연', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=seoyeon', null, 'user', '2026-05-10T06:59:38.065Z'::timestamptz, '2026-05-10T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000003', 'junseo@gather.dev', '박준서', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=junseo', null, 'user', '2026-05-13T06:59:38.065Z'::timestamptz, '2026-05-13T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000004', 'jiwoo@gather.dev', '최지우', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=jiwoo', null, 'user', '2026-05-16T06:59:38.065Z'::timestamptz, '2026-05-16T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000005', 'sua@gather.dev', '정수아', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=sua', null, 'user', '2026-05-18T06:59:38.065Z'::timestamptz, '2026-05-18T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000006', 'hayoon@gather.dev', '강하윤', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=hayoon', null, 'user', '2026-05-20T06:59:38.065Z'::timestamptz, '2026-05-20T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000007', 'dohyun@gather.dev', '윤도현', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=dohyun', null, 'user', '2026-05-23T06:59:38.065Z'::timestamptz, '2026-05-23T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000008', 'jimin@gather.dev', '임지민', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=jimin', null, 'user', '2026-05-26T06:59:38.065Z'::timestamptz, '2026-05-26T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000009', 'yejun@gather.dev', '한예준', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=yejun', null, 'user', '2026-05-28T06:59:38.065Z'::timestamptz, '2026-05-28T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('00000000-0000-0000-0000-000000000010', 'seojun@gather.dev', '오서준', null, 'https://api.dicebear.com/7.x/avataaars/svg?seed=seojun', null, 'user', '2026-05-31T06:59:38.065Z'::timestamptz, '2026-05-31T06:59:38.065Z'::timestamptz)
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('20000000-0000-0000-0000-000000000001', 'gymcoding@gmail.com', '체육코딩', null, null, null, 'user', now(), now())
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;
insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('20000000-0000-0000-0000-000000000002', 'bruce.lean17@gmail.com', 'Bruce Lean', null, null, null, 'admin', now(), now())
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;

-- events
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000001', '2025 개발자 네트워킹 밤', '서울의 개발자들이 모여 네트워킹하고 경험을 공유하는 자리입니다. 다양한 분야의 개발자들을 만나보세요!', '강남구 테헤란로 152, 강남파이낸스센터', '2026-06-14T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1540575467063-178a50c2df87', 'DEV2025', 'upcoming', '00000000-0000-0000-0000-000000000001', '2026-05-24T06:59:38.068Z'::timestamptz, '2026-05-24T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000002', '리액트 스터디 그룹 4기', '리액트를 함께 공부하는 스터디 그룹입니다. 매주 토요일 오전에 만나 프로젝트를 진행합니다.', '성동구 아차산로7가길 18, 서울숲 카페', '2026-06-10T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1522071820081-009f0129c71c', 'REACT4TH', 'upcoming', '00000000-0000-0000-0000-000000000002', '2026-05-17T06:59:38.068Z'::timestamptz, '2026-05-17T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000003', '주니어 개발자 취업 준비 모임', '취업을 준비하는 주니어 개발자들의 모임입니다. 이력서 피드백, 면접 준비, 포트폴리오 리뷰를 함께합니다.', '마포구 양화로 188, 홍대 코워킹 스페이스', '2026-06-17T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1531482615713-2afd69097998', 'JUNIOR2025', 'upcoming', '00000000-0000-0000-0000-000000000003', '2026-05-28T06:59:38.068Z'::timestamptz, '2026-05-28T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000004', 'AI/ML 해커톤 2025', '24시간 동안 AI와 머신러닝 기술을 활용한 프로젝트를 만드는 해커톤입니다. 푸짐한 상금과 멘토링이 제공됩니다.', '판교 제2테크노밸리, 기업지원허브', '2026-06-21T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e', 'AIML2025', 'upcoming', '00000000-0000-0000-0000-000000000004', '2026-05-23T06:59:38.068Z'::timestamptz, '2026-05-23T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000005', '스타트업 창업자 밋업', '스타트업을 준비하거나 운영 중인 창업자들의 정기 모임입니다. 경험과 인사이트를 나누고 협업 기회를 찾아보세요.', '강남구 역삼동, 스타트업 캠퍼스', '2026-06-12T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7', 'STARTUP25', 'upcoming', '00000000-0000-0000-0000-000000000005', '2026-05-30T06:59:38.068Z'::timestamptz, '2026-05-30T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000006', 'UX/UI 디자인 워크샵', '사용자 경험을 개선하는 디자인 원칙과 실전 노하우를 배우는 워크샵입니다. 피그마 실습이 포함됩니다.', '용산구 한강대로, 아이파크몰', '2026-06-19T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1561070791-2526d30994b5', 'UXUI2025', 'upcoming', '00000000-0000-0000-0000-000000000001', '2026-05-26T06:59:38.068Z'::timestamptz, '2026-05-26T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000007', '백엔드 개발자 컨퍼런스', '최신 백엔드 기술 트렌드와 아키텍처를 다루는 컨퍼런스입니다. Node.js, Go, Rust 등 다양한 주제가 준비되어 있습니다.', '서초구 강남대로, 삼성전자 서초사옥', '2026-06-27T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678', 'BACKEND25', 'upcoming', '00000000-0000-0000-0000-000000000002', '2026-05-20T06:59:38.068Z'::timestamptz, '2026-05-20T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000008', '코딩 테스트 스터디', '알고리즘 문제를 함께 풀고 코드 리뷰를 하는 스터디입니다. 매주 화요일, 목요일 저녁에 진행됩니다.', '광진구 아차산로, 건대입구 스터디 카페', '2026-06-09T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3', 'CODING25', 'upcoming', '00000000-0000-0000-0000-000000000003', '2026-05-29T06:59:38.068Z'::timestamptz, '2026-05-29T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000009', '클라우드 인프라 세미나', 'AWS, Azure, GCP 등 주요 클라우드 서비스의 실전 활용법을 배우는 세미나입니다. DevOps 엔지니어 필수!', '중구 청계천로, 대한상공회의소', '2026-06-25T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1451187580459-43490279c0fa', 'CLOUD25', 'upcoming', '00000000-0000-0000-0000-000000000004', '2026-05-27T06:59:38.068Z'::timestamptz, '2026-05-27T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000010', '오픈소스 컨트리뷰션 모임', '오픈소스 프로젝트에 기여하는 방법을 배우고 함께 컨트리뷰션하는 모임입니다. 초보자 환영!', '종로구 종로, 탑골공원 인근 카페', '2026-06-15T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1556075798-4825dfaaf498', 'OPENSOURCE', 'upcoming', '00000000-0000-0000-0000-000000000005', '2026-05-25T06:59:38.068Z'::timestamptz, '2026-05-25T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000011', '테크 블로그 작성 챌린지', '30일 동안 매일 기술 블로그를 작성하는 챌린지입니다. 함께 글쓰기 습관을 만들어보세요!', '온라인 (Slack 커뮤니티)', '2026-05-23T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1499750310107-5fef28a66643', 'BLOG30', 'ongoing', '00000000-0000-0000-0000-000000000001', '2026-05-08T06:59:38.068Z'::timestamptz, '2026-05-23T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000012', '풀스택 프로젝트 부트캠프', '8주 동안 실전 프로젝트를 만들며 풀스택 개발을 배우는 부트캠프입니다. 멘토링과 코드 리뷰가 제공됩니다.', '서울 종로구, 토즈 타워점', '2026-05-18T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4', 'FULLSTACK', 'ongoing', '00000000-0000-0000-0000-000000000002', '2026-04-28T06:59:38.068Z'::timestamptz, '2026-05-18T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000013', '모바일 앱 개발 스터디', 'React Native와 Flutter로 모바일 앱을 만드는 스터디입니다. 주 2회 온라인 미팅이 있습니다.', '온라인 (Discord)', '2026-05-28T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c', 'MOBILE25', 'ongoing', '00000000-0000-0000-0000-000000000003', '2026-05-13T06:59:38.068Z'::timestamptz, '2026-05-28T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000014', '게임 개발 토이 프로젝트', 'Unity와 Unreal Engine으로 간단한 게임을 만드는 프로젝트입니다. 게임 개발에 관심 있는 분 환영!', '강남구 논현동, 게임 개발 스튜디오', '2026-06-02T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1550745165-9bc0b252726f', 'GAMEDEV', 'ongoing', '00000000-0000-0000-0000-000000000004', '2026-05-18T06:59:38.068Z'::timestamptz, '2026-06-02T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000015', '데이터 사이언스 캐글 스터디', 'Kaggle 대회에 참여하며 데이터 분석과 머신러닝을 배우는 스터디입니다. Python과 R 사용자 모두 환영합니다.', '온라인 (Google Meet)', '2026-05-26T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1551288049-bebda4e38f71', 'KAGGLE25', 'ongoing', '00000000-0000-0000-0000-000000000005', '2026-05-10T06:59:38.068Z'::timestamptz, '2026-05-26T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000016', '웹 접근성 세미나', '웹 접근성 표준과 실무 적용 방법을 배우는 세미나였습니다. WCAG 2.1 기준을 중심으로 진행되었습니다.', '서울시청 다목적홀', '2026-05-31T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4', 'A11Y2024', 'ended', '00000000-0000-0000-0000-000000000001', '2026-05-08T06:59:38.068Z'::timestamptz, '2026-05-31T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000017', '블록체인 기술 밋업', '블록체인과 스마트 컨트랙트에 대해 배우고 토론했던 밋업입니다. 실제 DApp 개발 경험도 공유했습니다.', '여의도 IFC몰', '2026-05-24T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0', 'BLOCKCHAIN', 'ended', '00000000-0000-0000-0000-000000000002', '2026-05-03T06:59:38.068Z'::timestamptz, '2026-05-24T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000018', '사이드 프로젝트 쇼케이스', '개발자들이 자신의 사이드 프로젝트를 소개하고 피드백을 받는 자리였습니다. 총 15개 프로젝트가 발표되었습니다.', '강남구 선릉역 부근 이벤트홀', '2026-05-17T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2', 'SHOWCASE', 'ended', '00000000-0000-0000-0000-000000000003', '2026-04-26T06:59:38.068Z'::timestamptz, '2026-05-17T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000019', '코드 리뷰 워크샵', '효과적인 코드 리뷰 방법과 리뷰 문화를 만드는 법을 배운 워크샵이었습니다. 실습 시간이 풍부했습니다.', '마포구 상암동, 누리꿈스퀘어', '2026-05-10T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1498050108023-c5249f4df085', 'CODEREVIEW', 'ended', '00000000-0000-0000-0000-000000000004', '2026-04-19T06:59:38.068Z'::timestamptz, '2026-05-10T06:59:38.068Z'::timestamptz);
insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('10000000-0000-0000-0000-000000000020', '개발자 커리어 토크', '시니어 개발자들이 커리어 경험을 공유하고 조언을 해준 토크 이벤트였습니다. 주니어 개발자들에게 큰 도움이 되었습니다.', '강남구 역삼동, D2 스타트업 팩토리', '2026-05-03T06:59:38.068Z'::timestamptz, 'https://images.unsplash.com/photo-1552664730-d307ca884978', 'CAREER24', 'ended', '00000000-0000-0000-0000-000000000005', '2026-04-12T06:59:38.068Z'::timestamptz, '2026-05-03T06:59:38.068Z'::timestamptz);

-- event_participants
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 'host', '2026-05-24T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000008', 'participant', '2026-06-01T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000009', 'participant', '2026-06-02T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000010', 'participant', '2026-06-03T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', 'participant', '2026-06-04T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'participant', '2026-06-05T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', 'host', '2026-05-17T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 'participant', '2026-05-20T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-22T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-24T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-26T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000009', 'participant', '2026-05-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000010', 'participant', '2026-05-29T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000003', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000004', 'participant', '2026-05-31T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000005', 'participant', '2026-06-01T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', 'host', '2026-05-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000007', 'participant', '2026-06-01T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000008', 'participant', '2026-06-02T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000009', 'participant', '2026-06-03T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000010', 'participant', '2026-06-04T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000004', 'host', '2026-05-23T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', 'participant', '2026-05-25T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000002', 'participant', '2026-05-26T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000003', 'participant', '2026-05-27T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000005', 'participant', '2026-05-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-29T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-31T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000009', 'participant', '2026-06-01T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000010', 'participant', '2026-06-02T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000005', 'host', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000001', 'participant', '2026-06-01T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000002', 'participant', '2026-06-02T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000003', 'participant', '2026-06-03T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000004', 'participant', '2026-06-04T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000006', 'participant', '2026-06-05T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000007', 'participant', '2026-06-06T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000001', 'host', '2026-05-26T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-29T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000009', 'participant', '2026-05-31T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000002', 'host', '2026-05-20T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000001', 'participant', '2026-05-22T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000003', 'participant', '2026-05-23T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000004', 'participant', '2026-05-24T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000005', 'participant', '2026-05-25T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-26T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-27T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000009', 'participant', '2026-05-29T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000010', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000003', 'host', '2026-05-29T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-31T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000007', 'participant', '2026-06-01T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000008', 'participant', '2026-06-02T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000004', 'host', '2026-05-27T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000001', 'participant', '2026-05-29T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000002', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000003', 'participant', '2026-05-31T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000005', 'participant', '2026-06-01T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000006', 'participant', '2026-06-02T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000007', 'participant', '2026-06-03T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000008', 'participant', '2026-06-04T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000005', 'host', '2026-05-25T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', 'participant', '2026-05-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-29T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-31T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000001', 'host', '2026-05-08T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-10T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-12T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-14T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000009', 'participant', '2026-05-16T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000010', 'participant', '2026-05-18T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000002', 'host', '2026-04-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000001', 'participant', '2026-04-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000003', 'participant', '2026-05-02T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000004', 'participant', '2026-05-04T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000005', 'participant', '2026-05-06T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-08T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-10T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-12T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000009', 'participant', '2026-05-14T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000003', 'host', '2026-05-13T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-18T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-20T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000004', 'host', '2026-05-18T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-23T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000009', 'participant', '2026-05-26T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000005', 'host', '2026-05-10T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000001', 'participant', '2026-05-14T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000002', 'participant', '2026-05-18T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000010', 'participant', '2026-05-22T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000016', '00000000-0000-0000-0000-000000000001', 'host', '2026-05-08T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000016', '00000000-0000-0000-0000-000000000006', 'participant', '2026-05-13T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000016', '00000000-0000-0000-0000-000000000007', 'participant', '2026-05-16T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000017', '00000000-0000-0000-0000-000000000002', 'host', '2026-05-03T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000017', '00000000-0000-0000-0000-000000000003', 'participant', '2026-05-08T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000017', '00000000-0000-0000-0000-000000000008', 'participant', '2026-05-10T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000018', '00000000-0000-0000-0000-000000000003', 'host', '2026-04-26T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000018', '00000000-0000-0000-0000-000000000004', 'participant', '2026-04-30T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000018', '00000000-0000-0000-0000-000000000005', 'participant', '2026-05-03T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000018', '00000000-0000-0000-0000-000000000009', 'participant', '2026-05-08T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000019', '00000000-0000-0000-0000-000000000004', 'host', '2026-04-19T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000019', '00000000-0000-0000-0000-000000000001', 'participant', '2026-04-23T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000019', '00000000-0000-0000-0000-000000000002', 'participant', '2026-04-28T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000005', 'host', '2026-04-12T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000006', 'participant', '2026-04-18T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000007', 'participant', '2026-04-23T06:59:38.072Z'::timestamptz);
insert into public.event_participants (event_id, user_id, role, joined_at)
values ('10000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000010', 'participant', '2026-04-26T06:59:38.072Z'::timestamptz);
