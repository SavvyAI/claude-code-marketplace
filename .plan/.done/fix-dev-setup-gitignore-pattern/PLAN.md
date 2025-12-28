# Bug Fix: /pro:dev.setup gitignore pattern

## Bug Details

| Field | Value |
|-------|-------|
| Severity | Critical (blocks work) |
| Branch | `fix/dev-setup-gitignore-pattern` |
| Backlog ID | 14 |

### Steps to Reproduce
1. Run `/pro:dev.setup` on a project
2. Check the resulting `.gitignore` file
3. Observe that `.dev/` (entire directory) is ignored instead of specific files

### Expected Behavior
- `.dev/` directory **tracked** by git
- `.dev/servers.json` **tracked** (team configuration)
- `.dev/README.md` **tracked** (documentation)
- `.dev/pid.json` **ignored** (runtime data)
- `.dev/log/` **ignored** (log files)

### Actual Behavior
- `.dev/` is added to `.gitignore`, ignoring the entire directory
- Configuration files cannot be shared across team

## Root Cause Analysis

The issue is in `pro/commands/dev.setup.md` Phase 5 (lines 238-257).

**Current Instructions:**
```markdown
### 5.2 Add Entries

Append these entries if not already present:

```
# npx dev runtime files
.dev/pid.json
.dev/log/
```
```

**Problem:** The instructions are ambiguous:
1. No explicit warning against adding `.dev/` as a catch-all
2. No clear statement about what MUST be tracked
3. Claude may interpret "runtime files" broadly and add `.dev/`

## Fix Implementation

### Changes to `pro/commands/dev.setup.md`

Rewrite Phase 5 to be explicit about:
1. **EXACTLY** which patterns to add (no more, no less)
2. **EXPLICITLY** what should NOT be ignored
3. Why the distinction matters

### Updated Phase 5 Content

```markdown
## Phase 5: Update .gitignore

### 5.1 Check Current .gitignore

Read `.gitignore` if it exists.

### 5.2 Add Entries

**CRITICAL:** Add ONLY these specific patterns. Do NOT add `.dev/` as a catch-all.

The `.dev/` directory contains both:
- **Runtime files** (should be gitignored): `pid.json`, `log/`
- **Configuration files** (must be tracked): `servers.json`, `README.md`

Append these **exact entries** if not already present:

```
# npx dev runtime files (config files are tracked)
.dev/pid.json
.dev/log/
```

⚠️ **DO NOT add `.dev/` to .gitignore** - this would ignore the entire directory including `servers.json` which must be version controlled for team sharing.

Use Edit tool to append to `.gitignore`, or Write if it doesn't exist.

Report: `[PASS] Updated .gitignore (tracking .dev/servers.json, ignoring .dev/pid.json and .dev/log/)`
```

## Verification Steps

1. Run `/pro:dev.setup` on a test project
2. Verify `.gitignore` contains:
   ```
   # npx dev runtime files (config files are tracked)
   .dev/pid.json
   .dev/log/
   ```
3. Verify `.gitignore` does NOT contain `.dev/`
4. Run `git status` and confirm:
   - `.dev/servers.json` shows as untracked (ready to add)
   - `.dev/README.md` shows as untracked (ready to add)
   - `.dev/pid.json` is ignored
   - `.dev/log/` is ignored
