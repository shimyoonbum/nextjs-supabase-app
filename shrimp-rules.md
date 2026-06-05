# 프로젝트 개발 규칙

> **중요**: 이 문서는 AI Agent 전용 운영 규칙이다. 일반 개발자 문서가 아니다.

## 1. 프로젝트 개요

- **목적**: 개발자 커뮤니티 이벤트 관리 플랫폼 (이벤트 생성 → 초대 코드 공유 → 참여자 모집)
- **스택**: Next.js App Router, Supabase (Auth + DB), Tailwind CSS v4, shadcn/ui (new-york), React Hook Form, Zod, Recharts, Playwright
- **핵심 도메인**: `profiles` (사용자), `events` (이벤트), `event_participants` (참여 관계)

---

## 2. 실제 디렉토리 구조

```
app/
├── (mobile)/              # 일반 사용자 앱 (MobileLayout: max-w-md + 하단 탭)
│   ├── events/            # 이벤트 CRUD 페이지
│   ├── profile/           # 프로필 페이지
│   ├── invite/[code]/     # 초대 링크 랜딩
│   └── join/[code]/       # 참여 처리
├── admin/
│   ├── login/             # 관리자 전용 로그인
│   └── (dashboard)/       # 관리자 대시보드 (AdminLayout: 사이드바)
│       ├── dashboard/     # KPI 지표
│       ├── events/        # 이벤트 관리 테이블
│       ├── users/         # 사용자 관리 테이블
│       └── stats/         # Recharts 차트
├── auth/                  # 인증 페이지 (login, sign-up, forgot-password 등)
├── actions/               # ⚠️ Server Actions (뮤테이션 전용)
│   ├── events.ts
│   ├── admin.ts
│   ├── auth.ts
│   ├── profile.ts
│   └── upload.ts
└── protected/             # 인증 필요 예시 라우트

lib/
├── queries/               # ⚠️ DB 읽기 전용 함수 (Server Components에서 호출)
│   ├── events.ts
│   ├── admin.ts
│   └── profile.ts
├── data/                  # 더미/시드 데이터 (개발·테스트용)
├── schemas/               # Zod 검증 스키마
│   ├── event.ts           # eventFormSchema
│   └── profile.ts
├── types/                 # TypeScript 타입 정의
│   ├── models.ts          # User, Event, EventParticipant, EventWithHost, EventDetail
│   ├── forms.ts           # ActionResult<T>, FormState<T>
│   ├── admin.ts           # DashboardMetrics, EventTableRow 등
│   └── index.ts           # 재export
├── supabase/
│   ├── server.ts          # createClient() - Server 전용
│   ├── client.ts          # createClient() - Browser 전용
│   ├── middleware.ts      # updateSession()
│   └── database.types.ts  # Supabase 자동 생성 타입 (직접 수정 금지)
└── utils/
    ├── admin.ts           # verifyAdminAccess() - 관리자 권한 확인
    ├── invite-code.ts     # generateUniqueInviteCode() - 초대 코드 생성
    ├── auth-errors.ts     # Supabase 에러 메시지 변환
    ├── date.ts
    ├── format.ts
    ├── toast.ts
    └── username.ts

components/
├── ui/                    # shadcn/ui 컴포넌트 (직접 생성 금지, CLI로만 추가)
├── admin/                 # 관리자 전용 컴포넌트
│   └── charts/            # Recharts 차트 컴포넌트
├── events/                # 이벤트 관련 컴포넌트
├── navigation/            # 네비게이션 (mobile-nav, admin-sidebar)
├── participants/          # 참여자 관련 컴포넌트
└── skeletons/             # 로딩 스켈레톤 컴포넌트
```

---

## 3. 기능 배치 의사결정 규칙 ⚠️

새 기능을 추가할 때 반드시 아래 기준으로 파일 위치를 결정하라:

