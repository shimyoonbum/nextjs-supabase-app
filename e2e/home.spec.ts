import { test, expect } from "@playwright/test";

/**
 * 홈/랜딩 페이지 E2E (인증 불필요)
 */
test.describe("홈/랜딩 페이지", () => {
  test("브랜드와 CTA 버튼이 렌더링된다", async ({ page }) => {
    await page.goto("/");
    await expect(page.getByRole("heading", { name: "Gather" })).toBeVisible();
    await expect(page.getByRole("link", { name: "Google로 시작하기" })).toBeVisible();
  });

  test("CTA 클릭 시 로그인 페이지로 이동한다", async ({ page }) => {
    await page.goto("/");
    await page.getByRole("link", { name: "Google로 시작하기" }).click();
    await expect(page).toHaveURL(/\/auth\/login/);
  });
});
