---
description: "Onboarding a new developer? → Interactive setup guide with verification → Get productive in minutes"
allowed-tools: ["Bash", "Read", "Glob", "Grep", "Write", "AskUserQuestion", "TodoWrite"]
---

# Developer Onboarding Guide

An interactive, guided setup experience for new developers joining any project. This command walks through prerequisites verification, environment setup, IDE configuration, orientation, and smoke testing to ensure the developer is productive quickly.

## Overview

This onboarding process has 5 phases:

| Phase | Purpose | Interactive? |
|-------|---------|--------------|
| 1. Prerequisites | Verify required tools are installed | Yes - run checks, report pass/fail |
| 2. Environment | Setup project locally | Yes - confirm each command (skip if done) |
| 3. IDE/Tooling | Configure development tools | Yes - recommend, offer to verify |
| 4. First Steps | Orient to codebase | Read-only guidance |
| 5. Smoke Test | Verify app actually runs | Yes - run dev server, confirm working |

## Status Indicators

Use these indicators throughout the onboarding process:
- `[PASS]` - Requirement met or step completed successfully
- `[FAIL]` - Requirement not met (include remediation steps)
- `[SKIP]` - Already done or not applicable to this project
- `[WARN]` - Optional but recommended

---

## Phase 1: Prerequisites Check

Detect and verify required tools are installed.

### 1.1 Node.js Version

1. Check for version requirements in order of precedence:
   - `.nvmrc` file
   - `.node-version` file
   - `package.json` engines.node field

2. Run: `node --version`

3. Compare installed version against required:
   - If matches or exceeds: `[PASS] Node.js vX.Y.Z (required: vA.B.C)`
   - If mismatch: `[FAIL] Node.js vX.Y.Z installed, but vA.B.C required`
     - Suggest: `nvm install` or `nvm use` if .nvmrc exists
   - If no requirement found: `[PASS] Node.js vX.Y.Z (no specific version required)`

### 1.2 Package Manager

1. Detect package manager from lockfile:
   - `package-lock.json` → npm
   - `yarn.lock` → yarn
   - `pnpm-lock.yaml` → pnpm
   - `bun.lockb` → bun

2. Run version check for detected package manager:
   ```bash
   npm --version    # or yarn/pnpm/bun
   ```

3. Report: `[PASS] npm vX.Y.Z detected` or `[FAIL]` with install instructions

### 1.3 Git

1. Run: `git --version`
2. Verify repo is properly cloned: `git status` should not error
3. Report status

### 1.4 Docker (if applicable)

1. Check if `docker-compose.yml` or `compose.yml` exists
2. If yes:
   - Run: `docker --version`
   - Run: `docker compose version`
   - Report: `[PASS]` or `[FAIL]` with install link

3. If no docker-compose file: `[SKIP] Docker not required for this project`

### 1.5 Other Tools

1. Scan `package.json` scripts for CLI tools that might need global installation
2. Look for common patterns:
   - `turbo` → Turborepo
   - `nx` → Nx
   - `prisma` → Prisma CLI
   - `playwright` → Playwright

3. For each detected tool, verify it's available or note it will be installed via npm

---

## Phase 2: Environment Setup

Set up the local development environment. **Check if steps are already done before prompting.**

### 2.1 Dependencies

**Partial Setup Detection:**
- Check if `node_modules/` directory exists
- If exists: `[SKIP] Dependencies already installed`
- If missing:

Use AskUserQuestion: "Ready to install dependencies?"
- Option 1: "Yes, run {npm/yarn/pnpm/bun} install"
- Option 2: "Skip for now"

If yes, run the install command and report success/failure.

### 2.2 Environment Variables

**Flow:**

1. **Check if `.env` already exists:**
   - If exists: `[SKIP] Environment file already exists`
   - Continue to step 2 only if `.env` is missing

2. **Detect env template files** (in order of preference):
   - `.env.example`
   - `.env.template`
   - `.env.sample`
   - `.env.local.example`

3. **If no template found:**
   - `[SKIP] No environment template found`
   - Note: Project may not require environment variables

4. **If template found, prompt user:**

Use AskUserQuestion: "Create .env from template?"
- Option 1: "Yes, copy {template} to .env"
- Option 2: "Skip, I'll configure manually"

