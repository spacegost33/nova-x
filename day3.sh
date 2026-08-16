
#!/bin/bash

echo "🚀 Starting NOVA-X Day 3 – Deployable Version"

# ======================
# 1. Setup clean Hono API
# ======================
echo "→ Setting up apps/api with Hono..."

mkdir -p apps/api/src/routes

# package.json for API
cat > apps/api/package.json << 'EOF'
{
  "name": "@nova-x/api",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "check-types": "tsc --noEmit"
  },
  "dependencies": {
    "hono": "^4.6.0",
    "@hono/node-server": "^1.13.0"
  },
  "devDependencies": {
    "@repo/typescript-config": "workspace:*",
    "@types/node": "^22.0.0",
    "tsx": "^4.19.0",
    "typescript": "5.9.2"
  }
}
EOF

# tsconfig for API
cat > apps/api/tsconfig.json << 'EOF'
{
  "extends": "@repo/typescript-config/base.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "target": "ES2022"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Main API entry
cat > apps/api/src/index.ts << 'EOF'
import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { cors } from "hono/cors";

const app = new Hono();

// Enable CORS so Web + future Android can call the API
app.use("/*", cors());

// Health check
app.get("/", (c) => {
  return c.json({
    name: "NOVA-X API",
    version: "0.0.1",
    status: "online",
    message: "NOVA-X Backend is alive"
  });
});

app.get("/health", (c) => {
  return c.json({ status: "ok", timestamp: new Date().toISOString() });
});

// Placeholder for future Core
app.post("/v1/think", async (c) => {
  const body = await c.req.json().catch(() => ({}));
  return c.json({
    message: "NOVA-X Core is not fully implemented yet",
    received: body,
    next: "We will implement real thinking in coming days"
  });
});

const port = Number(process.env.PORT) || 3001;

console.log(`🚀 NOVA-X API running on http://localhost:${port}`);

serve({
  fetch: app.fetch,
  port
});
EOF

# ======================
# 2. Update Web Landing Page
# ======================
echo "→ Creating clean NOVA-X landing page..."

# Simple clean page for apps/web
cat > apps/web/app/page.tsx << 'EOF'
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
EOF

# ======================
# 3. Update Root README (clean for new developers)
# ======================
cat > README.md << 'EOF'
# NOVA-X

**Intelligent Life Operating System**

> You don’t have to think about what to do next. NOVA-X does.

NOVA-X is an intelligent operating system that understands your context, remembers what matters, and tells you exactly what to do next.

---

## Project Structure

EOF

