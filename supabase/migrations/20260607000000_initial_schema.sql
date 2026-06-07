-- =============================================================
-- 초기 스키마: profiles, events, event_participants
-- database.types.ts 와 일치. FK 제약 이름은 코드의 PostgREST 조인
-- (profiles!events_created_by_fkey 등)이 의존하므로 정확히 맞춘다.
-- =============================================================

-- ----------------------------------------------------------------
-- profiles : auth.users 확장 테이블
-- ----------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text,
  full_name text,
  username text,
  avatar_url text,
  website text,
  role text not null default 'user',
  created_at timestamptz not null default now(),
  updated_at timestamptz default now()
);

-- ----------------------------------------------------------------
-- events : 이벤트
-- ----------------------------------------------------------------
create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  event_date timestamptz not null,
  location text not null,
  cover_image_url text,
  status text not null default 'upcoming',
  invite_code text not null,
  created_by uuid not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint events_invite_code_key unique (invite_code),
  constraint events_created_by_fkey foreign key (created_by)
    references public.profiles (id) on delete cascade
);

-- ----------------------------------------------------------------
-- event_participants : 이벤트 참여 관계
-- ----------------------------------------------------------------
create table if not exists public.event_participants (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null,
  user_id uuid not null,
  role text not null,
  joined_at timestamptz not null default now(),
  constraint event_participants_event_id_fkey foreign key (event_id)
    references public.events (id) on delete cascade,
  constraint event_participants_user_id_fkey foreign key (user_id)
    references public.profiles (id) on delete cascade,
  constraint event_participants_event_user_key unique (event_id, user_id)
);

-- ----------------------------------------------------------------
-- 인덱스 (조회 성능)
-- ----------------------------------------------------------------
create index if not exists idx_events_created_by on public.events (created_by);
create index if not exists idx_events_invite_code on public.events (invite_code);
create index if not exists idx_participants_event_id on public.event_participants (event_id);
create index if not exists idx_participants_user_id on public.event_participants (user_id);

-- ----------------------------------------------------------------
-- 관리자 여부 확인 함수 (RLS 재귀 방지를 위해 SECURITY DEFINER)
-- ----------------------------------------------------------------
create or replace function public.is_admin()
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- ----------------------------------------------------------------
-- 신규 가입 시 프로필 자동 생성 트리거
-- ----------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, avatar_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- =============================================================
-- RLS 정책
-- =============================================================
alter table public.profiles enable row level security;
alter table public.events enable row level security;
alter table public.event_participants enable row level security;

-- profiles: 누구나 조회 가능, 본인만 수정/생성, 관리자는 전체 관리
create policy "profiles_select_all" on public.profiles
  for select using (true);
create policy "profiles_insert_self" on public.profiles
  for insert with check (auth.uid() = id);
create policy "profiles_update_self" on public.profiles
  for update using (auth.uid() = id or public.is_admin());
create policy "profiles_delete_admin" on public.profiles
  for delete using (public.is_admin());

-- events: 누구나 조회, 생성자만 작성/수정/삭제, 관리자는 전체 관리
create policy "events_select_all" on public.events
  for select using (true);
create policy "events_insert_owner" on public.events
  for insert with check (auth.uid() = created_by);
create policy "events_update_owner" on public.events
  for update using (auth.uid() = created_by or public.is_admin());
create policy "events_delete_owner" on public.events
  for delete using (auth.uid() = created_by or public.is_admin());

-- event_participants: 누구나 조회, 본인만 참여/취소, 관리자는 전체 관리
create policy "participants_select_all" on public.event_participants
  for select using (true);
create policy "participants_insert_self" on public.event_participants
  for insert with check (auth.uid() = user_id);
create policy "participants_delete_self" on public.event_participants
  for delete using (auth.uid() = user_id or public.is_admin());
