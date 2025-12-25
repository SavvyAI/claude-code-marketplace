# Implementation Notes

## What Was Implemented

### 1. New Command: `/pro:known.issues`

Created `pro/commands/known.issues.md` with two modes:

- **No args**: Lists open issues in an interactive modal for selection, then enters plan mode to address selected issues
- **With args**: Adds a new issue to the index with auto-generated ID, prompts for severity

### 2. Centralized Known Issues Index

Created `.plan/known-issues.json` with schema:
- `lastSequence`: Auto-incrementing ID counter
- `issues[]`: Array of issue objects with id, title, description, severity, source, sourceBranch, createdAt, status

### 3. Integration with Existing Commands

Updated step 9 (or equivalent) in these commands to reference the new system:
- `/pro:feature` (step 9)
- `/pro:gaps` (step 9)
- `/pro:bug` (step 10)
- `/pro:pr` (step 5)
- `/pro:refactor` (step 7)

### 4. Migration

Migrated 6 existing issues from `.plan/.done/feat-readme-beauty-mode-formatting-control/known-issues.md` to the new JSON index.

## Design Decisions

1. **JSON over Markdown** - Chose JSON for the index to enable programmatic access, filtering, and aggregation. Mirrors the `adr-index.json` pattern.

2. **Centralized vs Per-Branch** - Issues are stored centrally (not per-branch) because they need to persist across branches and be accessible from any branch.

3. **Source Tracking** - Each issue tracks where it was discovered (`source`) and which branch it was on (`sourceBranch`) for traceability.

## Files Changed

- `pro/commands/known.issues.md` (new)
- `pro/commands/feature.md` (updated step 9)
- `pro/commands/gaps.md` (updated step 9)
- `pro/commands/bug.md` (updated step 10)
- `pro/commands/pr.md` (updated step 5)
- `pro/commands/refactor.md` (updated step 7)
- `.plan/known-issues.json` (new, with 7 migrated issues)