| 작업 유형 | 배치 위치 | 예시 |
|---|---|---|
| DB 읽기 (SELECT) | `lib/queries/` | `getEventWithHost()`, `getUserHostedEvents()` |
| DB 쓰기 (INSERT/UPDATE/DELETE) | `app/actions/` | `createEventAction()`, `deleteEventAction()` |
| 일반 사용자 페이지 | `app/(mobile)/` | 이벤트 목록, 프로필 |
| 관리자 페이지 | `app/admin/(dashboard)/` | 통계, 사용자 관리 |
| 폼 검증 스키마 | `lib/schemas/` | `eventFormSchema`, `profileSchema` |
| 도메인 타입 | `lib/types/models.ts` | `User`, `Event`, `EventDetail` |
| Server Action 타입 | `lib/types/forms.ts` | `ActionResult<T>` |
| 관리자 전용 타입 | `lib/types/admin.ts` | `DashboardMetrics`, `EventTableRow` |

---

## 4. Server Actions 필수 패턴

### 4.1 표준 반환 타입

모든 Server Action은 반드시 `ActionResult<T>`를 반환하라 (`lib/types/forms.ts`):

```typescript
"use server";
import type { ActionResult } from "@/lib/types/forms";

export async function myAction(_prevState: ActionResult, formData: FormData): Promise<ActionResult<{ id: string }>> {
  try {
    const supabase = await createClient();           // A. 클라이언트 생성
    const { data: { user } } = await supabase.auth.getUser();  // B. 인증 확인
    if (!user) return { success: false, message: "로그인이 필요합니다." };

    const validated = mySchema.safeParse({...});    // C. Zod 검증
    if (!validated.success) return {
      success: false,
      message: "입력을 확인해주세요.",
      errors: validated.error.flatten().fieldErrors,
    };

    const { data, error } = await supabase.from("table").insert({...}).select().single();  // D. DB 작업
    if (error) return { success: false, message: error.message };

    revalidatePath("/path");                         // E. 캐시 무효화
    return { success: true, message: "성공", data: { id: data.id } };
  } catch {
    return { success: false, message: "오류가 발생했습니다." };
  }
}
```

### 4.2 revalidatePath 필수 규칙

- INSERT/UPDATE/DELETE 후 반드시 `revalidatePath()`를 호출하라
- 영향받는 모든 경로를 무효화하라 (목록 페이지 + 상세 페이지)
- 관리자 액션은 관리자 경로도 함께 무효화하라

### 4.3 useActionState 연동 패턴

```typescript
// Client Component에서 폼 연동
const [state, formAction] = useActionState(myAction, { success: false, message: "" });
```

---

## 5. 관리자 기능 구현 규칙 ⚠️

### 5.1 이중 권한 검증 필수

관리자 Server Action은 반드시 `verifyAdminAccess()`를 첫 번째로 호출하라:

```typescript
import { verifyAdminAccess } from "@/lib/utils/admin";

export async function adminOnlyAction(): Promise<ActionResult> {
  const authCheck = await verifyAdminAccess();  // ⚠️ 반드시 첫 번째
  if (!authCheck.authorized) return { success: false, message: authCheck.message };
  // 이후 로직...
}
```

- `verifyAdminAccess()`는 `profiles.role = 'admin'` 여부를 확인한다
- 미들웨어 체크 + Server Action 체크 이중 검증이 필수다
- 자기 자신 삭제 시 `authCheck.userId === targetId` 비교로 차단하라

### 5.2 관리자 라우트 접근 제어

- 미들웨어가 `/admin/*` 접근 시 자동으로 `profiles.role` 확인 후 비관리자를 `/`로 리다이렉트한다
- `/admin/login`은 미들웨어 체크 제외 경로다

---

## 6. Supabase 클라이언트 사용 규칙 ⚠️

### 6.1 환경별 클라이언트 구분

| 환경 | import | 금지 사항 |
|---|---|---|
| Server Components / Route Handlers / Server Actions | `@/lib/supabase/server` | 전역 변수 저장 금지 |
| Client Components (`'use client'`) | `@/lib/supabase/client` | server 클라이언트 사용 금지 |
| `middleware.ts` | `@/lib/supabase/middleware` | 직접 수정 시 주의 |

### 6.2 Server 클라이언트 생성 규칙

