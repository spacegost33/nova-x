"use client";

import { useState, useEffect, useRef } from "react";

interface Message {
  role: "user" | "assistant";
  content: string;
  understanding?: string;
  suggestion?: string;
  nextAction?: string;
  mood?: string;
  goal?: string | null;
}

export default function Home() {
  const [input, setInput] = useState("");
  const [messages, setMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState(false);
  const bottomRef = useRef<HTMLDivElement>(null);

  const API_URL = "https://nova-x-api.onrender.com";

  // Load from localStorage on mount
  useEffect(() => {
    const saved = localStorage.getItem("nova-x-history");
    if (saved) {
      try {
        setMessages(JSON.parse(saved));
      } catch {}
    }
  }, []);

  // Save to localStorage whenever messages change
  useEffect(() => {
    if (messages.length > 0) {
      localStorage.setItem("nova-x-history", JSON.stringify(messages));
    }
  }, [messages]);

  // Auto scroll
  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, loading]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!input.trim() || loading) return;

    const userMessage = input.trim();
    setInput("");
    setLoading(true);

    const newUserMsg: Message = { role: "user", content: userMessage };
    const updatedMessages = [...messages, newUserMsg];
    setMessages(updatedMessages);

    try {
      const res = await fetch(`${API_URL}/v1/think`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          message: userMessage,
          history: updatedMessages.map((m) => ({
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
      }
    } catch (err) {
      setMessages((prev) => [
        ...prev,
        {
          role: "assistant",
          content: "Sorry, I couldn't reach the server. Please try again.",
        },
      ]);
    } finally {
      setLoading(false);
    }
  }

  function clearHistory() {
    setMessages([]);
    localStorage.removeItem("nova-x-history");
  }

  return (
    <main
      style={{
        minHeight: "100vh",
        background: "linear-gradient(135deg, #0f0f13 0%, #1a1a2e 100%)",
        color: "white",
        fontFamily: "system-ui, -apple-system, sans-serif",
        display: "flex",
        flexDirection: "column",
      }}
    >
      {/* Header */}
      <header
        style={{
          padding: "1.2rem 1.5rem",
          borderBottom: "1px solid rgba(255,255,255,0.08)",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <div>
          <h1
            style={{
              fontSize: "1.5rem",
              fontWeight: 700,
              margin: 0,
              background: "linear-gradient(90deg, #a78bfa, #60a5fa)",
              WebkitBackgroundClip: "text",
              WebkitTextFillColor: "transparent",
            }}
          >
            NOVA-X
          </h1>
          <p style={{ margin: 0, fontSize: "0.8rem", opacity: 0.6 }}>
            Intelligent Life OS
          </p>
        </div>
        {messages.length > 0 && (
          <button
            onClick={clearHistory}
            style={{
              background: "transparent",
              border: "1px solid rgba(255,255,255,0.15)",
              color: "rgba(255,255,255,0.6)",
              padding: "0.4rem 0.8rem",
              borderRadius: "8px",
              cursor: "pointer",
              fontSize: "0.8rem",
            }}
          >
            Clear
          </button>
        )}
      </header>

      {/* Messages */}
      <div
        style={{
          flex: 1,
          overflowY: "auto",
          padding: "1.5rem",
          display: "flex",
          flexDirection: "column",
          gap: "1.2rem",
          maxWidth: "720px",
          width: "100%",
          margin: "0 auto",
        }}
      >
        {messages.length === 0 && (
          <div
            style={{
              textAlign: "center",
              marginTop: "15vh",
              opacity: 0.7,
            }}
          >
            <p style={{ fontSize: "1.3rem", marginBottom: "0.5rem" }}>
              You don’t have to think about what to do next.
            </p>
            <p style={{ fontSize: "1.1rem" }}>
              <strong>NOVA-X does.</strong>
            </p>
          </div>
        )}

        {messages.map((msg, i) => (
          <div key={i}>
            {msg.role === "user" ? (
              <div
                style={{
                  background: "rgba(167, 139, 250, 0.15)",
                  border: "1px solid rgba(167, 139, 250, 0.25)",
                  padding: "0.9rem 1.1rem",
                  borderRadius: "14px",
                  maxWidth: "85%",
                  marginLeft: "auto",
                }}
              >
                {msg.content}
              </div>
            ) : (
              <div
                style={{
                  background: "rgba(255,255,255,0.04)",
                  border: "1px solid rgba(255,255,255,0.1)",
                  borderRadius: "16px",
                  padding: "1.2rem",
                  maxWidth: "90%",
                }}
              >
                {msg.understanding && (
                  <div style={{ marginBottom: "0.9rem" }}>
                    <div style={{ fontSize: "0.75rem", opacity: 0.5, marginBottom: "0.25rem" }}>
                      UNDERSTANDING
                    </div>
                    <div>{msg.understanding}</div>
                  </div>
                )}
                {msg.suggestion && (
                  <div style={{ marginBottom: "0.9rem" }}>
                    <div style={{ fontSize: "0.75rem", opacity: 0.5, marginBottom: "0.25rem" }}>
                      SUGGESTION
                    </div>
                    <div>{msg.suggestion}</div>
                  </div>
                )}
                {msg.nextAction && (
                  <div
                    style={{
                      background: "rgba(167, 139, 250, 0.12)",
                      border: "1px solid rgba(167, 139, 250, 0.25)",
                      borderRadius: "10px",
                      padding: "0.8rem 1rem",
                    }}
                  >
                    <div style={{ fontSize: "0.75rem", opacity: 0.6, marginBottom: "0.25rem" }}>
                      NEXT ACTION
                    </div>
                    <div style={{ fontWeight: 500 }}>{msg.nextAction}</div>
                  </div>
                )}
                {(msg.mood || msg.goal) && (
                  <div style={{ marginTop: "0.8rem", fontSize: "0.75rem", opacity: 0.45 }}>
                    {msg.mood && <span>Mood: {msg.mood}</span>}
                    {msg.mood && msg.goal && <span> · </span>}
                    {msg.goal && <span>Goal: {msg.goal}</span>}
                  </div>
                )}
              </div>
            )}
          </div>
        ))}

        {loading && (
          <div style={{ opacity: 0.5, fontSize: "0.9rem" }}>NOVA-X is thinking...</div>
        )}

        <div ref={bottomRef} />
      </div>

      {/* Input */}
      <div
        style={{
          padding: "1rem 1.5rem 1.5rem",
          borderTop: "1px solid rgba(255,255,255,0.08)",
          maxWidth: "720px",
          width: "100%",
          margin: "0 auto",
        }}
      >
        <form onSubmit={handleSubmit} style={{ display: "flex", gap: "0.75rem" }}>
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Tell NOVA-X what's on your mind..."
            style={{
              flex: 1,
              padding: "0.9rem 1.1rem",
              borderRadius: "12px",
              border: "1px solid rgba(167, 139, 250, 0.3)",
              background: "rgba(255,255,255,0.05)",
              color: "white",
              fontSize: "1rem",
              outline: "none",
            }}
          />
          <button
            type="submit"
            disabled={loading || !input.trim()}
            style={{
              padding: "0.9rem 1.4rem",
              borderRadius: "12px",
              border: "none",
              background: loading
                ? "rgba(167, 139, 250, 0.3)"
                : "linear-gradient(90deg, #a78bfa, #60a5fa)",
              color: "white",
              fontWeight: 600,
              cursor: loading ? "not-allowed" : "pointer",
            }}
          >
            Send
          </button>
        </form>
      </div>
    </main>
  );
}