5. **After creating .env:**
   - Parse the template to identify variables needing configuration
   - Look for placeholder patterns: `your-api-key-here`, `changeme`, `xxx`, `TODO`, empty values
   - List these variables for the user:
     ```
     The following variables need configuration:
     - DATABASE_URL (empty)
     - API_KEY (placeholder: your-api-key-here)
     ```
   - Remind user to edit `.env` before running the app

### 2.3 Database Setup (if applicable)

1. Detect database requirements:
   - `docker-compose.yml` with database services (postgres, mysql, mongodb, redis)
   - `prisma/` directory
   - `drizzle/` directory
   - `migrations/` or `db/migrations/` directory

2. **Docker containers:**
   - Check if containers are already running: `docker ps`
   - If running: `[SKIP] Database containers already running`
   - If not running and docker-compose exists:

Use AskUserQuestion: "Start database containers?"
- Option 1: "Yes, run docker compose up -d"
- Option 2: "Skip, I have my own database"

3. **Migrations:**
   - Detect migration command in package.json scripts (db:migrate, migrate, prisma migrate, etc.)
   - If found, offer to run it after containers are up

### 2.4 Build/Compile (if applicable)

1. Check if build is needed:
   - Look for `build` script in package.json
   - Check if `dist/` or `build/` directory exists

2. If build artifacts missing and build script exists:

Use AskUserQuestion: "Run initial build?"
- Option 1: "Yes, run npm run build"
- Option 2: "Skip for now"

---

## Phase 3: IDE/Tooling Setup

Configure development tools for optimal experience.

### 3.1 Recommended VS Code Extensions

1. Check for `.vscode/extensions.json`
2. If found, parse and list recommended extensions:
   ```
   Recommended Extensions:
   - dbaeumer.vscode-eslint
   - esbenp.prettier-vscode
   - bradlc.vscode-tailwindcss
   ...
   ```

3. For VS Code users, provide install command:
   ```bash
   code --install-extension dbaeumer.vscode-eslint
   ```

4. If `.vscode/extensions.json` not found: `[SKIP] No VS Code extensions configured`

### 3.2 Linter/Formatter Configuration

1. Detect configured tools:
   - `.eslintrc*` or `eslint.config.*` → ESLint
   - `.prettierrc*` or `prettier.config.*` → Prettier
   - `biome.json` or `biome.jsonc` → Biome
   - `.editorconfig` → EditorConfig

2. Report what's configured:
   ```
   [PASS] ESLint configured (eslint.config.js)
   [PASS] Prettier configured (.prettierrc)
   [WARN] No EditorConfig found (recommended for consistent formatting)
   ```

3. Suggest enabling format-on-save in editor

### 3.3 Git Hooks

1. Detect git hook tools:
   - `.husky/` directory
   - `package.json` scripts containing "prepare" with husky
   - `lefthook.yml`
   - `.pre-commit-config.yaml`

2. Check if hooks are installed:
   - For Husky: Check `.husky/_/husky.sh` exists
   - If not installed:

Use AskUserQuestion: "Install git hooks?"
- Option 1: "Yes, run npm run prepare"
- Option 2: "Skip for now"

3. If already installed: `[SKIP] Git hooks already installed`

### 3.4 TypeScript (if applicable)

1. Check for `tsconfig.json`
2. If found:
   - Look for typecheck script in package.json
   - Offer to run type check to verify setup:

Use AskUserQuestion: "Verify TypeScript setup?"
- Option 1: "Yes, run type check"
- Option 2: "Skip for now"

---

## Phase 4: First Steps Guide

Provide orientation to the codebase (read-only, no prompts).

### 4.1 Key Files to Read First

List these files **if they exist**, with brief descriptions:

| File | Purpose |
|------|---------|
| `README.md` | Project overview and quick start |
| `CONTRIBUTING.md` | Contribution guidelines and workflow |
| `docs/` or `documentation/` | Additional documentation |
| `ARCHITECTURE.md` | System architecture overview |
| `.env.example` | Required environment variables |
| `CLAUDE.md` or `.claude/CLAUDE.md` | AI coding rules (if using Claude Code) |

**Note:** Only list files that actually exist in the project. Skip any that don't apply.

### 4.2 Project Structure Overview

Generate a brief overview of top-level directories:
```
Project Structure:
├── src/           - Source code
├── tests/         - Test files
├── docs/          - Documentation
├── scripts/       - Utility scripts
└── ...
```

Focus on entry points and main directories.

### 4.3 Available Scripts

Parse `package.json` scripts and highlight the most important:

