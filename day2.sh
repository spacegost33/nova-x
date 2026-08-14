#!/bin/bash

echo "🚀 Starting NOVA-X Day 2 setup..."

# ======================
# packages/core/tsconfig.json
# ======================
cat > packages/core/tsconfig.json << 'EOF'
{
  "extends": "@repo/typescript-config/base.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF

# ======================
# packages/memory/tsconfig.json
# ======================
cat > packages/memory/tsconfig.json << 'EOF'
{
  "extends": "@repo/typescript-config/base.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF

# ======================
# packages/actions/tsconfig.json
# ======================
cat > packages/actions/tsconfig.json << 'EOF'
{
  "extends": "@repo/typescript-config/base.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF

# ======================
# packages/config/tsconfig.json
# ======================
cat > packages/config/tsconfig.json << 'EOF'
{
  "extends": "@repo/typescript-config/base.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF

# ======================
# apps/api/tsconfig.json
# ======================
cat > apps/api/tsconfig.json << 'EOF'
{
  "extends": "@repo/typescript-config/base.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
EOF

# ======================
# Update package.json of each new package to include typescript-config
# ======================
# core
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
    "@repo/typescript-config": "workspace:*",
    "typescript": "5.9.2"
  }
}
EOF

# memory
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
    "@repo/typescript-config": "workspace:*",
    "typescript": "5.9.2"
  }
}
EOF

# actions
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
    "@repo/typescript-config": "workspace:*",
    "typescript": "5.9.2"
  }
}
EOF

# config
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
    "@repo/typescript-config": "workspace:*",
    "typescript": "5.9.2"
  }
}
EOF

# api
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
    "@repo/typescript-config": "workspace:*",
    "typescript": "5.9.2"
  }
}
EOF

# ======================
# Update README status
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

**Day 2** – TypeScript configuration completed

- Added `tsconfig.json` to all new packages
- Linked packages to shared `@repo/typescript-config`
- Monorepo is now ready for real development

Previous:
- Day 1: Foundation (core, memory, actions, config, api)

---

## Packages

| Package              | Purpose                        |
|----------------------|--------------------------------|
| `@nova-x/core`       | The Brain (decision + planning)|
| `@nova-x/memory`     | Context & long-term memory     |
| `@nova-x/actions`    | Action execution system        |
| `@nova-x/config`     | Shared configuration           |
| `@nova-x/api`        | Platform API                   |

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
echo "✅ Day 2 completed successfully!"
echo ""
echo "Now run these commands:"
echo "1. pnpm install"
echo "2. git add ."
echo "3. git commit -m \"Day 2: Add TypeScript configs to all new packages\""
echo "4. git push origin main"
echo ""
echo "Then reply: Day 2 done"
