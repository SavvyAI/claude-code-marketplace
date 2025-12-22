# Feature: PR Version Check

## Problem

Version numbers in `pro/.claude-plugin/plugin.json` may not get updated when features are added. No automated check exists to remind about version bumps before PR creation.

## Decision

**Approach**: Modify `/pro:pr` only - no new commands
**Versioning**: Simple increment check - did version change? Yes/No
**Behavior**: Soft-fail with clear message if unchanged

### Why This Approach

- Lowest cognitive load
- Versioning enforced exactly where it matters: at PR time
- No command sprawl
- Easier to maintain and harder to bypass

### Why Simple Increment

- SemVer enforcement turns into bikeshedding
- The real win is consistency, not correctness theater
- Message should be explicit and boring

## Implementation

Add a step to `pro/commands/pr.md` before commit/push:

1. **Find version file** - Search project root for common version files (package.json, Cargo.toml, pyproject.toml, etc.). Let AI infer based on what exists.
2. **Compare versions** - Read current vs base branch using `git show main:{file}`
3. **If unchanged** - Warn user, offer choice to bump or proceed

### Design Choice: Runtime Inference

Instead of hardcoding a detection table, we give hints about common locations and let the AI figure out:
- Which file contains the version
- How to extract it (JSON, TOML, XML, etc.)
- How to update it if needed

This keeps the prompt simple and handles new ecosystems without updates.

## Deferred

- `/pro:version` command - until a real need emerges
- SemVer enforcement - can be added via config later if needed
- Pre-commit hook documentation - nice-to-have, not blocking

## Definition of Done

- [x] `/pro:pr` checks version before commit
- [x] Clear warning message if version unchanged
- [x] User can proceed or bump (soft-fail)
- [x] No new commands added

## Related ADRs

- [005. Runtime Inference for Version Check](../../doc/decisions/005-runtime-inference-for-version-check.md)
