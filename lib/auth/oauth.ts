"use client";

import { createClient } from "@/lib/supabase/client";

/**
 * Google OAuth 로그인
 *
 * @param redirectPath - 로그인 성공 후 리다이렉트할 경로 (기본값: '/')
 * @returns Supabase Auth 응답 객체
 */
export async function signInWithGoogle(redirectPath: string = "/") {
  const supabase = createClient();

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      // redirectPath가 쿼리스트링(예: /events?tab=mine)을 포함해도 깨지지 않도록 인코딩
      redirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(redirectPath)}`,
    },
  });

  return { data, error };
}
