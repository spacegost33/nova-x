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
