import { test, expect } from "@playwright/test";

/**
 * 관리자 인증/권한 E2E (인증 불필요 - 렌더링/보호 라우트)
 */
test.describe("관리자 - 인증/권한", () => {
  test("관리자 로그인 페이지가 렌더링된다", async ({ page }) => {
    await page.goto("/admin/login");
    await expect(page.locator('input[type="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
  });

  test("미인증 사용자가 /admin/dashboard 접근 시 관리자 로그인으로 리다이렉트된다", async ({
    page,
  }) => {
    await page.goto("/admin/dashboard");
    await expect(page).toHaveURL(/\/admin\/login/);
  });
});
