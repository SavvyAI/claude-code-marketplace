# Feature: Add Onboarding Command

## Branch
`feat/add-onboarding-command`

## Summary
Create `/pro:onboarding` - an interactive, guided setup experience for new developers joining any project.

---

## Requirements

### User Answers (Confirmed)

| Question | Answer |
|----------|--------|
| Target Scope | Generic (any codebase) |
| Interactivity Level | Fully Interactive |
| Run Verification Commands | Yes - Run & Report |
| Output Format | Interactive + File |
| Phases to Include | All 5 phases |
| Discovery Method | Auto-detect from project files |
| Automation Level | With per-command confirmation |

### In Scope

- [x] `/pro:onboarding` command with interactive flow
- [ ] **Phase 1: Prerequisites Check** - Verify required tools are installed
- [ ] **Phase 2: Environment Setup** - Clone, install, configure (with partial setup detection)
- [ ] **Phase 3: IDE/Tooling Setup** - Extensions, linters, git hooks
- [ ] **Phase 4: First Steps Guide** - Key files, architecture, starter tasks
- [ ] **Phase 5: Smoke Test** - Verify the app actually runs after setup
- [ ] Auto-detection of project requirements from config files
- [ ] Partial setup detection - skip steps already completed
- [ ] Per-command confirmation before execution
- [ ] Pass/fail status reporting for each verification step
- [ ] Summary file saved to temp directory
- [ ] Clipboard copy of summary

### Out of Scope (Future Enhancements)

- [ ] Team contacts / who to ask for what (requires external config)
- [ ] "Fast mode" flag for experienced users (batch confirmations)
- [ ] Project-specific onboarding templates
- [ ] Integration with issue trackers for "good first issue" discovery
- [ ] `/pro:security` - Security audit command (`.env` gitignored, `npm audit`, secrets scan) - separate command

### Under Review (May Implement)

- [ ] **CI Parity** - Show how to run tests the same way CI does
  - Detect CI config (`.github/workflows/`, `.gitlab-ci.yml`, etc.)
  - Parse and display the test/lint/build commands CI runs
  - Offer "Run CI checks locally?" prompt
  - *Decision: Review after initial implementation to assess value*

---

## Design Decisions

### 1. Command Description
```
"Onboarding a new developer? → Interactive setup guide with verification → Get productive in minutes"
```

### 2. Five-Phase Structure

| Phase | Purpose | Interactive? |
|-------|---------|--------------|
| 1. Prerequisites | Verify tools installed | Yes - run checks, report pass/fail |
| 2. Environment | Setup project locally | Yes - confirm each command (skip if done) |
| 3. IDE/Tooling | Configure development tools | Yes - recommend, offer to verify |
| 4. First Steps | Orient to codebase | Read-only guidance |
| 5. Smoke Test | Verify app actually runs | Yes - run dev server, confirm it works |

### 3. Auto-Detection Sources

| Requirement | Detection Source |
|-------------|------------------|
| Node.js version | `.nvmrc`, `.node-version`, `package.json` engines |
| Package manager | `package-lock.json` (npm), `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb` |
| Environment vars | `.env.example`, `.env.template`, `.env.sample` |
| Database | `docker-compose.yml`, `prisma/`, `drizzle/`, migrations folders |
| Git hooks | `.husky/`, `.git/hooks/`, `package.json` prepare scripts |
| IDE extensions | `.vscode/extensions.json`, `.idea/` configs |
| Linter/Formatter | `.eslintrc*`, `.prettierrc*`, `biome.json` |
| TypeScript | `tsconfig.json` |
| Test framework | `jest.config.*`, `vitest.config.*`, `playwright.config.*` |

### 4. Verification Command Examples

```bash
# Prerequisites
node --version          # Compare against required
npm --version           # Or yarn/pnpm/bun
git --version
docker --version        # If docker-compose.yml exists

# Environment
npm install             # With confirmation
cp .env.example .env    # With confirmation, if missing
docker compose up -d    # With confirmation, if applicable

# IDE/Tooling
code --list-extensions  # Compare against recommended
```

### 5. Output File Format

**Filename:** `onboarding-{project}-{timestamp}.md`
- Example: `onboarding-ccplugins-20241222-160000.md`

**Location:** `${TMPDIR:-/tmp}/`

### 6. Pass/Fail Indicators

Use clear visual indicators in output:
- `[PASS]` - Requirement met
- `[FAIL]` - Requirement not met (with remediation steps)
- `[SKIP]` - Not applicable to this project
- `[WARN]` - Optional but recommended

### 7. AskUserQuestion Integration

Use `AskUserQuestion` tool for:
1. Confirming each setup command before execution
2. Offering choices when multiple options exist (e.g., package manager preference)
3. Asking if user wants to skip phases they've already completed

