import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Velora — Design Studio",
  description: "Create, edit, and collaborate on beautiful designs with Velora.",
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
