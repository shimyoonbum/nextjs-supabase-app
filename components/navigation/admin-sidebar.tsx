"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useTransition } from "react";
import { LayoutDashboard, Calendar, Users, BarChart3, LogOut } from "lucide-react";
import { signOut } from "@/app/actions/auth";

interface MenuItem {
  label: string;
  href: string;
  icon: React.ComponentType<{ className?: string }>;
}

const menuItems: MenuItem[] = [
  { label: "대시보드", href: "/admin/dashboard", icon: LayoutDashboard },
  { label: "이벤트 관리", href: "/admin/events", icon: Calendar },
  { label: "사용자 관리", href: "/admin/users", icon: Users },
  { label: "통계 분석", href: "/admin/stats", icon: BarChart3 },
];

export function AdminSidebar() {
  const pathname = usePathname();
  const [isPending, startTransition] = useTransition();

  const isActive = (path: string) => pathname === path;

  const handleSignOut = () => {
    startTransition(async () => {
      await signOut();
    });
  };

  return (
    <aside className="bg-sidebar text-sidebar-foreground flex min-h-screen w-60 flex-col">
      {/* 로고 영역 */}
      <div className="border-sidebar-border flex h-16 items-center justify-center border-b">
        <Link href="/admin/dashboard" className="text-xl font-bold">
          Gather Admin
        </Link>
      </div>

      {/* 메뉴 리스트 */}
      <nav className="flex-1 py-4">
        {menuItems.map((item) => {
          const Icon = item.icon;
          const active = isActive(item.href);

          return (
            <Link
              key={item.href}
              href={item.href}
              className={`hover:bg-sidebar-accent hover:text-sidebar-accent-foreground flex items-center gap-3 px-4 py-3 transition-colors ${
                active
                  ? "border-primary bg-sidebar-accent text-sidebar-accent-foreground border-l-4"
                  : ""
              }`}
            >
              <Icon className="h-5 w-5" />
              <span className={active ? "font-semibold" : ""}>{item.label}</span>
            </Link>
          );
        })}
      </nav>

      {/* 로그아웃 버튼 */}
      <div className="border-sidebar-border border-t p-4">
        <button
          className="hover:bg-sidebar-accent hover:text-sidebar-accent-foreground flex w-full items-center gap-3 rounded px-4 py-3 transition-colors disabled:cursor-not-allowed disabled:opacity-50"
          onClick={handleSignOut}
          disabled={isPending}
        >
          <LogOut className="h-5 w-5" />
          <span>{isPending ? "로그아웃 중..." : "로그아웃"}</span>
        </button>
      </div>
    </aside>
  );
}
