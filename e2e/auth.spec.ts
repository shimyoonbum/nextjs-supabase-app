import { test, expect } from "@playwright/test";

/**
 * 인증 E2E (인증 불필요 - 렌더링/검증/보호 라우트)
 */
test.describe("인증 - 로그인 페이지", () => {
  test("로그인 폼이 렌더링된다", async ({ page }) => {
    await page.goto("/auth/login");
    // 이메일/비밀번호 입력과 제출 버튼 (CardTitle 은 heading 역할이 아니므로 폼 요소로 검증)
    await expect(page.locator('input[type="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
    await expect(page.getByRole("button", { name: "로그인", exact: true })).toBeVisible();
    // 구글 소셜 로그인 버튼
    await expect(page.getByRole("button", { name: /Google/ })).toBeVisible();
  });

  test("잘못된 자격증명으로 로그인하면 에러를 표시하고 페이지에 머문다", async ({ page }) => {
    await page.goto("/auth/login");
    await page.locator('input[type="email"]').fill("nonexistent-e2e@example.com");
    await page.locator('input[type="password"]').fill("definitely-wrong-password");
    await page.getByRole("button", { name: "로그인", exact: true }).click();

    // 로그인 페이지에 그대로 머무른다 (성공 시 / 로 이동했을 것)
    await expect(page).toHaveURL(/\/auth\/login/);
    // 에러 메시지(빨간 텍스트)가 표시된다
    await expect(page.locator("p.text-red-500")).toBeVisible({ timeout: 10000 });
  });
});

test.describe("인증 - 보호된 라우트 (미인증 리다이렉트)", () => {
  test("미인증 사용자가 /profile 접근 시 로그인으로 리다이렉트된다", async ({ page }) => {
    await page.goto("/profile");
    await expect(page).toHaveURL(/\/auth\/login/);
  });

  test("미인증 사용자가 /events 접근 시 로그인으로 리다이렉트된다", async ({ page }) => {
    await page.goto("/events");
    await expect(page).toHaveURL(/\/auth\/login/);
  });
});
