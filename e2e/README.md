# E2E 테스트 (Playwright)

`npm run test:e2e` 로 실행합니다. `playwright.config.ts` 가 자동으로 `npm run dev` 서버를 띄우고 `.env.local` 을 로드합니다.

## 테스트 분류

| 파일 | 인증 필요 | 내용 |
|---|---|---|
| `home.spec.ts` | ❌ | 랜딩 페이지 렌더링·CTA 이동 |
| `auth.spec.ts` | ❌ | 로그인 폼 렌더링, 잘못된 자격증명 에러, 보호 라우트 리다이렉트 |
| `admin.spec.ts` | ❌ | 관리자 로그인 페이지, /admin 보호 라우트 리다이렉트 |
| `authenticated.spec.ts` | ✅ 일반 | 로그인 후 이벤트 목록·생성 페이지 접근 |
| `admin-dashboard.spec.ts` | ✅ 관리자 | 관리자 로그인 → 대시보드 → 통계 차트(실데이터) |

## 인증 플로우 실행을 위한 환경변수

커밋된 비밀번호가 없으므로, 인증이 필요한 테스트는 아래 값이 `.env.local` 에 있을 때만 실행되고 없으면 건너뜁니다.

```
E2E_TEST_EMAIL=...
E2E_TEST_PASSWORD=...
E2E_ADMIN_EMAIL=...      # role='admin' 계정
E2E_ADMIN_PASSWORD=...
```

> 참여자 목록 **실시간 갱신**(Supabase Realtime)은 두 개의 인증 세션과 공유 이벤트가 필요하여 자동 E2E 대신 두 브라우저 탭으로 수동 검증을 권장합니다. (한 탭에서 참여 시 다른 탭의 참여자 목록·인원수가 새로고침 없이 갱신)