### 8. Partial Setup Detection

Before prompting to run a command, check if it's already done:

| Step | Detection | If Already Done |
|------|-----------|-----------------|
| `npm install` | `node_modules/` exists | Skip with `[SKIP]` note |
| Create `.env` | `.env` file exists | Skip, but warn if different from template |
| `docker compose up` | Container running (`docker ps`) | Skip with `[SKIP]` note |
| Git hooks | `.husky/_/husky.sh` exists | Skip with `[SKIP]` note |
| Build | `dist/` or `build/` exists | Offer to rebuild or skip |

**Note:** For simplicity, existence checks are binary (exists/doesn't exist). Staleness detection (comparing mtimes) is deferred to future enhancement.

This prevents wasting time re-running completed steps for developers who partially set up.

### 9. Smoke Test Strategy

After environment setup, verify the app actually works:

1. **Detect dev command** - Look for `npm run dev`, `npm start`, or similar in package.json
2. **Run in background** - Start the dev server
3. **Wait for ready signal** - Watch output for "ready", "listening", "started" patterns
4. **Verify response** - For web apps, check localhost responds (if port detectable)
5. **Report status** - `[PASS]` if running, `[FAIL]` with error output if not
6. **Cleanup** - Stop the dev server after verification

---

## Implementation Steps

### Step 1: Create Command File
- Create `pro/commands/onboarding.md`
- Define frontmatter with description and allowed-tools
- Include all 5 phases with detailed instructions

### Step 2: Create Template (Optional)
- Consider if a shared template is needed
- May not need one since output is more dynamic than handoff

### Step 3: Define Phase Instructions

#### Phase 1: Prerequisites Check
```markdown
## Phase 1: Prerequisites Check

Detect and verify required tools:

1. **Node.js** - Check `.nvmrc`, `.node-version`, `package.json` engines
   - Run: `node --version`
   - Compare against required version
   - Report: [PASS] or [FAIL] with install instructions

2. **Package Manager** - Detect from lockfile
   - Run: `{npm|yarn|pnpm|bun} --version`
   - Report status

3. **Git** - Always required
   - Run: `git --version`
   - Verify repo is cloned properly

4. **Docker** (if applicable) - Check for docker-compose.yml
   - Run: `docker --version` and `docker compose version`
   - Report status

5. **Other tools** - Scan scripts in package.json for required CLIs
```

#### Phase 2: Environment Setup
```markdown
## Phase 2: Environment Setup

1. **Dependencies**
   - Ask: "Ready to install dependencies? (npm install)"
   - Run with confirmation
   - Report success/failure

2. **Environment Variables**
   - Detect .env.example or similar
   - Check if .env exists
   - Offer to copy template: "Create .env from .env.example?"
   - List required vars that need manual configuration

3. **Database** (if applicable)
   - Detect database tooling (Prisma, Drizzle, raw migrations)
   - Offer to run: docker compose up -d (if docker-compose.yml)
   - Offer to run: npm run db:migrate or equivalent

4. **Build/Compile** (if applicable)
   - Offer to run: npm run build
   - Report success/failure
```

#### Phase 3: IDE/Tooling Setup
```markdown
## Phase 3: IDE/Tooling Setup

1. **Recommended Extensions**
   - Read .vscode/extensions.json
   - List recommended extensions
   - For VS Code: Show install commands

2. **Linter/Formatter Configuration**
   - Detect ESLint, Prettier, Biome
   - Verify configs exist
   - Suggest editor integration

3. **Git Hooks**
   - Detect Husky or similar
   - Verify hooks are installed
   - Offer to run: npm run prepare (if husky)

4. **TypeScript** (if applicable)
   - Verify tsconfig.json exists
   - Check for type errors: npm run typecheck (if script exists)
```

#### Phase 4: First Steps Guide
```markdown
## Phase 4: First Steps Guide

1. **Key Files to Read First**
   - README.md
   - CONTRIBUTING.md (if exists)
   - Architecture docs (if exist)
   - CLAUDE.md / .claude/CLAUDE.md (if exists)

2. **Project Structure Overview**
   - List top-level directories with purpose
   - Highlight entry points

3. **Available Scripts**
   - Parse package.json scripts
   - Highlight: dev, build, test, lint

4. **Good First Tasks**
   - Look for CONTRIBUTING.md guidance
   - Suggest starting with small fixes or tests
```

#### Phase 5: Smoke Test
```markdown
## Phase 5: Smoke Test

Verify the application actually runs after setup:

1. **Detect Dev Command**
   - Check package.json scripts for: dev, start, serve
   - Identify the primary development command

2. **Run Dev Server** (with confirmation)
   - Ask: "Ready to verify the app runs? (npm run dev)"
   - Run in background, capture output
   - Watch for ready indicators: "ready", "listening on", "started", "compiled"

3. **Verify Response** (for web apps)
   - Detect port from output or config
   - Check if localhost:{port} responds
   - Report: [PASS] "App running at http://localhost:3000"
          or [FAIL] with error output

4. **Cleanup**
   - Stop the dev server after verification
   - Report final status

5. **Handle Non-Web Projects**
   - CLI tools: Run with --help or --version
   - Libraries: Run test suite instead
   - Report appropriate success criteria
```

### Step 4: Summary Generation

At completion, generate summary showing:
- All verification results (pass/fail/skip)
- Commands that were run
- Manual steps still needed
- Quick reference for common commands

### Step 5: File Output & Clipboard

Same pattern as handoff/wtf:
- Save to temp directory
- Copy to clipboard
- Display file path

---

## Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `pro/commands/onboarding.md` | Create | Main command definition |
| `pro/readme.md` | Update | Add onboarding to command table |

---

## Testing Checklist

- [ ] Run `/pro:onboarding` on ccplugins project
- [ ] Verify all 5 phases execute correctly
- [ ] Verify auto-detection works for:
  - [ ] Node.js version
  - [ ] Package manager (npm)
  - [ ] Environment files
  - [ ] VS Code extensions
- [ ] Verify partial setup detection:
  - [ ] Skips `npm install` when `node_modules/` exists
  - [ ] Skips `.env` copy when `.env` exists
  - [ ] Reports `[SKIP]` appropriately
- [ ] Verify smoke test:
  - [ ] Detects dev command from package.json
  - [ ] Runs dev server with confirmation
  - [ ] Reports pass/fail status
  - [ ] Cleans up (stops server) after test
- [ ] Verify AskUserQuestion prompts work correctly
- [ ] Verify pass/fail indicators display correctly
- [ ] Verify summary file is saved to temp directory
- [ ] Verify clipboard copy works (macOS)
- [ ] Test on a project missing some configs (handles gracefully)

---

## Known Limitations

1. **Windows support** - Uses Unix-style paths and commands; Windows users may need adjustments
2. **No team contacts** - Would require external configuration not yet designed
3. **Single package manager** - Doesn't handle monorepos with multiple package managers
4. **IDE detection** - Focused on VS Code; other IDEs have different extension systems

---

## Comparison: Onboarding vs Handoff/WTF

| Feature | Onboarding | Handoff/WTF |
|---------|------------|-------------|
| Purpose | Get new dev productive | Document codebase state |
| Tone | Instructional, guided | Documentary, analytical |
| Interactive | Yes, per-step confirmation | No (report generation) |
| Runs commands | Yes, with user consent | No (read-only analysis) |
| Output | Pass/fail checklist + guidance | Comprehensive report |
| Smoke test | Yes, verifies app runs | No |
| When to use | First day on project | Handover or situational awareness |

---

## Future Enhancements

1. **Fast mode** - `--fast` flag to batch confirmations for experienced users
2. **Team contacts** - Support for `.onboarding.json` or similar config
3. **Issue tracker integration** - Auto-fetch "good first issue" from GitHub/GitLab
4. **Project templates** - Allow projects to define custom onboarding steps
5. **Progress persistence** - Remember what steps completed across sessions
6. **CI parity** - Show how to run tests the same way CI does (under review)

## Future Commands (Separate Features)

### `/pro:security` - Security Audit Command
**Purpose:** Audit codebase for common security issues

**Features:**
- Verify `.env` is in `.gitignore`
- Run `npm audit` for known vulnerabilities
- Scan for hardcoded secrets/credentials
- Check for exposed API keys in code
- Validate security headers (for web apps)

**Why separate:** Security auditing is a distinct concern from onboarding. New devs need to get productive first; security review is an ongoing practice.

---

## CodeRabbit Review Findings (Addressed)

1. **"All 4 phases" → "All 5 phases"** - Fixed references to correctly state 5 phases
2. **"Recent" ambiguity for build detection** - Simplified to binary existence check, deferred staleness detection to future enhancement
3. **CLAUDE.md reference** - Made conditional with note "(if using Claude Code)"
4. **Explicit .env flow** - Added detailed flow with numbered steps and clearer handling

---

## Related ADRs

- [007. Interactive Phased Onboarding with Partial Detection](../../doc/decisions/007-interactive-phased-onboarding-with-partial-detection.md)

## Related

- [Previous planning: WTF alias](../feat-wtf-alias-and-report-output/plan.md) - Where onboarding was first documented
- [Handoff command](../../pro/commands/handoff.md) - Similar but documentary approach
