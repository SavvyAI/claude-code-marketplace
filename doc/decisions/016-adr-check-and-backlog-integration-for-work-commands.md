# 016. ADR Check and Backlog Integration for Work Commands

Date: 2024-12-25

## Status

Accepted

## Context

Two issues were identified with the work-initiating commands (`/pro:feature`, `/pro:bug`, `/pro:refactor`):

### Problem 1: No ADR Awareness

Commands jumped directly into planning and design discussions without checking for prior architectural decisions. This led to suggestions that contradicted documented decisions (e.g., suggesting renaming `/pro:backlog.resume` back to `/pro:continue` when ADR-015 explicitly deprecated that name).

**Root cause:** The commands had no step requiring review of `doc/decisions/` before proposing changes.

### Problem 2: Work Not Resumable

When a session ended unexpectedly (credits exhausted, compaction avoidance, power loss, user choice), there was no reliable way to resume. The user had to manually remember what they were working on.

**Root cause:** Work started via `/pro:feature`, `/pro:bug`, and `/pro:refactor` was not tracked in the backlog, so `/pro:backlog.resume` couldn't find it.

### Key Insight

The backlog's primary value is not project management—it's **session persistence**. By auto-adding work to the backlog as `in-progress`, any work can be resumed via `/pro:backlog.resume`, regardless of how it was started.

This also reduces reliance on context compaction, which is lossy and more expensive. Short, focused sessions with clean handoffs via resume are preferable.

## Decision

### Change 1: Mandatory ADR Check

All work-initiating commands now require checking `doc/decisions/` as step 1 (after entering plan mode):

```markdown
1. **Check ADRs for related decisions** - Search `doc/decisions/` for prior decisions
   related to this work. Summarize any relevant decisions before proposing changes.
   Do not suggest reversing or contradicting existing ADRs without explicitly
   acknowledging them.
```

### Change 2: Auto-Add to Backlog

All work-initiating commands now auto-add an item to `.plan/backlog.json` with `status: "in-progress"` immediately after creating the branch:

| Command | Category | Severity |
|---------|----------|----------|
| `/pro:feature` | feature | medium (default) |
| `/pro:bug` | bug | mapped from severity question |
| `/pro:refactor` | debt | medium (default) |

This ensures `/pro:backlog.resume` can find and resume any work.

### Change 3: Expanded Tool Access

Commands now have access to `Read`, `Write`, and `Edit` tools (in addition to `Bash`) to manipulate the backlog file.

## Consequences

### Positive

- **No more contradicting ADRs** - Prior decisions are reviewed before proposing changes
- **All work is resumable** - `/pro:backlog.resume` works for everything
- **Reduced compaction reliance** - Clean session handoffs via backlog
- **Single source of truth** - All work tracked in `backlog.json` per ADR-015
- **Full traceability** - `source` field shows where work originated

### Negative

- Slightly longer command prompts (additional steps)
- Backlog may accumulate abandoned items (can mark as `wont-fix`)

## Commands Updated

| Command | Changes |
|---------|---------|
| `/pro:feature` | Added ADR check (step 1), added backlog integration (step 6) |
| `/pro:bug` | Added ADR check (step 1), added backlog integration (step 5) |
| `/pro:refactor` | Added ADR check (step 1), added backlog integration (step 4) |

## Backlog Item Schema (for reference)

```json
{
  "id": 1,
  "title": "Brief title",
  "description": "Full description",
  "category": "feature|bug|debt",
  "severity": "low|medium|high|critical",
  "fingerprint": "<category>|<id>|<slugified-title>",
  "source": "/pro:feature|/pro:bug|/pro:refactor",
  "sourceBranch": "feat/example-branch",
  "createdAt": "2024-12-25T00:00:00Z",
  "status": "in-progress"
}
```

## Related

- ADR-015: Audit, Backlog, and Roadmap Command Architecture
- ADR-001: Integrate ADRs into PR Workflow
