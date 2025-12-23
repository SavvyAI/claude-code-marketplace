# Fix: PR Command Consistent Remote Detection

## Problem Statement

The `/pro:pr` command exhibits inconsistent behavior when no git remote is configured:
- **Sometimes**: Prompts to use GitHub CLI to create a repo
- **Other times**: Just shows manual "Next Steps" instructions and stops

This inconsistency happens because the `pr.md` command file lacks explicit instructions for handling git/remote prerequisites.

## Root Cause

`pr.md` Step 4 says only: "Create and push a pull request"

This is too vague. Claude Code interprets this differently each time based on:
- Conversation context
- Whether it proactively checks for a remote
- How it decides to handle missing prerequisites

## Agreed Solution

Add an explicit **"Git & Remote Prerequisites"** section to `pr.md` that runs before PR creation.

### Requirements

| Scenario | Behavior | Interaction Mode |
|----------|----------|------------------|
| No git repo | Offer to run `git init`, create initial commit, create GitHub repo | Prompt user with AskUserQuestion before executing |
| Git repo, no remote | Offer to create GitHub repo via `gh repo create` | Prompt user with AskUserQuestion before executing |
| Auth not configured | Verify `gh auth status` first, warn if not authenticated | Prompt user with AskUserQuestion before executing |

**Interaction Model:** All recovery actions use `AskUserQuestion` to prompt the user with:
- Option 1 (Recommended): Execute the automated fix
- Option 2: Skip and show manual instructions

No destructive actions are auto-executed. Users must explicitly choose to proceed.

### Implementation Steps

1. Add new "## Git & Remote Prerequisites" section before "## Your Task"
2. Include step-by-step checks with explicit commands:
   - Step 1: `gh auth status` - Check GitHub CLI authentication
   - Step 2: `git rev-parse --git-dir` - Check if directory is a git repo
   - Step 3: `git remote -v` - Check if remote exists
3. For each failure case, provide explicit recovery workflow:
   - Auth failure: Offer `gh auth login`
   - Not a git repo: Offer `git init` + `git add .` + `git commit -m "Initial commit"` + `gh repo create --source=. --push`
   - No remote: Offer `gh repo create --source=. --push`
4. Keep current "Your Task" section unchanged
5. Add "Manual PR Instructions" fallback section at end of file

## Files to Modify

- `pro/commands/pr.md` - Add prerequisites section

## Testing

Manually test these scenarios:
1. Fresh directory (no git)
2. Git repo with no remote
3. Git repo with remote but not pushed
4. Normal case (everything configured)

## Known Limitations

- Requires `gh` CLI to be installed
- Only supports GitHub (not GitLab, Bitbucket, etc.)

## Known Issues (Future Work)

1. **No `gh` CLI installation check**: If `gh` is not installed, the command will fail. A future enhancement could detect this and offer installation instructions.

2. **Interactive `gh auth login`**: The `gh auth login` command is interactive and may not work well in all terminal environments. A future enhancement could provide a non-interactive fallback.

3. **No support for non-GitHub remotes**: Users with GitLab, Bitbucket, or other providers will always see "Skip" as their only option. Future work could add support for other providers.
