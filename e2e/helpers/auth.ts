import { type Page } from "@playwright/test";

/**
 * E2E 테스트용 자격증명
 *
 * 인증이 필요한 플로우 테스트는 아래 환경변수가 .env.local 에 설정된 경우에만 실행된다.
 * (커밋된 비밀번호가 없으므로 자격증명이 없으면 해당 테스트는 건너뛴다)
 *
 *   E2E_TEST_EMAIL / E2E_TEST_PASSWORD   - 일반 사용자
 *   E2E_ADMIN_EMAIL / E2E_ADMIN_PASSWORD - 관리자 (role='admin')
 */
export const testUser = {
  email: process.env.E2E_TEST_EMAIL,
  password: process.env.E2E_TEST_PASSWORD,
};

export const adminUser = {
  email: process.env.E2E_ADMIN_EMAIL,
  password: process.env.E2E_ADMIN_PASSWORD,
};

export function hasUserCreds(): boolean {
  return Boolean(testUser.email && testUser.password);
}

export function hasAdminCreds(): boolean {
  return Boolean(adminUser.email && adminUser.password);
}

/**
 * 로그인 폼(UI)을 통해 이메일/비밀번호로 로그인한다.
 *
 * @param loginPath - 로그인 페이지 경로 (일반: /auth/login, 관리자: /admin/login)
 */
export async function loginViaUI(
  page: Page,
  email: string,
  password: string,
  loginPath = "/auth/login"
): Promise<void> {
  await page.goto(loginPath);
  await page.locator('input[type="email"]').fill(email);
  await page.locator('input[type="password"]').fill(password);
  await page.getByRole("button", { name: "로그인", exact: true }).click();
}