```typescript
// ✅ 올바름: 함수 내부에서 매번 새로 생성
export default async function Component() {
  const supabase = await createClient();
}

// ❌ 금지: 전역 변수로 저장
const supabase = await createClient(); // 모듈 최상위 금지
```

### 6.3 미들웨어 수정 금지 구간

`lib/supabase/middleware.ts`에서 `createServerClient`와 `supabase.auth.getClaims()` 사이에 코드를 추가하지 마라. 무작위 로그아웃이 발생한다.

### 6.4 FK 조인 패턴

Supabase에서 외래키 관계 조인 시 명시적 FK 이름을 사용하라:

```typescript
// ✅ 올바름
supabase.from("events").select(`
  *,
  host:profiles!events_created_by_fkey(id, username, avatar_url)
`)

// 참여자 목록 조인
supabase.from("event_participants").select(`
  id, role, joined_at,
  user:profiles!event_participants_user_id_fkey(id, username, avatar_url)
`)
```

---

## 7. 인증 흐름 규칙

- 미들웨어 (`middleware.ts`)가 모든 요청에서 `supabase.auth.getClaims()`로 세션 확인한다
- 미인증 사용자는 `/auth/login?redirect={원래경로}`로 리다이렉트된다
- `/auth/*` 경로는 미들웨어 인증 체크에서 제외된다
- `/` (홈)은 인증 없이 접근 가능하다

### 새 Response 객체 생성 시 쿠키 복사 필수

```typescript
const myNewResponse = NextResponse.next({ request });
myNewResponse.cookies.setAll(supabaseResponse.cookies.getAll()); // ⚠️ 필수
return myNewResponse;
```

---

## 8. 이벤트 도메인 특수 규칙

### 8.1 이벤트 생성 시 필수 처리

이벤트를 생성할 때 반드시 두 가지를 함께 처리하라:

```typescript
// 1. 초대 코드 생성 (중복 체크 포함)
const invite_code = await generateUniqueInviteCode(supabase); // lib/utils/invite-code.ts

// 2. 이벤트 삽입 후 즉시 주최자를 'host'로 event_participants에 추가
await supabase.from("event_participants").insert({
  event_id: event.id,
  user_id: user.id,
  role: "host",
});
```

### 8.2 이벤트 권한 검증

- 이벤트 수정/삭제: `event.created_by === user.id` 확인 필수
- 관리자 삭제: `verifyAdminAccess()` 호출로 대체
- 이벤트 상태: `'upcoming' | 'ongoing' | 'ended'`

### 8.3 참여자 역할

- `'host'`: 이벤트 생성자 (자동 추가)
- `'participant'`: 초대 코드로 참여한 사용자
- 중복 참여 방지: DB UNIQUE 제약 + 애플리케이션 레벨 이중 체크 (PGRST116 에러 코드: 결과 없음 = 정상)

---

## 9. 폼 처리 패턴

React Hook Form + Zod + Server Actions 조합을 사용하라:

```typescript
// Client Component
'use client';
import { useActionState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { mySchema, type MyFormData } from "@/lib/schemas/mySchema";

const [state, formAction] = useActionState(myServerAction, { success: false, message: "" });
const form = useForm<MyFormData>({ resolver: zodResolver(mySchema) });
```

- 클라이언트 검증: `zodResolver`로 react-hook-form에 연결
- 서버 검증: Server Action 내에서 `schema.safeParse()` 별도 실행 (이중 검증 필수)
- 에러 표시: `state.errors` (서버), `form.formState.errors` (클라이언트) 모두 처리하라

---

## 10. 타입 시스템 규칙

### 10.1 DB 타입 활용

```typescript
// ✅ DB 타입 기반으로 도메인 타입 정의
import { Database } from "@/lib/supabase/database.types";
export type User = Database["public"]["Tables"]["profiles"]["Row"];
export type Event = Database["public"]["Tables"]["events"]["Row"];
```

- `lib/supabase/database.types.ts`는 직접 수정하지 마라 (`npm run db:types`로 자동 생성)
- 새 도메인 타입은 `lib/types/models.ts`에 추가하라
- 관리자 전용 타입은 `lib/types/admin.ts`에 추가하라

### 10.2 확장 타입 패턴

