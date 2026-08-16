"use client";

import { useState } from "react";

export default function Home() {
  const [input, setInput] = useState("");
  const [response, setResponse] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const API_URL = "https://nova-x-api.onrender.com";

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!input.trim()) return;

    setLoading(true);
    setResponse(null);

    try {
      const res = await fetch(`${API_URL}/v1/think`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ message: input }),
      });

      const data = await res.json();
      setResponse(JSON.stringify(data, null, 2));
    } catch (err) {
      setResponse("Error: Could not reach NOVA-X API");
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
          }}
        >
          You don’t have to think about what to do next.
          <br />
          <strong>NOVA-X does.</strong>
        </p>

        {/* Input Form */}
        <form onSubmit={handleSubmit} style={{ marginBottom: "1.5rem" }}>
          <textarea
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Tell NOVA-X what’s on your mind..."
            rows={4}
            style={{
              width: "100%",
              padding: "1rem",
              borderRadius: "12px",
              border: "1px solid rgba(167, 139, 250, 0.4)",
              background: "rgba(255,255,255,0.05)",
              color: "white",
              fontSize: "1rem",
              resize: "none",
              outline: "none",
            }}
          />

          <button
            type="submit"
            disabled={loading}
            style={{
              marginTop: "1rem",
              width: "100%",
              padding: "0.9rem",
              borderRadius: "12px",
              border: "none",
              background: loading
                ? "rgba(167, 139, 250, 0.3)"
                : "linear-gradient(90deg, #a78bfa, #60a5fa)",
              color: "white",
              fontSize: "1rem",
              fontWeight: 600,
              cursor: loading ? "not-allowed" : "pointer",
            }}
          >
            {loading ? "Thinking..." : "Ask NOVA-X"}
          </button>
        </form>

        {/* Response */}
        {response && (
          <div
            style={{
              background: "rgba(255,255,255,0.05)",
              border: "1px solid rgba(167, 139, 250, 0.3)",
              borderRadius: "12px",
              padding: "1.2rem",
              whiteSpace: "pre-wrap",
              fontSize: "0.95rem",
              lineHeight: 1.5,
            }}
          >
            <strong style={{ opacity: 0.7 }}>NOVA-X Response:</strong>
            <pre style={{ marginTop: "0.8rem", margin: 0 }}>{response}</pre>
          </div>
        )}
      </div>
    </main>
  );
}
