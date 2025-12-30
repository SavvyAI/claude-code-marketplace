---
description: "Ready to work on something? → Pick items from backlog → Creates branch and begins implementation"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

## Context

The backlog is stored in `.plan/backlog.json` at the project root. It contains categorized and prioritized items from audits, manual additions, and other sources.

## Your Task

1. **Read the backlog**
   - Check if `.plan/backlog.json` exists
   - If not, inform user: "No backlog found. Use `/pro:backlog.add <description>` to add items or `/pro:audit.quality` to analyze your code."

2. **Check for in-progress work**
   - Filter items with `status: "in-progress"`
   - If in-progress items exist, show state and prompt:

   ```
   ┌─────────────────────────────────────────────────────────┐
   │  You have work in progress:                             │
   │                                                         │
   │  ▶ #1: [Title of in-progress item]                      │
   │    Branch: feat/example-branch                          │
   │    Started: 2024-12-25                                  │
   │                                                         │
   └─────────────────────────────────────────────────────────┘
   ```

   - Use `AskUserQuestion` to offer options:
     - **Resume this work** → Run `/pro:backlog.resume` behavior (switch to branch, read planning notes, continue)
     - **Mark as blocked and start new** → Prompt for blocking reason, update status to `blocked`, then continue to step 3
     - **Start new work anyway** → Continue to step 3 (in-progress stays as-is)

   - If no in-progress items, continue to step 3

3. **Filter items**
   - Only show items with `status: "open"`
   - **Hide phase: "wont"** items by default (out of scope)
   - **Always hide status: "wont-fix"** items (explicitly rejected)
   - If no visible items, inform user: "Backlog is empty. Nice work!"

   **Note:** `phase` and `status` are orthogonal:
   - `phase: "wont"` = out of MVP/current scope (can be reconsidered)
   - `status: "wont-fix"` = explicitly rejected (never shown)

4. **Group and sort items**
   - Group by `category` (Security, Bug, Spike, Tests, Feature, Chore, Debt, i18n)
   - Within each category, sort by:
     1. Phase (must > should > could > wont > unset)
     2. Then by severity (critical > high > medium > low)

   **Phase inference:** If item has no `phase` field, infer from severity:
   - `critical`/`high` → `must`
   - `medium` → `should`
   - `low` → `could`

5. **Present items for selection**
   - Use `AskUserQuestion` to present items as selectable options
   - Enable `multiSelect: true` so user can choose multiple related items
   - Format each option label as: `[Category] [PHASE] [severity] title`
     - Show phase badge: `[MUST]`, `[SHOULD]`, `[COULD]`, or omit for `wont`
     - If phase was inferred, show with asterisk: `[MUST*]`
   - Include item ID and description in the option description
   - **Default selection:** Pre-select all items with `phase: "must"` (explicit or inferred)
   - NOTE: All selected items will be worked on in ONE branch

   **Tip for MVP workflow:** If you want to work through ALL MVP items systematically, use `/pro:backlog.mvp` instead.

6. **Create branch and begin work**
   - Generate a descriptive branch name based on selected items:

     **Branch prefix by category:**
     | Category | Prefix |
     |----------|--------|
     | security, bug, tests | `fix/` |
     | spike | `spike/` |
     | feature | `feat/` |
     | chore, i18n | `chore/` |
     | debt | `refactor/` |

     **Branch name format:**
     - Single item: `{prefix}{category}-{short-title}` (lowercase, dash-separated, max 50 chars)
     - Multiple items (same category): `{prefix}{category}-multiple`
     - Multiple items (mixed categories): `fix/backlog-items-{date}`

   - Create and switch to the new branch
   - Update selected items' status to `in-progress` in backlog.json
   - Create planning directory `.plan/{branch-name}/` with skeleton files
   - Enter **plan mode** to design the implementation approach

## Schema Reference

```json
{
  "lastSequence": 1,
  "items": [
    {
      "id": 1,
      "title": "Brief description",
      "description": "Full detailed description",
      "category": "security|bug|spike|tests|feature|chore|debt|i18n",
      "severity": "low|medium|high|critical",
      "phase": "must|should|could|wont",         // optional, MoSCoW priority
      "phaseSource": "explicit|inferred",        // optional, how phase was determined
      "fingerprint": "file.ts:42-45|issue-type",
      "source": "manual|/pro:audit|/pro:feature",
      "sourceBranch": "feat/example-branch",
      "createdAt": "2024-12-25T00:00:00Z",
      "status": "open|in-progress|resolved|blocked|wont-fix",
      "resolvedAt": "2024-12-26T00:00:00Z",      // optional, present when status === "resolved"
      "resolvedBranch": "feat/fix-the-issue",    // optional, present when status === "resolved"
      "mvpBatch": true,                          // optional, present during MVP workflow
      "mvpBatchStartedAt": "2024-12-25T00:00:00Z" // optional, when MVP batch started
    }
  ]
}
```

## Category Display Order

Present categories in this order (skip empty categories):
1. Security
2. Bug
3. Spike
4. Tests
5. Feature
6. Chore
7. Debt
8. i18n

## Example Selection UI

```
Select items to work on (will be grouped into one branch):

MVP Items (pre-selected):
[x] [Security] [MUST*] [critical] Hardcoded API key in config.ts
[x] [Security] [MUST*] [high]     Missing auth check on /api/users
[x] [Bug]      [MUST*] [high]     Payment flow crashes on empty cart
[x] [Feature]  [MUST]  [medium]   User can sign up with email

Post-MVP Items:
[ ] [Spike]    [SHOULD] [medium]  Evaluate auth library options
[ ] [Tests]    [SHOULD] [medium]  Missing unit tests for auth flow
[ ] [Feature]  [COULD]  [low]     Add dark mode support
[ ] [Chore]    [COULD]  [low]     Update dependencies
[ ] [Debt]     [COULD]  [low]     TODO: refactor validation logic
[ ] [i18n]     [COULD]  [low]     Hardcoded "Submit" string

Tip: Select related items to work on together.
     For full MVP workflow, use /pro:backlog.mvp
```

## Definition of Done

- User has selected items to work on
- Branch created with descriptive name
- Backlog items updated to `in-progress`
- Planning directory created
- Plan mode entered
