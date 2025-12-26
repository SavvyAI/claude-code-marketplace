# MVP Cut Line Workflow

## Overview

Add MVP awareness to the backlog system using MoSCoW prioritization notation.

## Requirements

### 1. MoSCoW Phase System

Items have a `phase` field that maps to MoSCoW:

| Phase | Meaning | MVP? |
|-------|---------|------|
| `must` | Critical for launch | Yes |
| `should` | Important, not blocking | No |
| `could` | Nice to have | No |
| `wont` | Explicitly out of scope | No |

### 2. Schema Changes

Add to backlog item schema:
```json
{
  "phase": "must|should|could|wont",  // optional
  "phaseSource": "explicit|inferred"  // how phase was determined
}
```

### 3. `/pro:spec.import` Enhancement

Detect MoSCoW markers when parsing specs:

| Pattern | Phase |
|---------|-------|
| `[MUST]`, `[M]`, `(MUST)` | `must` |
| `[SHOULD]`, `[S]`, `(SHOULD)` | `should` |
| `[COULD]`, `[C]`, `(COULD)` | `could` |
| `[WONT]`, `[W]`, `(WON'T)`, `[WON'T]` | `wont` |

Set `phaseSource: "explicit"` when detected.

### 4. `/pro:backlog` Enhancement

- Show phase badge: `[MUST]`, `[SHOULD]`, etc.
- MVP items (phase: must) appear first within their category
- Visual separator between phases
- MVP items selected by default when phase data exists

### 5. New Command: `/pro:backlog.mvp`

**Purpose:** Run through all MVP items in a single branch.

**Workflow:**
1. Filter backlog for `phase: "must"` OR inferred MUST (critical/high severity)
2. Show MVP scope summary with item count and titles
3. Ask for confirmation
4. Create branch: `mvp/{project-slug}` or `mvp/{date}`
5. Mark all MVP items as `in-progress`
6. Set `mvpBatch: true` on items (to track they're part of MVP run)
7. Begin working through items sequentially
8. After each item, prompt for next or allow pause

### 6. `/pro:backlog.resume` Enhancement

- Detect MVP batch: check for items with `mvpBatch: true`
- If MVP batch in progress, resume from first incomplete item
- Show progress: "MVP Progress: 3/8 items complete"

### 7. Dynamic Phase Inference

When items lack explicit phase markers, infer from severity:

| Severity | Inferred Phase |
|----------|----------------|
| `critical` | `must` |
| `high` | `must` |
| `medium` | `should` |
| `low` | `could` |

Set `phaseSource: "inferred"` to distinguish from explicit.

## User Experience

### MVP Summary Display

```
╔════════════════════════════════════════════════════════════╗
║  MVP SCOPE                                                  ║
╠════════════════════════════════════════════════════════════╣
║                                                              ║
║  8 items marked as MUST:                                    ║
║                                                              ║
║  [MUST] US-001 User can sign up with email                  ║
║  [MUST] US-002 User can log in                              ║
║  [MUST] US-003 User can view dashboard                      ║
║  ...                                                         ║
║                                                              ║
║  Estimated: Will create branch `mvp/project-name`           ║
║                                                              ║
╚════════════════════════════════════════════════════════════╝

Proceed with MVP workflow? (Y/n)
```

### Progress During MVP Run

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MVP Progress: ████████░░░░░░░░░░░░ 3/8 complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current: US-004 User can reset password

[C]ontinue | [S]kip | [P]ause | [Q]uit
```

## Files to Modify

1. `pro/commands/spec.import.md` - Add MoSCoW detection
2. `pro/commands/backlog.md` - Add phase display and MVP selection
3. `pro/commands/backlog.mvp.md` - New command (create)
4. `pro/commands/backlog.resume.md` - Add MVP batch handling
5. `doc/decisions/018-mvp-cut-line-moscow-phases.md` - ADR (create)

## Definition of Done

- [ ] MoSCoW markers detected in spec import
- [ ] Phase field populated on backlog items
- [ ] `/pro:backlog` shows phase badges
- [ ] `/pro:backlog.mvp` runs through MVP items
- [ ] `/pro:backlog.resume` handles MVP batch
- [ ] ADR documents the decision