| Script | Command | Purpose |
|--------|---------|---------|
| dev | `npm run dev` | Start development server |
| build | `npm run build` | Build for production |
| test | `npm run test` | Run test suite |
| lint | `npm run lint` | Run linter |

Include any other notable scripts.

### 4.4 Getting Help

- Point to README for detailed documentation
- Mention issue tracker if detectable (GitHub, GitLab)
- Note CONTRIBUTING.md for contribution workflow

---

## Phase 5: Smoke Test

Verify the application actually runs after setup.

### 5.1 Detect Dev Command

1. Check package.json scripts for development commands:
   - `dev` (most common)
   - `start`
   - `serve`
   - `develop`

2. Identify the primary development command

### 5.2 Run Dev Server

Use AskUserQuestion: "Ready to verify the app runs?"
- Option 1: "Yes, start dev server"
- Option 2: "Skip smoke test"

If yes:

1. Run the dev command in background, capture output
2. Watch for ready indicators in output:
   - "ready"
   - "listening on"
   - "started"
   - "compiled"
   - "server running"
   - URLs like "http://localhost:"

3. Wait reasonable time (10-15 seconds) for startup

### 5.3 Verify Response (for web apps)

1. Try to detect port from:
   - Dev server output
   - Common ports: 3000, 5173, 8080, 4000

2. If port detected, optionally verify the server responds

3. Report status:
   - `[PASS] App running at http://localhost:3000`
   - `[FAIL] Dev server failed to start` (include error output)

### 5.4 Cleanup

1. Stop the dev server after verification
2. Report final smoke test status

### 5.5 Non-Web Projects

For projects without a dev server:
- **CLI tools:** Run with `--help` or `--version`
- **Libraries:** Run test suite as smoke test
- **Report:** Appropriate success criteria for project type

---

## Summary Generation

After completing all phases, generate a summary report.

### Summary Format

```markdown
# Onboarding Summary: {project-name}

Generated: {timestamp}

## Prerequisites
- [PASS] Node.js v20.10.0
- [PASS] npm v10.2.0
- [PASS] Git v2.42.0
- [SKIP] Docker not required

## Environment
- [PASS] Dependencies installed
- [PASS] Environment file created
- [SKIP] No database required

## IDE/Tooling
- [PASS] ESLint configured
- [PASS] Git hooks installed
- [WARN] No VS Code extensions.json

## Smoke Test
- [PASS] Dev server starts successfully

## Quick Reference
| Task | Command |
|------|---------|
| Start dev | npm run dev |
| Run tests | npm run test |
| Build | npm run build |

## Next Steps
1. Read README.md for project overview
2. Check CONTRIBUTING.md for workflow
3. Pick a starter task from issues

---
Generated by Claude Code /pro:onboarding
```

---

## Output Requirements

### 1. Save Summary to Temp Directory

Save the summary report using this naming convention:
- **Filename pattern:** `onboarding-{project}-{timestamp}.md`
- **Location:** Cross-platform temp directory
- **Project name:** Current directory name (lowercase, sanitized)
- **Timestamp:** Format as `YYYYMMDD-HHMMSS`

**Platform-specific temp directory:**
- **macOS/Linux/WSL:** `${TMPDIR:-/tmp}/`
- **Windows (PowerShell):** `$env:TEMP\`

Example: `${TMPDIR:-/tmp}/onboarding-myproject-20241222-160000.md`

### 2. Copy to Clipboard

After saving, copy the markdown content to clipboard:

```bash
if command -v pbcopy &> /dev/null; then
    cat "$OUTPUT_FILE" | pbcopy
elif command -v xclip &> /dev/null; then
    cat "$OUTPUT_FILE" | xclip -selection clipboard
elif command -v xsel &> /dev/null; then
    cat "$OUTPUT_FILE" | xsel --clipboard
elif command -v clip.exe &> /dev/null; then
    cat "$OUTPUT_FILE" | clip.exe
fi
```

### 3. Report Output Location

After completing onboarding, display:
- The full path to the saved summary file
- Confirmation that the summary was copied to clipboard

---

## Interaction Guidelines

1. **Be encouraging** - Onboarding should feel welcoming, not intimidating
2. **Explain what's happening** - New developers benefit from understanding each step
3. **Handle failures gracefully** - Provide clear remediation steps for any failures
4. **Respect user choices** - If they skip a step, don't repeatedly ask
5. **Track progress** - Use TodoWrite to track phases for visibility
