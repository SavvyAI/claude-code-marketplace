# Implementation Plan: `/pro:git.main`

## Overview

Utility command to standardize a repository's default branch name to `main`.

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Branch Strategy | Feature branch + PR | New command surface area deserves review |
| Permission Checking | Pre-check via `gh api` | Fail fast before any mutation |
| Local-Only Repos | Supported | Standardization is valuable before first push |

## Command Classification

Per **ADR-017**, `/pro:git.main` is a **non-work-initiating command**:
- Does NOT create a feature branch when invoked
- Operates directly on repository state
- Similar to `/pro:audit` and `/pro:roadmap` in classification

## Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│  ➊ INSPECT                                                   │
│  • Detect current default branch                            │
│  • Check if `main` already exists                           │
│  • Check working tree cleanliness                           │
│  • Check for remote                                         │
│  • If remote: check permissions via gh api                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  ➋ SAFETY GATES (any failure = halt)                        │
│  • Uncommitted changes → HALT                               │
│  • `main` branch exists → HALT                              │
│  • Detached HEAD → HALT                                     │
│  • No permission to change default → HALT                   │
│  • Already on `main` → NO-OP                                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  ➌ DISPLAY INTENT                                            │
│  • Show what will happen                                    │
│  • "No changes have been made yet."                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  ➍ EXPLICIT CONFIRMATION                                     │
│  • Prompt: Type "CONFIRM RENAME TO MAIN"                    │
│  • Any other input → abort                                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  ➎ EXECUTE                                                   │
│  Local:                                                     │
│  • git branch -m <old> main                                 │
│                                                             │
│  Remote (if exists):                                        │
│  • git push origin main                                     │
│  • gh api to update default branch                          │
│  • git push origin --delete <old>                           │
│  • git branch -u origin/main main                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  ➏ VERIFY & REPORT                                           │
│  • Confirm local rename                                     │
│  • Confirm remote update (if applicable)                    │
│  • Show success message                                     │
└─────────────────────────────────────────────────────────────┘
```

## Implementation Steps

### Step 1: Create command file

Create `pro/commands/git.main.md` with:
- YAML frontmatter (description, allowed-tools)
- Inspection phase instructions
- Safety gate logic
- Confirmation prompt requirements
- Execution steps
- Success/failure output templates

### Step 2: Git operations

The command will use these git operations:

```bash
# Detect current branch
git symbolic-ref --short HEAD

# Check for uncommitted changes
git status --porcelain

# Check if main exists
git show-ref --verify --quiet refs/heads/main

# Check for detached HEAD
git symbolic-ref HEAD 2>/dev/null || echo "detached"

# Check for remote
git remote get-url origin 2>/dev/null

# Rename local branch
git branch -m <current> main

# Push new branch to remote
git push -u origin main

# Update remote default branch (GitHub)
gh api -X PATCH repos/{owner}/{repo} -f default_branch=main

# Delete old remote branch
git push origin --delete <old>
```

### Step 3: Permission checking

```bash
# Get repository permissions
gh api repos/{owner}/{repo} --jq '.permissions'

# Expected: { "admin": true, ... } or { "maintain": true, ... }
```

### Step 4: Documentation

Update `pro/readme.md` with `/pro:git.main` in command list.

## Output Templates

### Inspection Output
```
Default branch detected: master
Target standard branch: main

This command will:
• Rename branch 'master' → 'main'
• Update the repository default branch
• Sync local and remote references

No changes have been made yet.
```

### Safety Gate Halt
```
Cannot proceed.

Reason:
• Working tree has uncommitted changes

Resolve this issue and re-run /pro:git.main
```

### Success Output (with remote)
```
✔ Branch renamed successfully
• Previous default: master
• New default: main

✔ Remote default branch updated
✔ Local tracking references synced

Repository is now standardized on 'main'.
```

### Success Output (local-only)
```
✔ Branch renamed successfully
• Previous default: master
• New default: main

ℹ No remote configured — local rename only.

Repository is now standardized on 'main'.
```

### No-op Output
```
✔ Default branch is already 'main'
No action required.
```

## Files to Create/Modify

| File | Action | Status |
|------|--------|--------|
| `pro/commands/git.main.md` | Create | Done |
| `pro/readme.md` | Modify (add to command list) | Done |

## Testing Considerations

Manual testing scenarios:
1. Repo with `master` default, remote configured
2. Repo already on `main`
3. Repo with `main` branch existing (not default)
4. Repo with uncommitted changes
5. Repo in detached HEAD
6. Local-only repo (no remote)
7. User without admin permissions

## Definition of Done

- [x] Command file created with full specification
- [x] readme.md updated
- [ ] Manual testing of all scenarios
- [ ] No errors, bugs, or warnings
