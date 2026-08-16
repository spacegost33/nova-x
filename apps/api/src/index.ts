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
