
#!/bin/bash

echo "🚀 Starting NOVA-X Day 5 – First Real Core Logic"

# ======================
# 1. Build basic NovaCore
# ======================
cat > packages/core/src/index.ts << 'EOF'
// NOVA-X Core – The Brain
// Decision making + planning engine (Day 5 – first real version)

export const CORE_VERSION = "0.0.2";

export interface ThinkInput {
  message: string;
}

export interface ThinkOutput {
  understanding: string;
  suggestion: string;
  nextAction: string;
  confidence: number;
}

export class NovaCore {
  think(input: ThinkInput): ThinkOutput {
    const message = input.message.toLowerCase().trim();

    // Very basic understanding for now
    if (message.includes("tired") || message.includes("exhausted") || message.includes("sleep")) {
      return {
        understanding: "You seem tired or low on energy.",
        suggestion: "Consider taking a short break or resting soon.",
        nextAction: "Rest or do a light activity for 15-20 minutes.",
        confidence: 0.85,
      };
    }

    if (message.includes("study") || message.includes("exam") || message.includes("learn")) {
      return {
        understanding: "You are focused on studying or learning.",
        suggestion: "Break your study into small focused sessions.",
        nextAction: "Start a 25-minute focused study session (Pomodoro).",
        confidence: 0.8,
      };
    }

    if (message.includes("stress") || message.includes("anxious") || message.includes("worried")) {
      return {
        understanding: "You appear to be feeling stressed or anxious.",
        suggestion: "Try a short breathing exercise or write down what's on your mind.",
        nextAction: "Take 5 deep breaths or journal for 5 minutes.",
        confidence: 0.82,
      };
    }

    if (message.includes("bored") || message.includes("nothing to do")) {
      return {
        understanding: "You seem bored or lacking direction right now.",
        suggestion: "Pick one small meaningful task to regain momentum.",
        nextAction: "Choose one small task and start it for just 10 minutes.",
        confidence: 0.75,
      };
    }

    // Default response
    return {
      understanding: "I received your message and I'm learning about your current state.",
      suggestion: "Tell me more about how you're feeling or what you're working on.",
      nextAction: "Share more context so I can give better guidance.",
      confidence: 0.5,
    };
  }
}

// Helper function
export function createCore() {
  return new NovaCore();
}
EOF

# ======================
# 2. Update API to use the Core
# ======================
cat > apps/api/src/index.ts << 'EOF'
import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { cors } from "hono/cors";
import { createCore } from "@nova-x/core";

const app = new Hono();
const core = createCore();

// Enable CORS
app.use("/*", cors());

// Health check
app.get("/", (c) => {
  return c.json({
    name: "NOVA-X API",
    version: "0.0.2",
    status: "online",
    message: "NOVA-X Backend is alive – Core connected",
  });
});

app.get("/health", (c) => {
  return c.json({ status: "ok", timestamp: new Date().toISOString() });
});

// Real thinking endpoint
app.post("/v1/think", async (c) => {
  try {
    const body = await c.req.json();
    const message = body.message || body.text || "";

    if (!message) {
      return c.json({ error: "Message is required" }, 400);
    }

    const result = core.think({ message });

    return c.json({
      success: true,
      input: message,
      ...result,
      coreVersion: "0.0.2",
    });
  } catch (error) {
    return c.json({ error: "Failed to process request" }, 500);
  }
});

const port = Number(process.env.PORT) || 3001;

console.log(`🚀 NOVA-X API running on http://localhost:${port}`);

serve({
  fetch: app.fetch,
  port,
});
EOF

# ======================
# 3. Make sure API depends on core
# ======================
cat > apps/api/package.json << 'EOF'
{
  "name": "@nova-x/api",
  "version": "0.0.2",
  "private": true,
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "check-types": "tsc --noEmit"
  },
  "dependencies": {
    "@nova-x/core": "workspace:*",
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

# ======================
# 4. Update README
# ======================
cat > README.md << 'EOF'
# NOVA-X

**Intelligent Life Operating System**

> You don’t have to think about what to do next. NOVA-X does.

---

## Live URLs

- **Web**: https://nova-x-web.vercel.app/
- **API**: https://nova-x-api.onrender.com/

---

## Current Status

| Day | What was done                          |
|-----|----------------------------------------|
| 1   | Foundation (packages created)          |
| 2   | TypeScript configuration               |
| 3   | First deployment (Vercel + Render)     |
| 4   | Interactive frontend connected to API  |
| 5   | First real Core logic (basic thinking) |

---

## How it works now

User types a message → Web sends it to API → API uses `@nova-x/core` → Returns understanding + suggestion + next action

---

## Local Development

```bash
pnpm install
pnpm dev
EOF
