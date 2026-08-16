import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { cors } from "hono/cors";
import { createCore } from "@nova-x/core";

const app = new Hono();
const core = createCore();

app.use("/*", cors());

app.get("/", (c) => {
  return c.json({
    name: "NOVA-X API",
    version: "0.1.0",
    status: "online",
    message: "NOVA-X Backend – Week 2 (Memory + Context)",
  });
});

app.get("/health", (c) => {
  return c.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.post("/v1/think", async (c) => {
  try {
    const body = await c.req.json();
    const message = body.message || body.text || "";
    const history = body.history || [];

    if (!message) {
      return c.json({ error: "Message is required" }, 400);
    }

    const result = core.think({ message, history });

    return c.json({
      success: true,
      input: message,
      ...result,
      coreVersion: "0.1.0",
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