```typescript
// 조인 결과 타입은 extends로 확장
export interface EventWithHost extends Event {
  host: Pick<User, "id" | "username" | "avatar_url">;
  participant_count: number;
}
```

---

## 11. 파일 명명 및 배치 규칙

- **파일명**: kebab-case (`event-card.tsx`, `invite-code.ts`)
- **컴포넌트명**: PascalCase (`export default function EventCard() {}`)
- **import**: 반드시 `@/*` 경로 별칭 사용 (상대 경로 `../../` 금지)
- **Server Component 기본값**: `'use client'`는 브라우저 API·이벤트 핸들러·React Hook이 필요한 경우만
- **조건부 클래스**: `cn()` 사용 (`import { cn } from "@/lib/utils"`)
- **인라인 스타일**: 금지 — Tailwind CSS만 사용
- **주석/문서**: 한국어 작성

---

## 12. shadcn/ui 컴포넌트 규칙

- 새 UI 컴포넌트 추가: `npx shadcn@latest add [component-name]`
- `components/ui/` 파일은 직접 생성하지 마라
- 스타일: `new-york` (components.json에 설정됨, 변경 금지)
- 아이콘: `lucide-react`만 사용 (`import { ChevronRight } from "lucide-react"`)

---

## 13. 다중 파일 조정 규칙

### 새 이벤트 관련 기능 추가 시

1. `lib/schemas/event.ts` — Zod 스키마 추가/수정
2. `lib/types/models.ts` — 타입 추가/수정
3. `lib/queries/events.ts` — 읽기 쿼리 추가
4. `app/actions/events.ts` — Server Action 추가
5. `app/(mobile)/events/` — 페이지/컴포넌트 추가
6. `components/events/` — 재사용 컴포넌트 추가

### 새 관리자 기능 추가 시

1. `lib/types/admin.ts` — 관리자 전용 타입 추가
2. `lib/queries/admin.ts` — 읽기 쿼리 추가
3. `app/actions/admin.ts` — Server Action 추가 (verifyAdminAccess() 필수)
4. `app/admin/(dashboard)/` — 관리자 페이지 추가
5. `components/admin/` — 관리자 컴포넌트 추가
6. `components/navigation/admin-sidebar.tsx` — 사이드바 메뉴 추가

### 인증 로직 수정 시

반드시 함께 확인할 파일:
- `middleware.ts`
- `lib/supabase/middleware.ts`
- `app/auth/*/page.tsx`

---

## 14. 코드 품질

```bash
npm run check-all   # TypeScript + ESLint + Prettier 통합 (커밋 전 필수)
npm run lint:fix    # ESLint 자동 수정
npm run format      # Prettier 포맷팅
npm run build       # 빌드 성공 확인
```

Husky pre-commit 훅이 자동으로 ESLint + Prettier를 실행한다. `--no-verify` 플래그로 우회하지 마라.

---

## 15. 금지 사항 ❌

1. **Supabase 클라이언트를 전역 변수로 저장** — Server Components에서 매번 새로 생성
2. **Server용 클라이언트를 Client Component에서 사용** — `@/lib/supabase/server`는 서버 전용
3. **`createServerClient`와 `getClaims()` 사이에 코드 추가** — 무작위 로그아웃 유발
4. **상대 경로 import** — 항상 `@/*` 사용
5. **인라인 스타일 사용** — Tailwind만 사용
6. **`any` 타입 남용** — 명시적 타입 정의
7. **관리자 Server Action에서 verifyAdminAccess() 생략** — 이중 검증 필수
8. **이벤트 생성 시 invite_code 생성 생략** — generateUniqueInviteCode() 필수
9. **이벤트 생성 시 host 참여자 추가 생략** — event_participants에 'host' 자동 추가 필수
10. **뮤테이션 후 revalidatePath() 생략** — 캐시 무효화 필수
11. **`database.types.ts` 직접 수정** — `npm run db:types`로만 갱신
12. **`components/ui/` 파일 직접 생성** — `npx shadcn@latest add`로만 추가
13. **`--no-verify`로 커밋 훅 우회** — Husky 훅 필수 통과
