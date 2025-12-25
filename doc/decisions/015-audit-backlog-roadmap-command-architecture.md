# 015. Audit, Backlog, and Roadmap Command Architecture

Date: 2024-12-25

## Status

Accepted

## Context

The existing `/pro:gaps` command combines analysis and remediation in a single flow, making it unclear when to use it and bloating its responsibilities. Similarly, `/pro:known.issues` serves as both a backlog viewer and issue tracker, but lacks the structure to support a proper development workflow.

Several pain points emerged:

1. `/pro:gaps` both analyzes AND creates branches to fix — unclear separation of concerns
2. `/pro:known.issues` is a flat list without categorization or prioritization
3. No high-level visibility into project status (what's done, in progress, backlogged)
4. Reports saved to `.plan/` could become stale and mislead other commands
5. PRD/spec intake has no backlog preservation — stories not immediately worked on are lost

## Decision

Restructure the command architecture into three focused commands:

### `/pro:audit` — Analysis + Capture

**Purpose:** Analyze current work for gaps and optionally capture findings to backlog.

**Behavior:**
1. Run comprehensive analysis
2. Display report on screen
3. Write timestamped report to temp directory (e.g., `/tmp/audit-report-2024-12-25.md`)
4. Prompt: "Would you like to capture any findings to backlog?"
5. Show prioritized, categorized list (nothing selected by default)
6. User multi-selects items to capture
7. Ask: "Would you like to open the report?"

**Analysis Categories:**
- Requirements coverage
- Unit tests
- Integration tests
- E2E tests
- Edge cases (conservative — avoid false positives)
- Error handling
- Documentation
- Production readiness:
  - `console.log` removal (use production logger)
  - `debugger` statements (allow if using conditional debug tools)
  - TODO/FIXME extraction
  - Hardcoded secrets
  - Hardcoded env values (URLs, ports)
  - Security basics (HIPAA/SOC-audit level)
  - Performance red flags (N+1, blocking ops, memory leaks)
  - Accessibility
  - i18n/Localization

**Selection UI:**
- Grouped by category (Security, Tests, i18n, Debt, etc.)
- Within category, sorted by priority
- Priority badges shown: `[critical]`, `[high]`, `[medium]`, `[low]`
- Items already in backlog marked as non-selectable with backlog reference

**Backlog Deduplication:**
- Fingerprint matching: `file_path + line_range + issue_type`
- Prevents duplicate entries when re-running audit

### `/pro:backlog` — Work Selection

**Purpose:** Select items from backlog to work on.

**Behavior:**
1. Display backlog items grouped by category
2. Within category, sorted by priority
3. User multi-selects related items (all go into one branch)
4. Create feature branch
5. Enter plan mode / begin work

**Selection UI:**
```
Select items to work on:

[ ] [Security] [critical] Hardcoded API key in config.ts
[ ] [Security] [high]     Missing auth check on /api/users
[ ] [i18n]     [low]      Hardcoded "Login" string
[ ] [i18n]     [low]      Hardcoded "Submit" string
[ ] [Tests]    [medium]   Missing unit tests for auth flow
```

**Branch Strategy:**
- All selected items go into ONE branch
- Related items should be selected together
- For unrelated work, pick one item at a time

### `/pro:roadmap` — Visibility Dashboard

**Purpose:** High-level snapshot of project status.

**Behavior:**
1. Display dashboard on screen
2. Write timestamped report to temp directory
3. Ask: "Would you like to open the report?"

**Sections:**
- **In Progress:** Current branch, uncommitted changes
- **Completed:** Backlog items with `status: resolved` + merged to main
- **Backlog:** Items grouped by category with counts
- **Blocked:** Items with `status: blocked`

**Output Example:**
```
═══════════════════════════════════════════════════
  ROADMAP                            project-name
═══════════════════════════════════════════════════

▶ IN PROGRESS (2)
  ├─ feat/audit-command          ← current branch
  └─ PR #34: Add retry logic

✓ RECENTLY COMPLETED (5)
  ├─ Feature: User authentication
  ├─ Feature: Payment flow
  └─ ... 3 more

☐ BACKLOG (12)
  ├─ [Security] 2 items
  ├─ [Tests] 4 items
  ├─ [Debt] 5 items
  └─ [i18n] 1 item

⚠ BLOCKED (0)

═══════════════════════════════════════════════════
```

## File Organization

| Location | Contents | Persisted |
|----------|----------|-----------|
| `.plan/backlog.json` | Source of truth for all backlog items | Yes |
| `$TMPDIR/audit-report-{date}.md` | Ephemeral audit snapshots | No |
| `$TMPDIR/roadmap-{date}.md` | Ephemeral roadmap snapshots | No |

**Key principle:** Reports are OUTPUT artifacts for humans, never INPUT for commands. Commands always read from source of truth (git + `backlog.json`).

## Backlog Schema

```json
{
  "lastSequence": 1,
  "items": [
    {
      "id": 1,
      "title": "Brief description",
      "description": "Full detailed description",
      "category": "security|tests|i18n|debt|feature|bug",
      "severity": "low|medium|high|critical",
      "fingerprint": "file.ts:42-45|issue-type",
      "source": "manual|/pro:audit|/pro:feature",
      "sourceBranch": "feat/example-branch",
      "createdAt": "2024-12-25T00:00:00Z",
      "status": "open|in-progress|resolved|blocked|wont-fix"
    }
  ]
}
```

## Consequences

### Positive

- Clear separation of concerns (analyze vs. work vs. view)
- Single source of truth in `backlog.json`
- No stale report risk — reports in temp, commands read source
- Categorized and prioritized backlog improves discoverability
- Fingerprinting prevents duplicate backlog entries
- CI-compatible (file output, headless capable)

### Negative

- Breaking change: `/pro:gaps` and `/pro:known.issues` deprecated
- Migration needed for existing `known-issues.json` → `backlog.json`
- More complex backlog schema to maintain

## Commands Deprecated

| Old Command | Replacement |
|-------------|-------------|
| `/pro:gaps` | `/pro:audit` |
| `/pro:known.issues` | `/pro:backlog` |
| `/pro:continue` | `/pro:backlog.resume` |
| `/pro:audit.fix` | Not needed — use `/pro:backlog` after audit |

## State-Aware Backlog

When running `/pro:backlog`, the command first checks for in-progress work:

1. If items with `status: "in-progress"` exist, show them and prompt:
   - **Resume this work** → Runs `/pro:backlog.resume` behavior
   - **Mark as blocked and start new** → Updates status, then shows backlog
   - **Start new work anyway** → Proceeds to backlog selection

2. If no in-progress items, show backlog selection as normal

This ensures users always know what state they're in before picking new work.

## Open Items

Captured as known issue #8:
- PRD/spec intake workflow — need a way to parse multi-story specs and persist backlog without losing stories that aren't immediately worked on

## Related

- Known issue #1: Original request to split `/pro:gaps`
- Known issue #8: PRD/spec intake workflow
- Existing: `.plan/known-issues.json` (to be migrated to `backlog.json`)
