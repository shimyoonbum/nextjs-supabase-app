/**
 * 시드 SQL 생성 스크립트
 *
 * lib/data 의 더미 데이터(사용자/이벤트/참여)를 읽어 supabase/seed.sql 을 생성한다.
 * 더미 데이터의 문자열 ID(user-001, event-001)를 결정적 UUID로 매핑한다.
 *
 * 실행: npx tsx scripts/gen-seed.ts
 */
import { writeFileSync, mkdirSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { dummyUsers } from "../lib/data/users";
import { dummyEvents } from "../lib/data/events";
import { dummyParticipants } from "../lib/data/participants";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, "..");

// 문자열 ID -> UUID 매핑 (결정적)
function userUuid(id: string): string {
  // "user-001" -> "00000000-0000-0000-0000-000000000001"
  const n = id.replace("user-", "").padStart(12, "0");
  return `00000000-0000-0000-0000-${n}`;
}
function eventUuid(id: string): string {
  // "event-001" -> "10000000-0000-0000-0000-000000000001"
  const n = id.replace("event-", "").padStart(12, "0");
  return `10000000-0000-0000-0000-${n}`;
}

// 로그인 가능한 auth 이메일 (더미 사용자는 한글 이메일이라 ASCII로 대체)
// avatar_url seed 값에서 로마자 닉네임을 추출해 사용
function authEmail(u: (typeof dummyUsers)[number]): string {
  const seed = (u.avatar_url ?? "").split("seed=")[1] ?? u.id.replace("user-", "u");
  return `${seed}@gather.dev`;
}

// SQL 문자열 이스케이프 (작은따옴표)
function sq(v: string | null | undefined): string {
  if (v === null || v === undefined) return "null";
  return `'${v.replace(/'/g, "''")}'`;
}
function ts(v: string): string {
  return `'${v}'::timestamptz`;
}

// 테스트 계정 (CLAUDE.md 명시)
const TEST_ACCOUNTS = [
  {
    id: "20000000-0000-0000-0000-000000000001",
    email: "gymcoding@gmail.com",
    full_name: "체육코딩",
    role: "user",
  },
  {
    id: "20000000-0000-0000-0000-000000000002",
    email: "bruce.lean17@gmail.com",
    full_name: "Bruce Lean",
    role: "admin",
  },
];

const lines: string[] = [];
lines.push("-- 이 파일은 scripts/gen-seed.ts 로 자동 생성됩니다. 직접 수정하지 마세요.");
lines.push("-- 더미 사용자 10명 + 테스트 계정 2명, 이벤트 20개, 참여 115건");
lines.push("");
lines.push("-- 비밀번호 해싱(crypt/gen_salt)에 필요한 pgcrypto 확장 (Supabase: extensions 스키마)");
lines.push("create extension if not exists pgcrypto with schema extensions;");
lines.push("");
lines.push("-- 멱등성을 위해 기존 데이터 정리 (auth.users 삭제 시 cascade)");
lines.push("delete from public.event_participants;");
lines.push("delete from public.events;");
lines.push(
  "delete from auth.users where id in (" +
    [...dummyUsers.map((u) => userUuid(u.id)), ...TEST_ACCOUNTS.map((t) => t.id)]
      .map((id) => `'${id}'`)
      .join(", ") +
    ");"
);
lines.push("");

// --- auth.users + auth.identities ---
lines.push("-- auth.users (비밀번호: qwer1234)");
function authUserInsert(id: string, email: string): string {
  return `insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, confirmation_token, recovery_token, email_change_token_new, email_change)
values ('00000000-0000-0000-0000-000000000000', '${id}', 'authenticated', 'authenticated', ${sq(email)}, extensions.crypt('qwer1234', extensions.gen_salt('bf')), now(), now(), now(), '{"provider":"email","providers":["email"]}', '{}', '', '', '', '');`;
}
function identityInsert(id: string, email: string): string {
  return `insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values (gen_random_uuid(), '${id}', '${id}', jsonb_build_object('sub', '${id}', 'email', ${sq(email)}), 'email', now(), now(), now());`;
}

for (const u of dummyUsers) {
  const id = userUuid(u.id);
  const email = authEmail(u);
  lines.push(authUserInsert(id, email));
  lines.push(identityInsert(id, email));
}
for (const t of TEST_ACCOUNTS) {
  lines.push(authUserInsert(t.id, t.email));
  lines.push(identityInsert(t.id, t.email));
}
lines.push("");

// --- profiles (트리거가 생성한 행을 덮어쓰기) ---
lines.push("-- profiles");
function profileInsert(
  id: string,
  email: string,
  full_name: string | null,
  avatar_url: string | null,
  role: string,
  created_at?: string,
  updated_at?: string
): string {
  return `insert into public.profiles (id, email, full_name, username, avatar_url, website, role, created_at, updated_at)
values ('${id}', ${sq(email)}, ${sq(full_name)}, null, ${sq(avatar_url)}, null, ${sq(role)}, ${created_at ? ts(created_at) : "now()"}, ${updated_at ? ts(updated_at) : "now()"})
on conflict (id) do update set email = excluded.email, full_name = excluded.full_name, avatar_url = excluded.avatar_url, role = excluded.role, created_at = excluded.created_at, updated_at = excluded.updated_at;`;
}
for (const u of dummyUsers) {
  lines.push(
    profileInsert(
      userUuid(u.id),
      authEmail(u),
      u.full_name,
      u.avatar_url,
      u.role,
      u.created_at,
      u.updated_at ?? undefined
    )
  );
}
for (const t of TEST_ACCOUNTS) {
  lines.push(profileInsert(t.id, t.email, t.full_name, null, t.role));
}
lines.push("");

// --- events ---
lines.push("-- events");
for (const e of dummyEvents) {
  lines.push(
    `insert into public.events (id, title, description, location, event_date, cover_image_url, invite_code, status, created_by, created_at, updated_at)
values ('${eventUuid(e.id)}', ${sq(e.title)}, ${sq(e.description)}, ${sq(e.location)}, ${ts(e.event_date)}, ${sq(e.cover_image_url)}, ${sq(e.invite_code)}, ${sq(e.status)}, '${userUuid(e.created_by)}', ${ts(e.created_at)}, ${ts(e.updated_at)});`
  );
}
lines.push("");

// --- event_participants ---
lines.push("-- event_participants");
for (const p of dummyParticipants) {
  lines.push(
    `insert into public.event_participants (event_id, user_id, role, joined_at)
values ('${eventUuid(p.event_id)}', '${userUuid(p.user_id)}', ${sq(p.role)}, ${ts(p.joined_at)});`
  );
}
lines.push("");

const out = lines.join("\n");
mkdirSync(resolve(ROOT, "supabase"), { recursive: true });
writeFileSync(resolve(ROOT, "supabase", "seed.sql"), out, "utf8");
console.log(
  `생성 완료: supabase/seed.sql (사용자 ${dummyUsers.length + TEST_ACCOUNTS.length}, 이벤트 ${dummyEvents.length}, 참여 ${dummyParticipants.length})`
);
