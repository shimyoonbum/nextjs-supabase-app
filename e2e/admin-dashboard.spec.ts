import { test, expect } from "@playwright/test";
import { hasAdminCreds, adminUser, loginViaUI } from "./helpers/auth";

/**
 * 관리자 대시보드 플로우 E2E
 *
 * E2E_ADMIN_EMAIL/E2E_ADMIN_PASSWORD (role='admin') 가 설정된 경우에만 실행된다.
 */
test.describe("관리자 대시보드 플로우", () => {
  test("관리자 로그인 후 대시보드와 통계 차트가 표시된다", async ({ page }) => {
    test.skip(!hasAdminCreds(), "E2E_ADMIN_EMAIL/E2E_ADMIN_PASSWORD 환경변수가 없어 건너뜀");

    await loginViaUI(page, adminUser.email!, adminUser.password!, "/admin/login");
    await expect(page).toHaveURL(/\/admin\/dashboard/, { timeout: 15000 });

    // 통계 페이지의 실데이터 차트(W3)가 렌더링되는지 확인
    await page.goto("/admin/stats");
    await expect(page.getByText("이벤트 상태 분포")).toBeVisible();
    await expect(page.getByText("인기 이벤트 TOP 5")).toBeVisible();
  });
});
