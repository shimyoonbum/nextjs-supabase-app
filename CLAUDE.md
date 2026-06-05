# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

개발자 커뮤니티 이벤트 관리 플랫폼입니다. 사용자는 이벤트를 생성하고 초대 코드로 참여자를 모집할 수 있으며, 관리자는 별도 대시보드에서 전체 데이터를 관리합니다.

> 상세 코딩 규칙은 `shrimp-rules.md`를 참조하라. 이 파일의 규칙이 CLAUDE.md보다 우선한다.

## 기술 스택

- **프레임워크**: Next.js (최신, App Router + Turbopack)
- **인증/DB**: Supabase (`@supabase/ssr`, `@supabase/supabase-js`)
- **스타일링**: Tailwind CSS v4
- **UI**: shadcn/ui (new-york 스타일), Radix UI, Lucide React
- **폼 처리**: React Hook Form + Zod + `useActionState`
- **차트**: Recharts (관리자 대시보드)
- **토스트**: Sonner
- **E2E 테스트**: Playwright
- **코드 품질**: Husky (pre-commit) + lint-staged (ESLint + Prettier)

## 개발 명령어

```bash
npm run dev          # 개발 서버 (Turbopack)
npm run build        # 프로덕션 빌드
npm run check-all    # TypeScript + ESLint + Prettier 통합 검사 (커밋 전 권장)

# E2E 테스트
npm run test:e2e          # Playwright 헤드리스 실행
npm run test:e2e:ui       # Playwright UI 모드
npm run test:e2e:headed   # 브라우저 표시 실행

# DB 타입 생성
npm run db:types          # 원격 Supabase 프로젝트에서 타입 생성
npm run db:types:local    # 로컬 Supabase에서 타입 생성

# shadcn/ui 컴포넌트 추가
npx shadcn@latest add [component-name]
```

## 필수 환경 변수 (`.env.local`)

```
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=
```

환경 변수가 없으면 미들웨어 인증 체크를 자동으로 건너뜁니다.

## 아키텍처

### 라우트 구조

```
app/
├── (mobile)/           # 일반 사용자 앱 (MobileLayout: max-w-md, 하단 탭 네비게이션)
│   ├── events/         # 이벤트 목록/상세/생성/수정
│   ├── profile/        # 내 프로필 조회/수정
│   ├── invite/[code]/  # 초대 링크 랜딩 페이지
│   └── join/[code]/    # 이벤트 참여 처리
├── admin/
│   ├── login/          # 관리자 로그인 (별도 페이지)
│   └── (dashboard)/    # 관리자 대시보드 (AdminLayout: 사이드바)
│       ├── dashboard/  # KPI 지표
│       ├── events/     # 이벤트 관리 테이블
│       ├── users/      # 사용자 관리 테이블
│       └── stats/      # Recharts 차트
├── auth/               # 인증 관련 (로그인, 회원가입, 이메일 확인 등)
└── protected/          # 인증 필요 예시 라우트
```

### 데이터 레이어 분리

```
lib/
├── queries/    # Server Component용 DB 읽기 함수 (createClient() 내부 호출)
├── data/       # 개발/테스트용 더미 데이터
├── schemas/    # Zod 검증 스키마 (event.ts, profile.ts)
├── types/      # TypeScript 타입 (models.ts, forms.ts, admin.ts 등)
└── utils/
    ├── admin.ts        # verifyAdminAccess() - 모든 관리자 Action에서 사용
    ├── invite-code.ts  # 이벤트 초대 코드 생성 (중복 체크 포함)
    └── auth-errors.ts  # Supabase 인증 에러 메시지 변환

app/actions/    # Server Actions (뮤테이션): auth.ts, events.ts, admin.ts, profile.ts, upload.ts
```

### Supabase 클라이언트 패턴

세 가지 클라이언트를 환경에 따라 구분해서 사용합니다:

| 환경 | import 경로 | 주의사항 |
|---|---|---|
| Server Components / Route Handlers | `@/lib/supabase/server` | 함수 내부에서 매번 새로 생성 (전역 변수 금지) |
| Client Components | `@/lib/supabase/client` | `createBrowserClient` 기반 |
| Middleware | `@/lib/supabase/middleware` | `updateSession()` 사용 |

### 인증 및 권한 흐름

- **미들웨어** (`middleware.ts`): 모든 요청에서 `supabase.auth.getClaims()`로 세션 확인
  - `/admin/*` → `profiles.role = 'admin'` 추가 확인 후, 아니면 `/`로 리다이렉트
  - `/auth/*` 경로는 인증 체크 제외
  - 미인증 시 `/auth/login?redirect={원래경로}`로 리다이렉트
- **관리자 Server Actions**: `verifyAdminAccess()` 호출로 이중 검증 (`lib/utils/admin.ts`)
- **이벤트 소유권**: Server Action 내에서 `events.created_by === user.id` 직접 비교

**미들웨어 수정 시 절대 금지**: `createServerClient`와 `supabase.auth.getClaims()` 사이에 코드 추가 금지 (무작위 로그아웃 유발)

### Server Actions 패턴

모든 Server Action은 `ActionResult<T>` 타입을 반환합니다 (`lib/types/forms.ts`):

```typescript
type ActionResult<T = unknown> = {
  success: boolean;
  message: string;
  data?: T;
  errors?: Record<string, string[]>;  // Zod fieldErrors 형식
};
```

폼에서는 `useActionState` + Zod 이중 검증 패턴을 사용합니다 (클라이언트 사이드 react-hook-form, 서버 사이드 `schema.safeParse()`).

### 데이터 모델

핵심 테이블 3개:
- `profiles` - `auth.users` 확장, `role: 'user' | 'admin'` 컬럼 포함
- `events` - `status: 'upcoming' | 'ongoing' | 'ended'`, `invite_code` (고유), `created_by → profiles.id`
- `event_participants` - `role: 'host' | 'participant'`, 이벤트 생성 시 주최자가 `host`로 자동 추가

Supabase FK 조인 패턴:
```typescript
supabase.from("events").select(`
  *,
  host:profiles!events_created_by_fkey(id, username, avatar_url)
`)
```

## 코딩 컨벤션

- **파일명**: kebab-case (`user-profile.tsx`)
- **컴포넌트명**: PascalCase (`export default function UserProfile() {}`)
- **import**: 항상 `@/*` 경로 별칭 사용 (상대 경로 금지)
- **조건부 클래스**: `cn()` 유틸리티 사용 (`import { cn } from "@/lib/utils"`)
- **인라인 스타일**: 금지 — Tailwind CSS 유틸리티 클래스만 사용
- **컴포넌트 기본값**: Server Component. `'use client'`는 브라우저 API/이벤트 핸들러/React Hook이 필요한 경우만
- **주석/문서**: 한국어 작성, 변수명/함수명은 영어

## 테스트 계정

- 일반 사용자: gymcoding@gmail.com / qwer1234
- 관리자: bruce.lean17@gmail.com / qwer1234