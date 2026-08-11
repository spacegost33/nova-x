#!/bin/bash

echo "🚀 Starting NOVA-X Day 1 setup..."

# Create directories
mkdir -p packages/core/src
mkdir -p packages/memory/src
mkdir -p packages/actions/src
mkdir -p packages/config/src
mkdir -p apps/api/src

# ======================
# packages/core
# ======================
cat > packages/core/package.json << 'EOF'
{
  "name": "@nova-x/core",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": {
    "lint": "eslint . --max-warnings 0",
    "check-types": "tsc --noEmit"
  },
  "devDependencies": {
    "typescript": "5.9.2"
  }
}
EOF

cat > packages/core/src/index.ts << 'EOF'
// NOVA-X Core – The Brain
// Decision making + planning engine

export const CORE_VERSION = "0.0.1";

export function helloCore() {
  return "NOVA-X Core is alive";
}
EOF

# ======================
# packages/memory
# ======================
cat > packages/memory/package.json << 'EOF'
{
  "name": "@nova-x/memory",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": {
    "lint": "eslint . --max-warnings 0",
    "check-types": "tsc --noEmit"
  },
  "devDependencies": {
    "typescript": "5.9.2"
  }
}
EOF

cat > packages/memory/src/index.ts << 'EOF'
// NOVA-X Memory – Context & Long-term Memory

export const MEMORY_VERSION = "0.0.1";

export function helloMemory() {
  return "NOVA-X Memory is alive";
}
EOF

# ======================
# packages/actions
# ======================
cat > packages/actions/package.json << 'EOF'
{
  "name": "@nova-x/actions",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": {
    "lint": "eslint . --max-warnings 0",
    "check-types": "tsc --noEmit"
  },
  "devDependencies": {
    "typescript": "5.9.2"
  }
}
EOF

cat > packages/actions/src/index.ts << 'EOF'
// NOVA-X Actions – Action Execution System

export const ACTIONS_VERSION = "0.0.1";

export function helloActions() {
  return "NOVA-X Actions is alive";
}
EOF

# ======================
# packages/config
# ======================
cat > packages/config/package.json << 'EOF'
{
  "name": "@nova-x/config",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": {
    "lint": "eslint . --max-warnings 0",
    "check-types": "tsc --noEmit"
  },
  "devDependencies": {
    "typescript": "5.9.2"
  }
}
EOF

cat > packages/config/src/index.ts << 'EOF'
// NOVA-X Config – Shared configuration

export const CONFIG_VERSION = "0.0.1";

export const APP_NAME = "NOVA-X";
export const APP_DESCRIPTION = "Intelligent Life Operating System";
EOF

# ======================
# apps/api
# ======================
cat > apps/api/package.json << 'EOF'
{
  "name": "@nova-x/api",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "echo 'API not implemented yet'",
    "build": "echo 'API not implemented yet'",
    "lint": "eslint . --max-warnings 0",
    "check-types": "tsc --noEmit"
  },
  "devDependencies": {
    "typescript": "5.9.2"
  }
}
EOF

cat > apps/api/src/index.ts << 'EOF'
// NOVA-X Platform API
// Will handle all communication between Client ↔ Core

export const API_VERSION = "0.0.1";

console.log("NOVA-X API placeholder loaded");
EOF

# ======================
# Root README
# ======================
cat > README.md << 'EOF'
# NOVA-X

**Intelligent Life Operating System**

> You don’t have to think about what to do next. NOVA-X does.

NOVA-X understands your context, remembers what matters, and tells you exactly what to do next — so students and young professionals never have to figure it out alone.

---

## Vision

An intelligent operating system for your digital life that:
- Understands your input, habits, and goals
- Maintains continuous context & memory
- Makes decisions and plans automatically
- Executes actions (reminders, suggestions, automations)

---

## Current Status

**Day 1** – Foundation setup completed  
Monorepo structure created with:

- `packages/core` → The Brain
- `packages/memory` → Context & Memory
- `packages/actions` → Action system
- `packages/config` → Shared config
- `apps/api` → Platform API (placeholder)
- `apps/web` → Web client (from starter)

---

## Getting Started

\`\`\`bash
pnpm install
pnpm dev
\`\`\`

---

## License

Private – All rights reserved
EOF

echo ""
echo "✅ Day 1 foundation created successfully!"
echo ""
echo "Next steps:"
echo "1. chmod +x dd.sh   (only if needed)"
echo "2. Run: pnpm install"
echo "3. Check structure: ls packages/ && ls apps/"
echo "4. Reply with: Day 1 done"
