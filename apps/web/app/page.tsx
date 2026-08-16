export default function Home() {
  return (
    <main style={{
      minHeight: "100vh",
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
      justifyContent: "center",
      background: "linear-gradient(135deg, #0f0f13 0%, #1a1a2e 100%)",
      color: "white",
      fontFamily: "system-ui, -apple-system, sans-serif",
      padding: "2rem",
      textAlign: "center"
    }}>
      <div style={{ maxWidth: "680px" }}>
        <h1 style={{ 
          fontSize: "3.5rem", 
          fontWeight: 700, 
          marginBottom: "1rem",
          background: "linear-gradient(90deg, #a78bfa, #60a5fa)",
          WebkitBackgroundClip: "text",
          WebkitTextFillColor: "transparent"
        }}>
          NOVA-X
        </h1>
        
        <p style={{ 
          fontSize: "1.4rem", 
          opacity: 0.9, 
          marginBottom: "2rem",
          lineHeight: 1.5
        }}>
          You don’t have to think about what to do next.<br />
          <strong>NOVA-X does.</strong>
        </p>

        <p style={{ 
          fontSize: "1.1rem", 
          opacity: 0.7, 
          marginBottom: "3rem",
          lineHeight: 1.6
        }}>
          Intelligent Life Operating System for students & young professionals.
          It understands your context, remembers what matters, and guides you to the next best action.
        </p>

        <div style={{
          display: "inline-block",
          padding: "0.9rem 2rem",
          background: "rgba(167, 139, 250, 0.15)",
          border: "1px solid rgba(167, 139, 250, 0.4)",
          borderRadius: "9999px",
          fontSize: "1rem",
          opacity: 0.9
        }}>
          Day 3 • Backend + Frontend live soon
        </div>
      </div>
    </main>
  );
}
