#!/bin/bash

echo "🚀 Starting NOVA-X Day 6 – Clean UI"

cat > apps/web/app/page.tsx << 'EOF'
"use client";

import { useState } from "react";

interface NovaResponse {
  success: boolean;
  input: string;
  understanding: string;
  suggestion: string;
  nextAction: string;
  confidence: number;
  coreVersion: string;
}

export default function Home() {
  const [input, setInput] = useState("");
  const [response, setResponse] = useState<NovaResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const API_URL = "https://nova-x-api.onrender.com";

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!input.trim()) return;

    setLoading(true);
    setResponse(null);
    setError(null);

    try {
      const res = await fetch(`${API_URL}/v1/think`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ message: input }),
      });

      const data = await res.json();

      if (data.success) {
        setResponse(data);
      } else {
        setError(data.error || "Something went wrong");
      }
    } catch (err) {
      setError("Could not reach NOVA-X. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <main
      style={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        background: "linear-gradient(135deg, #0f0f13 0%, #1a1a2e 100%)",
        color: "white",
        fontFamily: "system-ui, -apple-system, sans-serif",
        padding: "2rem",
      }}
    >
      <div style={{ maxWidth: "640px", width: "100%" }}>
        {/* Header */}
        <h1
          style={{
            fontSize: "3rem",
            fontWeight: 700,
            marginBottom: "0.5rem",
            textAlign: "center",
            background: "linear-gradient(90deg, #a78bfa, #60a5fa)",
            WebkitBackgroundClip: "text",
            WebkitTextFillColor: "transparent",
          }}
        >
          NOVA-X
        </h1>

        <p
          style={{
            textAlign: "center",
            opacity: 0.85,
            marginBottom: "2.5rem",
            fontSize: "1.15rem",
            lineHeight: 1.5,
          }}
        >
          You don’t have to think about what to do next.
          <br />
          <strong>NOVA-X does.</strong>
        </p>

        {/* Input Form */}
        <form onSubmit={handleSubmit} style={{ marginBottom: "2rem" }}>
          <textarea
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Tell NOVA-X what’s on your mind..."
            rows={4}
            style={{
              width: "100%",
              padding: "1rem 1.2rem",
              borderRadius: "14px",
              border: "1px solid rgba(167, 139, 250, 0.35)",
              background: "rgba(255,255,255,0.05)",
              color: "white",
              fontSize: "1rem",
              resize: "none",
              outline: "none",
              lineHeight: 1.5,
            }}
          />

          <button
            type="submit"
            disabled={loading}
            style={{
              marginTop: "1rem",
              width: "100%",
              padding: "0.95rem",
              borderRadius: "14px",
              border: "none",
              background: loading
                ? "rgba(167, 139, 250, 0.3)"
                : "linear-gradient(90deg, #a78bfa, #60a5fa)",
              color: "white",
              fontSize: "1.05rem",
              fontWeight: 600,
              cursor: loading ? "not-allowed" : "pointer",
              transition: "opacity 0.2s",
            }}
          >
            {loading ? "Thinking..." : "Ask NOVA-X"}
          </button>
        </form>

        {/* Error */}
        {error && (
          <div
            style={{
              background: "rgba(239, 68, 68, 0.15)",
              border: "1px solid rgba(239, 68, 68, 0.4)",
              borderRadius: "14px",
              padding: "1rem 1.2rem",
              color: "#fca5a5",
              marginBottom: "1.5rem",
            }}
          >
            {error}
          </div>
        )}

        {/* Clean Response */}
        {response && (
          <div
            style={{
              background: "rgba(255,255,255,0.04)",
              border: "1px solid rgba(167, 139, 250, 0.25)",
              borderRadius: "16px",
              padding: "1.5rem",
              display: "flex",
              flexDirection: "column",
              gap: "1.25rem",
            }}
          >
            <div>
              <div style={{ fontSize: "0.8rem", opacity: 0.6, marginBottom: "0.35rem", letterSpacing: "0.03em" }}>
                UNDERSTANDING
              </div>
              <div style={{ fontSize: "1.05rem", lineHeight: 1.5 }}>
                {response.understanding}
              </div>
            </div>

            <div>
              <div style={{ fontSize: "0.8rem", opacity: 0.6, marginBottom: "0.35rem", letterSpacing: "0.03em" }}>
                SUGGESTION
              </div>
              <div style={{ fontSize: "1.05rem", lineHeight: 1.5 }}>
                {response.suggestion}
              </div>
            </div>

            <div
              style={{
                background: "rgba(167, 139, 250, 0.12)",
                border: "1px solid rgba(167, 139, 250, 0.25)",
                borderRadius: "12px",
                padding: "1rem 1.2rem",
              }}
            >
              <div style={{ fontSize: "0.8rem", opacity: 0.7, marginBottom: "0.35rem", letterSpacing: "0.03em" }}>
                NEXT ACTION
              </div>
              <div style={{ fontSize: "1.1rem", fontWeight: 500, lineHeight: 1.5 }}>
                {response.nextAction}
              </div>
            </div>

            <div style={{ fontSize: "0.75rem", opacity: 0.4, textAlign: "right" }}>
              Confidence: {Math.round(response.confidence * 100)}% · Core v{response.coreVersion}
            </div>
          </div>
        )}
      </div>
    </main>
  );
}
EOF

echo ""
echo "✅ Day 6 UI updated!"
echo ""
echo "Now run:"
echo "git add ."
echo "git commit -m \"Day 6: Clean and beautiful response UI\""
echo "git push origin main"
