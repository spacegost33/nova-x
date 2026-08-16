
#!/bin/bash

echo "🚀 NOVA-X Week 3 (Days 15–21) – Auth + Database"

# ======================
# 1. Install Supabase in web app
# ======================
cd apps/web
pnpm add @supabase/supabase-js
cd ../..

# ======================
# 2. Create Supabase client
# ======================
mkdir -p apps/web/lib

cat > apps/web/lib/supabase.ts << 'EOF'
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
EOF

# ======================
# 3. Create environment example
# ======================
cat > apps/web/.env.local.example << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=https://yjjmgzyvzsvepbmbmcyr.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_KPIzz3Hp5ivkEzB1VYZjRQ_YBvZ8AOT
EOF

# ======================
# 4. New full page with Auth + Database
# ======================
cat > apps/web/app/page.tsx << 'EOF'
"use client";

import { useState, useEffect, useRef } from "react";
import { supabase } from "../lib/supabase";

interface Message {
  id?: string;
  role: "user" | "assistant";
  content: string;
  understanding?: string;
  suggestion?: string;
  nextAction?: string;
  mood?: string;
  goal?: string | null;
}

export default function Home() {
  const [user, setUser] = useState<any>(null);
  const [loadingAuth, setLoadingAuth] = useState(true);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [authError, setAuthError] = useState("");
  const [isLogin, setIsLogin] = useState(true);

  const [input, setInput] = useState("");
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(false);
  const bottomRef = useRef<HTMLDivElement>(null);

  const API_URL = "https://nova-x-api.onrender.com";

  // Check auth state
  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoadingAuth(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => subscription.unsubscribe();
  }, []);

  // Load messages when user logs in
  useEffect(() => {
    if (user) {
      loadMessages();
    } else {
      setMessages([]);
    }
  }, [user]);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, loading]);

  async function loadMessages() {
    const { data, error } = await supabase
      .from("conversations")
      .select("*")
      .order("created_at", { ascending: true });

    if (data) {
      const formatted: Message[] = data.map((row) => ({
        id: row.id,
        role: row.role,
        content: row.content,
        understanding: row.understanding,
        suggestion: row.suggestion,
        nextAction: row.next_action,
        mood: row.mood,
        goal: row.goal,
      }));
      setMessages(formatted);
    }
  }

  async function saveMessage(msg: Message) {
    if (!user) return;

    await supabase.from("conversations").insert({
      user_id: user.id,
      role: msg.role,
      content: msg.content,
      understanding: msg.understanding || null,
      suggestion: msg.suggestion || null,
      next_action: msg.nextAction || null,
      mood: msg.mood || null,
      goal: msg.goal || null,
    });
  }

  async function handleAuth(e: React.FormEvent) {
    e.preventDefault();
    setAuthError("");

    if (isLogin) {
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) setAuthError(error.message);
    } else {
      const { error } = await supabase.auth.signUp({ email, password });
      if (error) setAuthError(error.message);
      else setAuthError("Check your email for confirmation link (if enabled)");
    }
  }

  async function handleLogout() {
    await supabase.auth.signOut();
    setMessages([]);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!input.trim() || loading || !user) return;

    const userMessage = input.trim();
    setInput("");
    setLoading(true);

    const newUserMsg: Message = { role: "user", content: userMessage };
    setMessages((prev) => [...prev, newUserMsg]);
    await saveMessage(newUserMsg);

    try {
      const res = await fetch(`${API_URL}/v1/think`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          message: userMessage,
          history: [...messages, newUserMsg].map((m) => ({
            role: m.role,
            content: m.content,
          })),
        }),
      });

      const data = await res.json();

      if (data.success) {
        const assistantMsg: Message = {
          role: "assistant",
          content: data.nextAction,
          understanding: data.understanding,
          suggestion: data.suggestion,
          nextAction: data.nextAction,
          mood: data.detectedMood,
          goal: data.detectedGoal,
        };
        setMessages((prev) => [...prev, assistantMsg]);
        await saveMessage(assistantMsg);
      }
    } catch (err) {
      const errorMsg: Message = {
        role: "assistant",
        content: "Sorry, I couldn't reach the server.",
      };
      setMessages((prev) => [...prev, errorMsg]);
    } finally {
      setLoading(false);
    }
  }

  if (loadingAuth) {
    return (
      <div style={{ minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center", background: "#0f0f13", color: "white" }}>
        Loading...
      </div>
    );
  }

  // ========== AUTH SCREEN ==========
  if (!user) {
    return (
      <main style={{ minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center", background: "linear-gradient(135deg, #0f0f13 0%, #1a1a2e 100%)", color: "white", fontFamily: "system-ui" }}>
        <div style={{ width: "100%", maxWidth: "400px", padding: "2rem" }}>
          <h1 style={{ textAlign: "center", fontSize: "2.2rem", marginBottom: "0.5rem", background: "linear-gradient(90deg, #a78bfa, #60a5fa)", WebkitBackgroundClip: "text", WebkitTextFillColor: "transparent" }}>
            NOVA-X
          </h1>
          <p style={{ textAlign: "center", opacity: 0.7, marginBottom: "2rem" }}>
            {isLogin ? "Welcome back" : "Create your account"}
          </p>

          <form onSubmit={handleAuth} style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
            <input
              type="email"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              style={{ padding: "0.9rem", borderRadius: "10px", border: "1px solid rgba(167,139,250,0.3)", background: "rgba(255,255,255,0.05)", color: "white", outline: "none" }}
            />
            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              style={{ padding: "0.9rem", borderRadius: "10px", border: "1px solid rgba(167,139,250,0.3)", background: "rgba(255,255,255,0.05)", color: "white", outline: "none" }}
            />
            {authError && <p style={{ color: "#fca5a5", fontSize: "0.9rem" }}>{authError}</p>}
            <button type="submit" style={{ padding: "0.9rem", borderRadius: "10px", border: "none", background: "linear-gradient(90deg, #a78bfa, #60a5fa)", color: "white", fontWeight: 600, cursor: "pointer" }}>
              {isLogin ? "Log In" : "Sign Up"}
            </button>
          </form>

          <p style={{ textAlign: "center", marginTop: "1.5rem", opacity: 0.6, fontSize: "0.9rem" }}>
            {isLogin ? "Don't have an account?" : "Already have an account?"}{" "}
            <button onClick={() => { setIsLogin(!isLogin); setAuthError(""); }} style={{ background: "none", border: "none", color: "#a78bfa", cursor: "pointer" }}>
              {isLogin ? "Sign Up" : "Log In"}
            </button>
          </p>
        </div>
      </main>
    );
  }

  // ========== MAIN APP ==========
  return (
    <main style={{ minHeight: "100vh", background: "linear-gradient(135deg, #0f0f13 0%, #1a1a2e 100%)", color: "white", fontFamily: "system-ui", display: "flex", flexDirection: "column" }}>
      <header style={{ padding: "1rem 1.5rem", borderBottom: "1px solid rgba(255,255,255,0.08)", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div>
          <h1 style={{ fontSize: "1.4rem", margin: 0, background: "linear-gradient(90deg, #a78bfa, #60a5fa)", WebkitBackgroundClip: "text", WebkitTextFillColor: "transparent" }}>NOVA-X</h1>
          <p style={{ margin: 0, fontSize: "0.75rem", opacity: 0.5 }}>{user.email}</p>
        </div>
        <button onClick={handleLogout} style={{ background: "transparent", border: "1px solid rgba(255,255,255,0.15)", color: "rgba(255,255,255,0.6)", padding: "0.4rem 0.8rem", borderRadius: "8px", cursor: "pointer", fontSize: "0.8rem" }}>
          Logout
        </button>
      </header>

      <div style={{ flex: 1, overflowY: "auto", padding: "1.5rem", display: "flex", flexDirection: "column", gap: "1.2rem", maxWidth: "720px", width: "100%", margin: "0 auto" }}>
        {messages.length === 0 && (
          <div style={{ textAlign: "center", marginTop: "12vh", opacity: 0.7 }}>
            <p style={{ fontSize: "1.2rem" }}>You don’t have to think about what to do next.</p>
            <p><strong>NOVA-X does.</strong></p>
          </div>
        )}

        {messages.map((msg, i) => (
          <div key={i}>
            {msg.role === "user" ? (
              <div style={{ background: "rgba(167, 139, 250, 0.15)", border: "1px solid rgba(167, 139, 250, 0.25)", padding: "0.9rem 1.1rem", borderRadius: "14px", maxWidth: "85%", marginLeft: "auto" }}>
                {msg.content}
              </div>
            ) : (
              <div style={{ background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.1)", borderRadius: "16px", padding: "1.2rem", maxWidth: "90%" }}>
                {msg.understanding && (
                  <div style={{ marginBottom: "0.8rem" }}>
                    <div style={{ fontSize: "0.75rem", opacity: 0.5, marginBottom: "0.2rem" }}>UNDERSTANDING</div>
                    <div>{msg.understanding}</div>
                  </div>
                )}
                {msg.suggestion && (
                  <div style={{ marginBottom: "0.8rem" }}>
                    <div style={{ fontSize: "0.75rem", opacity: 0.5, marginBottom: "0.2rem" }}>SUGGESTION</div>
                    <div>{msg.suggestion}</div>
                  </div>
                )}
                {msg.nextAction && (
                  <div style={{ background: "rgba(167, 139, 250, 0.12)", border: "1px solid rgba(167, 139, 250, 0.25)", borderRadius: "10px", padding: "0.8rem 1rem" }}>
                    <div style={{ fontSize: "0.75rem", opacity: 0.6, marginBottom: "0.2rem" }}>NEXT ACTION</div>
                    <div style={{ fontWeight: 500 }}>{msg.nextAction}</div>
                  </div>
                )}
              </div>
            )}
          </div>
        ))}

        {loading && <div style={{ opacity: 0.5 }}>NOVA-X is thinking...</div>}
        <div ref={bottomRef} />
      </div>

      <div style={{ padding: "1rem 1.5rem 1.5rem", borderTop: "1px solid rgba(255,255,255,0.08)", maxWidth: "720px", width: "100%", margin: "0 auto" }}>
        <form onSubmit={handleSubmit} style={{ display: "flex", gap: "0.75rem" }}>
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Tell NOVA-X what's on your mind..."
            style={{ flex: 1, padding: "0.9rem 1.1rem", borderRadius: "12px", border: "1px solid rgba(167, 139, 250, 0.3)", background: "rgba(255,255,255,0.05)", color: "white", fontSize: "1rem", outline: "none" }}
          />
          <button type="submit" disabled={loading || !input.trim()} style={{ padding: "0.9rem 1.4rem", borderRadius: "12px", border: "none", background: loading ? "rgba(167, 139, 250, 0.3)" : "linear-gradient(90deg, #a78bfa, #60a5fa)", color: "white", fontWeight: 600, cursor: loading ? "not-allowed" : "pointer" }}>
            Send
          </button>
        </form>
      </div>
    </main>
  );
}
EOF

echo ""
echo "✅ Week 3 files created!"
echo ""
echo "IMPORTANT: Now create the file apps/web/.env.local with your real keys:"
echo ""
echo "NEXT_PUBLIC_SUPABASE_URL=your_url_here"
echo "NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here"
echo ""
echo "Then run:"
echo "  pnpm install"
echo "  git add ."
echo "  git commit -m \"Week 3 (Days 15-21): Auth + Supabase + Permanent conversations\""
echo "  git push origin main"
echo ""
echo "Also add the same environment variables in Vercel Project Settings → Environment Variables"

