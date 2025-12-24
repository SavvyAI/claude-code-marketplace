---
description: "Need npx dev? → Sets up server management with auto port allocation → Copies bin files, configures package.json"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

# Setup npx dev Server Management

Sets up the `npx dev` infrastructure for managing local development servers with automatic port allocation.

## What Gets Installed

| Item | Location | Purpose |
|------|----------|---------|
| `dev.ts` | `bin/dev.ts` | Main CLI script |
| `notify.ts` | `bin/notify.ts` | Native OS notifications |
| `servers.json` | `.dev/servers.json` | Server configuration |
| `README.md` | `.dev/README.md` | Usage documentation |

## Status Indicators

- `[PASS]` - Check passed or step completed
- `[FAIL]` - Check failed (includes remediation)
- `[SKIP]` - Already exists or not needed
- `[WARN]` - Optional but recommended

---

## Phase 1: Prerequisites Check

### 1.1 Verify package.json Exists

```bash
test -f package.json && echo "exists" || echo "missing"
```

- If exists: `[PASS] package.json found`
- If missing: `[FAIL] No package.json - run npm init first`

### 1.2 Check for Existing Installation

Check if `bin/dev.ts` already exists:

```bash
test -f bin/dev.ts && echo "exists" || echo "missing"
```

If exists, use AskUserQuestion:
- Option 1: "Overwrite existing installation"
- Option 2: "Abort setup"

### 1.3 Check Node.js Version

```bash
node --version
```

Verify Node.js >= 18 (required for native fetch).

---

## Phase 2: Copy Bin Files

### 2.1 Create bin Directory

```bash
mkdir -p bin
```

### 2.2 Copy dev.ts

Read the bundled `dev.ts` from the plugin assets directory and write it to `bin/dev.ts`:

**Source:** `${PluginRoot}/commands/_bins/dev/dev.ts`
**Destination:** `${ProjectRoot}/bin/dev.ts`

Use the Read tool to get the content, then Write tool to create the file.

### 2.3 Copy notify.ts

**Source:** `${PluginRoot}/commands/_bins/dev/notify.ts`
**Destination:** `${ProjectRoot}/bin/notify.ts`

### 2.4 Set Executable Permission

```bash
chmod +x bin/dev.ts
```

Report: `[PASS] Copied bin/dev.ts and bin/notify.ts`

---

## Phase 3: Configure package.json

### 3.1 Read Current package.json

Use Read tool to get current `package.json` content.

### 3.2 Add bin Entry

Add or update the `bin` field:

```json
{
  "bin": {
    "dev": "./bin/dev.ts"
  }
}
```

If `bin` already exists, merge the `dev` entry.

### 3.3 Add Dependencies

Add to `dependencies`:
```json
{
  "node-notifier": "^10.0.1"
}
```

Add to `devDependencies`:
```json
{
  "tsx": "^4.20.6"
}
```

Use the Edit tool to make these updates to package.json.

Report: `[PASS] Updated package.json with bin entry and dependencies`

---

## Phase 4: Auto-Detect Servers

### 4.1 Parse package.json Scripts

Read the `scripts` field from package.json and detect server-like scripts:
- Scripts containing: `dev`, `start`, `serve`, `preview`
- Exclude: scripts containing `build`, `test`, `lint`, `format`
- Exclude: scripts that already reference `npx dev`

### 4.2 Generate servers.json

Create `.dev/servers.json` with detected servers:

```json
{
  "<script-name>": {
    "command": "npm run <script-name> -- -p {PORT}",
    "preferredPort": <calculated>,
    "healthCheck": "http://localhost:{PORT}"
  }
}
```

**Port Assignment:**
- First server: 3000
- Subsequent servers: increment by 10 (3010, 3020, etc.)

### 4.3 Create .dev Directory Structure

```bash
mkdir -p .dev/log
```

### 4.4 Write servers.json

Use Write tool to create `.dev/servers.json`.

### 4.5 User Review

Display the generated configuration and ask if adjustments are needed:
- Show detected servers
- Show assigned ports
- Option to customize before proceeding

Report: `[PASS] Created .dev/servers.json with N server(s)`

---

## Phase 5: Update .gitignore

### 5.1 Check Current .gitignore

Read `.gitignore` if it exists.

### 5.2 Add Entries

Append these entries if not already present:

```
# npx dev runtime files
.dev/pid.json
.dev/log/
```

Use Edit tool to append to `.gitignore`, or Write if it doesn't exist.

Report: `[PASS] Updated .gitignore`

---

## Phase 6: Add Documentation

### 6.1 Create .dev/README.md

**Source:** `${PluginRoot}/commands/_bins/dev/README.template.md`
**Destination:** `${ProjectRoot}/.dev/README.md`

### 6.2 Update Project README.md

If `README.md` exists, append a "Development Servers" section:

```markdown
## Development Servers

This project uses `npx dev` for local server management. See [.dev/README.md](.dev/README.md) for details.

```bash
npx dev              # Start first server
npx dev status       # Show running servers
npx dev stop         # Stop all servers
```
```

Ask user before modifying the main README.

Report: `[PASS] Added documentation`

---

## Phase 7: Install Dependencies

### 7.1 Prompt to Install

Ask user if they want to run `npm install` now:
- Option 1: "Yes, install dependencies now"
- Option 2: "No, I'll install later"

If yes:
```bash
npm install
```

---

## Phase 8: Summary

Display final summary:

```
/pro:dev.setup Complete
────────────────────────────────────────

Created:
  bin/dev.ts          Main CLI script
  bin/notify.ts       Notification helper
  .dev/servers.json   Server configuration
  .dev/README.md      Usage documentation

Updated:
  package.json        Added bin entry and dependencies
  .gitignore          Added runtime file exclusions
  README.md           Added development section

Detected Servers:
  web                 :3000
  api                 :3010

Quick Start:
  npm install         Install dependencies (if not done)
  npx dev             Start first server
  npx dev status      Check running servers

────────────────────────────────────────
```

---

## Error Handling

### No Server Scripts Detected

If no server-like scripts are found in package.json:

1. Create a minimal `servers.json` template:
```json
{
  "dev": {
    "command": "npm run dev -- -p {PORT}",
    "preferredPort": 3000,
    "healthCheck": "http://localhost:{PORT}"
  }
}
```

2. Inform user: "No server scripts detected. Created template configuration - please customize `.dev/servers.json`"

### Permission Errors

If file operations fail due to permissions:
1. Report specific error
2. Suggest: `chmod -R u+w .` or check file ownership
