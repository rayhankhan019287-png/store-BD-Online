import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title: "Store BD Online | Shop Smart, Save More", description: "Discover everyday essentials, electronics, fashion and more at Store BD Online." };
export default function RootLayout({ children }: { children: React.ReactNode }) { return <html lang="en"><body>{children}</body></html>; }
