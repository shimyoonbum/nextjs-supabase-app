import { test, expect } from "@playwright/test";
import { hasUserCreds, testUser, loginViaUI } from "./helpers/auth";

/**
 * 인증된 일반 사용자 플로우 E2E
 *
 * E2E_TEST_EMAIL/E2E_TEST_PASSWORD 가 설정된 경우에만 실행된다.
 */
test.describe("인증된 사용자 플로우", () => {
  test("로그인 후 이벤트 목록과 생성 페이지에 접근할 수 있다", async ({ page }) => {
    test.skip(!hasUserCreds(), "E2E_TEST_EMAIL/E2E_TEST_PASSWORD 환경변수가 없어 건너뜀");

    await loginViaUI(page, testUser.email!, testUser.password!);

    // 로그인 성공 시 보호된 페이지 접근 가능
    await page.goto("/events");
    await expect(page).toHaveURL(/\/events/);

    // 이벤트 생성 페이지 접근 (로그인 게이트 통과 확인 - 로그인으로 튕기지 않아야 함)
    await page.goto("/events/new");
    await expect(page).toHaveURL(/\/events\/new/);
  });
});
