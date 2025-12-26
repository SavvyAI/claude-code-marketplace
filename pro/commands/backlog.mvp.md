---
description: "Ready for MVP? → Shows MVP scope and runs through all MUST items → Single branch, iterative workflow"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

## Context

Run through all MVP (MUST) items in the backlog systematically.

## Purpose

Provide a focused workflow for completing MVP scope:
- Identify all MVP items (explicit `phase: must` or inferred from severity)
- Show scope summary for confirmation
- Create a single MVP branch
- Work through items iteratively
- Support pause/resume via `/pro:backlog.resume`

## Your Task

### Step 1: Read and Filter Backlog

1. Read `.plan/backlog.json`
2. If not found: "No backlog found. Use `/pro:spec.import` to import a spec or `/pro:backlog.add` to add items."

3. Filter for MVP items using this logic:
   ```
   IF item.phase === "must" THEN include (explicit MVP)
   ELSE IF item.phase is undefined AND item.severity in ["critical", "high"] THEN include (inferred MVP)
   ```

4. Exclude items with:
   - `status` in `["resolved", "wont-fix", "in-progress", "blocked"]`
   - `phase: "wont"` (explicitly out of scope, regardless of severity)

5. If no MVP items found:
   - Check if there are `in-progress` items with `mvpBatch: true` → suggest `/pro:backlog.resume`
   - Otherwise: "No MVP items found. All MUST items are complete or no items are marked as MVP."

### Step 2: Check for Existing MVP Work

1. Check for items with `status: "in-progress"` AND `mvpBatch: true`
2. If found, show:
   ```
   ┌─────────────────────────────────────────────────────────────┐
   │  MVP workflow already in progress                           │
   │                                                              │
   │  Progress: 3/8 items complete                                │
   │  Current: US-004 User can reset password                     │
   │  Branch: mvp/project-name                                    │
   │                                                              │
   │  Use `/pro:backlog.resume` to continue.                      │
   └─────────────────────────────────────────────────────────────┘
   ```
3. Exit (do not start new MVP workflow while one is in progress)

### Step 3: Display MVP Scope Summary

Show all MVP items grouped by source (explicit vs inferred):

```
╔════════════════════════════════════════════════════════════════╗
║  MVP SCOPE                                    {project-name}   ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  {N} items in MVP scope:                                        ║
║                                                                 ║
║  EXPLICIT (phase: must)                                         ║
║  ──────────────────────────────────────────────────────────────║
║  [ ] #12 [MUST] User can sign up with email                     ║
║  [ ] #13 [MUST] User can log in                                 ║
║  [ ] #14 [MUST] User can view dashboard                         ║
║                                                                 ║
║  INFERRED (critical/high severity, no explicit phase)           ║
║  ──────────────────────────────────────────────────────────────║
║  [ ] #5  [critical] Fix authentication bypass                   ║
║  [ ] #8  [high] Payment flow crashes on empty cart              ║
║                                                                 ║
║  Branch: mvp/{project-slug}                                     ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

### Step 4: Confirm with User

Use `AskUserQuestion`:

```
question: "Proceed with MVP workflow? This will create branch and work through all {N} items."
options:
  - "Start MVP workflow" (recommended)
  - "Review items first" → show detailed list, then re-prompt
  - "Cancel"
```

If cancelled, exit gracefully.

### Step 5: Create MVP Branch

1. Generate branch name: `mvp/{project-slug}` or `mvp/{date}` if no project name
   - Project slug: lowercase, dash-separated from `package.json` name or directory name
   - Example: `mvp/my-project` or `mvp/2025-12-25`

2. Create and switch to branch:
   ```bash
   git checkout -b mvp/{branch-name}
   ```

3. Create planning directory:
   ```bash
   mkdir -p .plan/mvp-{branch-name}/
   ```

### Step 6: Update Backlog Items

For each MVP item:
1. Set `status: "in-progress"`
2. Set `mvpBatch: true` (marks as part of this MVP run)
3. Set `mvpBatchStartedAt: "<ISO 8601 timestamp>"`
4. Set `sourceBranch: "mvp/{branch-name}"`

Write updated backlog.json.

### Step 7: Begin Iterative Workflow

For each MVP item (in order by id):

1. Display current item:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   MVP Progress: ████████░░░░░░░░░░░░ 3/8 complete
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   ## Current Item: #{id}

   **{title}**

   {description}

   ---
   ```

2. Enter **plan mode** for the current item:
   - Create `.plan/mvp-{branch-name}/item-{id}.md` with item details
   - Design implementation approach
   - Implement the item
   - Verify completion

3. After item is complete:
   - Update item: `status: "resolved"`, `resolvedAt: "<timestamp>"`
   - Remove `mvpBatch: true` (no longer in active batch)
   - Prompt for next action:
     ```
     Item #{id} complete!

     [N]ext item | [P]ause (resume later) | [Q]uit MVP workflow
     ```

4. If **Pause**:
   - Keep remaining items as `in-progress` with `mvpBatch: true`
   - Display: "MVP paused. Use `/pro:backlog.resume` to continue."
   - Exit

5. If **Next**:
   - Continue to next item

6. If **Quit**:
   - Mark remaining items back to `status: "open"`, remove `mvpBatch`
   - Display: "MVP workflow cancelled. Completed items preserved."
   - Exit

### Step 8: MVP Complete

When all items are resolved:

```
╔════════════════════════════════════════════════════════════════╗
║                                                                 ║
║   MVP COMPLETE                                                  ║
║                                                                 ║
║   All {N} MVP items have been implemented.                      ║
║                                                                 ║
║   Branch: mvp/{branch-name}                                     ║
║   Commits: {count}                                              ║
║                                                                 ║
║   Next steps:                                                   ║
║   - Review changes: git log --oneline main..HEAD                ║
║   - Create PR: /pro:pr                                          ║
║   - Continue with SHOULD items: /pro:backlog                    ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

## Schema Reference

MVP-specific fields on backlog items:

```json
{
  "phase": "must|should|could|wont",
  "phaseSource": "explicit|inferred",
  "mvpBatch": true,
  "mvpBatchStartedAt": "2025-12-25T00:00:00Z"
}
```

## Phase Inference Rules

When `phase` is not set, infer from severity:

| Severity | Inferred Phase |
|----------|----------------|
| `critical` | `must` |
| `high` | `must` |
| `medium` | `should` |
| `low` | `could` |

## Edge Cases

- **Empty MVP:** No items match MVP criteria → inform user, suggest adding items
- **All MVP done:** All MUST items resolved → celebrate, suggest next phase
- **Interrupted session:** Items remain with `mvpBatch: true` → `/pro:backlog.resume` picks up
- **Mixed sources:** Some explicit, some inferred → group separately in display

## Definition of Done

- [ ] User confirmed MVP scope
- [ ] Branch created with `mvp/` prefix
- [ ] All MVP items worked through or paused
- [ ] Backlog updated with correct statuses
- [ ] Progress tracked for resume capability
