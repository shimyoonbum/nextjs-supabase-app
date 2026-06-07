import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { EventForm } from "@/components/events/event-form";

/**
 * 이벤트 생성 페이지 (Server Component)
 *
 * 로그인한 사용자라면 누구나 이벤트를 생성할 수 있습니다.
 * 미인증 사용자는 로그인 페이지로 리다이렉트됩니다(완료 후 다시 생성 페이지로 복귀).
 */
export default async function NewEventPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // 미인증 사용자는 로그인 페이지로 (원래 경로 보존)
  if (!user) {
    redirect("/auth/login?redirect=/events/new");
  }

  return <EventForm />;
}
