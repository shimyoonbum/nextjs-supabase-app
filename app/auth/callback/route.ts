import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";
import { type NextRequest } from "next/server";

/**
 * 안전한 내부 리다이렉트 경로인지 검증한다.
 *
 * 오픈 리다이렉트(open redirect)를 방지하기 위해 "/"로 시작하면서
 * "//"(프로토콜 상대 외부 URL)가 아닌 내부 경로만 허용한다.
 */
function sanitizeNext(next: string): string {
  if (!next.startsWith("/") || next.startsWith("//")) {
    return "/";
  }
  return next;
}

/**
 * 환경에 맞는 절대 리다이렉트 URL을 생성한다.
 *
 * 프로덕션에서는 프록시 뒤에서 동작하므로 x-forwarded-host를 우선 사용하고,
 * 로컬 개발 환경에서는 origin을 그대로 사용한다.
 */
function buildRedirectUrl(request: NextRequest, origin: string, path: string): string {
  const forwardedHost = request.headers.get("x-forwarded-host");
  const isLocalEnv = process.env.NODE_ENV === "development";

  if (!isLocalEnv && forwardedHost) {
    return `https://${forwardedHost}${path}`;
  }
  return `${origin}${path}`;
}

/** 에러 페이지로 리다이렉트하는 헬퍼 */
function redirectToError(request: NextRequest, origin: string, message: string) {
  return NextResponse.redirect(
    buildRedirectUrl(request, origin, `/auth/error?error=${encodeURIComponent(message)}`)
  );
}

/**
 * OAuth 인증 콜백 핸들러
 *
 * Google OAuth 인증 후 리다이렉트되어 인증 코드를 세션으로 교환합니다.
 * 신규 사용자(닉네임 미설정)는 프로필 설정 페이지로 유도합니다.
 */
export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = sanitizeNext(searchParams.get("next") ?? "/");

  // OAuth 제공자가 에러를 반환한 경우 (예: 사용자가 Google 동의 화면에서 거부)
  const oauthError = searchParams.get("error");
  if (oauthError) {
    const description = searchParams.get("error_description");
    return redirectToError(request, origin, description || oauthError);
  }

  // 인증 코드가 없는 경우
  if (!code) {
    return redirectToError(request, origin, "인증 코드가 없습니다");
  }

  const supabase = await createClient();
  const { error } = await supabase.auth.exchangeCodeForSession(code);

  // 코드 교환 실패
  if (error) {
    return redirectToError(request, origin, error.message);
  }

  // 인증 성공: 닉네임 미설정 사용자는 프로필 설정 페이지로 유도 (next 보존)
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("username")
      .eq("id", user.id)
      .single();

    if (!profile?.username) {
      const setupUrl = `/auth/setup-profile?next=${encodeURIComponent(next)}`;
      return NextResponse.redirect(buildRedirectUrl(request, origin, setupUrl));
    }
  }

  // 닉네임이 있으면 원래 페이지로 리다이렉트
  return NextResponse.redirect(buildRedirectUrl(request, origin, next));
}
