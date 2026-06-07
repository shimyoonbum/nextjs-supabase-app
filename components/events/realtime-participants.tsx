"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { getInitials } from "@/lib/utils/format";
import type { ParticipantWithUser } from "@/lib/types/models";

interface RealtimeParticipantsProps {
  eventId: string;
  initialParticipants: ParticipantWithUser[];
}

/**
 * 실시간 참여자 목록
 *
 * Supabase Realtime(postgres_changes)으로 event_participants 테이블의
 * 변경을 구독하여, 다른 사용자가 참여하거나 취소할 때 새로고침 없이
 * 목록과 인원수를 자동으로 갱신한다.
 *
 * 변경 페이로드에는 조인된 프로필 정보가 없으므로, 변경 감지 시
 * 사용자 정보를 포함한 참여자 목록을 다시 조회한다.
 */
export function RealtimeParticipants({ eventId, initialParticipants }: RealtimeParticipantsProps) {
  const [participants, setParticipants] = useState<ParticipantWithUser[]>(initialParticipants);

  useEffect(() => {
    const supabase = createClient();

    // 변경 발생 시 사용자 정보를 포함해 참여자 목록을 다시 조회
    const refetchParticipants = async () => {
      const { data } = await supabase
        .from("event_participants")
        .select(
          `id, event_id, user_id, role, joined_at,
           user:profiles!event_participants_user_id_fkey(id, username, avatar_url)`
        )
        .eq("event_id", eventId)
        .order("joined_at", { ascending: true });

      if (data) {
        setParticipants(
          data.map((p) => ({
            ...p,
            user: Array.isArray(p.user) ? p.user[0] : p.user,
          })) as ParticipantWithUser[]
        );
      }
    };

    // event_id 로 필터링하여 해당 이벤트의 참여자 변경만 구독
    const channel = supabase
      .channel(`event-participants:${eventId}`)
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "event_participants",
          filter: `event_id=eq.${eventId}`,
        },
        () => {
          refetchParticipants();
        }
      )
      .subscribe();

    // 언마운트 시 구독 해제 (메모리 누수 방지)
    return () => {
      supabase.removeChannel(channel);
    };
  }, [eventId]);

  return (
    <Card>
      <CardContent className="pt-6">
        <div className="space-y-4">
          <h2 className="font-semibold">참여자 {participants.length}명</h2>
          <div className="space-y-3">
            {participants.map((participant) => (
              <div key={participant.id} className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <Avatar>
                    <AvatarImage
                      src={participant.user.avatar_url ?? undefined}
                      alt={participant.user.username ?? ""}
                    />
                    <AvatarFallback>{getInitials(participant.user.username)}</AvatarFallback>
                  </Avatar>
                  <div>
                    <p className="font-medium">{participant.user.username}</p>
                  </div>
                </div>
                {participant.role === "host" && <Badge variant="secondary">호스트</Badge>}
              </div>
            ))}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
