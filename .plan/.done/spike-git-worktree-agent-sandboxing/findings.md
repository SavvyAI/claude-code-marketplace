# Spike: Git Worktree Agent Sandboxing

**Date:** 2025-12-28
**Status:** Exploration Complete
**Time spent:** ~1 hour

## What Was Explored

Investigation of using git worktrees to create isolated sandboxes for Claude agents, inspired by DHH's workflow pattern (`ga` and `gd` shell functions).

## Key Learnings

### 1. Git Worktrees Work Perfectly for Isolation

**Verified behavior:**
- `git worktree add -b <branch> <path>` creates a sibling directory with full repo contents
- Changes in worktree do not affect main directory state
- Commits in worktrees are visible to all worktrees (shared `.git` database)
- Cleanup with `git worktree remove <path>` + `git branch -D <branch>` is clean

**DHH's naming pattern works well:**
```bash
# Creates: ../project--feature-name (sibling directory)
git worktree add -b "feature-name" "../$(basename $PWD)--feature-name"
```

### 2. Critical Constraint: One Branch per Worktree

**A branch can only be checked out in ONE worktree at a time.**

```bash
$ git worktree add ../test "agent-1"
fatal: 'agent-1' is already used by worktree at '/path/to/ccplugins--agent-1'
```

This is a feature, not a bug - prevents merge conflicts between parallel worktrees.

### 3. Claude Code Already Documents This Pattern

From Claude Code's Common Workflows documentation:
> You can run **parallel Claude Code sessions** using Git worktrees

This is a **known and recommended pattern** for running multiple Claude Code instances on the same repository.

### 4. Worktree Structure

The worktree `.git` is a **file** (not directory) pointing to main repo:
```
gitdir: /path/to/main/.git/worktrees/worktree-name
```

All branches and commits are shared. Only working directory state differs.

## Integration Options for ccplugins

### Option A: Dedicated `/pro:sandbox` Command

A new command that creates a worktree for exploratory work:

```
/pro:sandbox <description>
```

**Would create:**
- Sibling worktree: `../project--sandbox-<slug>`
- Branch: `sandbox/<slug>`
- Planning directory: `.plan/sandbox-<slug>/`

**Pros:**
- True isolation from main working directory
- User can continue working on main while sandbox experiments
- Easy cleanup on discard

**Cons:**
- Requires Claude Code to change its working directory (or spawn new instance)
- May confuse users about which directory they're in
- Adds complexity to the already-established branch workflow

### Option B: Enhance `/pro:spike` with Optional Worktree Mode

```
/pro:spike --isolated <description>
```

**Pros:**
- Backwards compatible
- User opts into isolation when they want it
- Aligns with spike's "throwaway" nature

**Cons:**
- Same cwd challenges as Option A

### Option C: Documentation-Only (No Command Integration)

Document git worktrees as a recommended pattern for:
- Running parallel Claude Code instances
- Isolating risky experiments
- Multi-agent workflows

**Pros:**
- Zero implementation effort
- Already supported by Claude Code
- User has full control

**Cons:**
- Doesn't provide automation
- User must know about worktrees

### Option D: Helper Shell Functions (DHH's Approach)

Bundle shell functions similar to DHH's `ga` and `gd`:

```bash
# ~/.zshrc or similar
pro-sandbox() {
  git worktree add -b "sandbox/$1" "../$(basename $PWD)--$1"
  cd "../$(basename $PWD)--$1"
  claude  # Start new Claude instance in sandbox
}

pro-sandbox-done() {
  # Safety: confirm, then remove worktree and branch
}
```

**Pros:**
- Simple, portable
- User controls the full lifecycle
- Works with any project

**Cons:**
- Not integrated with ccplugins workflow
- No backlog tracking

## Challenges for Plugin Integration

### 1. Claude Code cwd Handling

- Interactive mode: cwd persists between commands
- Agent/headless mode: cwd resets between bash calls (requires absolute paths)
- Changing cwd to worktree would require user action or special handling

### 2. Planning Directory Sync

The `.plan/` directory would exist in both main and worktree. Options:
- Symlink `.plan/` from worktree to main
- Keep separate planning state per worktree
- Exclude `.plan/` from worktree entirely

### 3. Multiple Claude Instances

Worktrees shine when **running multiple Claude Code instances in parallel**. This is outside ccplugins' scope (it orchestrates within a single session).

## Recommendations

### Immediate (Low effort, high value)

1. **Document the pattern** in ccplugins README or `/pro:handoff`
2. **Add a tip** to `/pro:spike` suggesting worktrees for risky experiments

### Future (If demand exists)

1. Create `/pro:worktree.create <branch>` and `/pro:worktree.remove` commands
2. These would NOT change Claude's cwd - just manage worktrees for user to `cd` into
3. Could integrate with `/pro:backlog` to show worktree-based work in progress

### Not Recommended

- Automatic cwd switching to worktrees (too disruptive)
- Making worktrees default for any command (adds complexity without clear benefit)

## Conclusion

Git worktrees are a powerful pattern for parallel agent work, but **not a good fit for command-level integration** in ccplugins. The value is in **running separate Claude instances**, which is already supported and documented.

**Best outcome:** Document this pattern and potentially add a tip to spike command. No new commands needed.

## Related

- DHH's post: Git worktrees for agent sandboxing (Dec 28, 2025)
- Claude Code docs: Common Workflows - Parallel Sessions
- ADR-017: Branch Naming Invariant and Work-Type Taxonomy
