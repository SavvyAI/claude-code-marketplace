---
description: "Already on main? → No-op | Different default? → Renames to main → Standardizes repo"
allowed-tools: ["Bash", "Read", "AskUserQuestion"]
---

# Standardize Default Branch to `main`

Safely rename a repository's default branch to `main` with explicit confirmation.

## Core Behavior

- **No flags** - No dry-run, no bypass, no shortcuts
- **Always interactive** - Inspection first, then confirmation
- **Safe by default** - Hard stops for risky conditions
- **One path, one outcome** - Predictable and trustworthy

---

## Execution Flow

### Phase 1: Inspect

Automatically detect repository state:

```bash
# Current branch
CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)

# Detached HEAD check
if [ -z "$CURRENT_BRANCH" ]; then
  echo "DETACHED"
fi

# Default branch from remote (if exists)
DEFAULT_BRANCH=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5)

# Check if main exists locally
git show-ref --verify --quiet refs/heads/main && echo "MAIN_EXISTS"

# Check for uncommitted changes
git status --porcelain

# Check for remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
```

**Report findings:**

```
Default branch detected: master
Target standard branch: main

This command will:
• Rename branch 'master' → 'main'
• Update the repository default branch
• Sync local and remote references

No changes have been made yet.
```

---

### Phase 2: Safety Gates

**HALT if any condition is true:**

| Condition | Error Message |
|-----------|---------------|
| Working tree has uncommitted changes | `Working tree has uncommitted changes` |
| Branch `main` already exists (and is not current) | `A branch named 'main' already exists` |
| Detached HEAD state | `Repository is in detached HEAD state` |
| No permission to change default (remote only) | `Insufficient permissions to change default branch` |

**Output format for halt:**

```
Cannot proceed.

Reason:
• <specific reason>

Resolve this issue and re-run /pro:git.main
```

**No bypass. No override. Hard stop.**

---

### Phase 3: Permission Check (Remote Only)

If a remote exists, verify permissions before proceeding:

```bash
# Get owner/repo from remote URL
REMOTE_URL=$(git remote get-url origin)
# Parse owner/repo (handles both HTTPS and SSH formats)

# Check permissions
gh api repos/{owner}/{repo} --jq '.permissions'
```

**Required:** `admin: true` OR `maintain: true`

If permission check fails:

```
Cannot proceed.

Reason:
• Insufficient permissions to change default branch
• Required: admin or maintain access

Contact a repository admin to change the default branch.
```

---

### Phase 4: No-Op Check

If already on `main` and it's the default:

```
✔ Default branch is already 'main'
No action required.
```

Exit cleanly. No confirmation needed.

---

### Phase 5: Explicit Confirmation

**Prompt the user with AskUserQuestion:**

```
Ready to rename default branch.

Current: master
Target: main

This will:
• Rename local branch
• Push new branch to remote (if configured)
• Update remote default branch
• Delete old remote branch
• Update local tracking

Type the confirmation phrase to proceed.
```

**Confirmation options:**

| Option | Label | Description |
|--------|-------|-------------|
| A | `CONFIRM RENAME TO MAIN` | Execute the rename operation |
| B | `Cancel` | Abort without changes |

**Only proceed if user selects option A with exact phrase.**

Any other input → abort with "No changes made."

---

### Phase 6: Execute

#### Local-Only Repository (no remote)

```bash
# Get current branch name
OLD_BRANCH=$(git symbolic-ref --short HEAD)

# Rename branch
git branch -m "$OLD_BRANCH" main
```

#### Repository with Remote

```bash
# Get current branch name
OLD_BRANCH=$(git symbolic-ref --short HEAD)

# Rename local branch
git branch -m "$OLD_BRANCH" main

# Push new branch to remote
git push -u origin main

# Update remote default branch (GitHub)
gh api -X PATCH "repos/{owner}/{repo}" -f default_branch=main

# Delete old remote branch
git push origin --delete "$OLD_BRANCH"

# Ensure tracking is correct
git branch -u origin/main main
```

---

### Phase 7: Verify & Report

#### Success (with remote)

```
✔ Branch renamed successfully
• Previous default: master
• New default: main

✔ Remote default branch updated
✔ Local tracking references synced

Repository is now standardized on 'main'.
```

#### Success (local-only)

```
✔ Branch renamed successfully
• Previous default: master
• New default: main

ℹ No remote configured — local rename only.

Repository is now standardized on 'main'.
```

---

## Error Handling

| Error | Action |
|-------|--------|
| `git branch -m` fails | Report error, suggest manual resolution |
| `git push` fails | Report error, branch is renamed locally but not pushed |
| `gh api` fails (after push) | Warn that push succeeded but default not updated; provide manual command |
| `git push --delete` fails | Warn that old branch may still exist on remote |

**Always report the exact git/gh command that failed and its output.**

---

## Notes

- This command does NOT create a feature branch — it operates directly
- Per ADR-017, this is a non-work-initiating utility command
- Supports local-only repositories (adjusts behavior automatically)
- Pre-checks permissions via `gh api` before any mutation
- Requires explicit phrase confirmation for safety
