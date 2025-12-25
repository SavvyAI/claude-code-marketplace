---
description: "Ready to work on something? → Pick items from backlog → Creates branch and begins implementation"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

## Context

The backlog is stored in `.plan/backlog.json` at the project root. It contains categorized and prioritized items from audits, manual additions, and other sources.

## Your Task

1. **Read the backlog**
   - Check if `.plan/backlog.json` exists
   - If not, inform user: "No backlog found. Use `/pro:backlog.add <description>` to add items or `/pro:audit` to analyze your code."

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

3. **Filter open items**
   - Only show items with `status: "open"`
   - If no open items, inform user: "Backlog is empty. Nice work!"

4. **Group and sort items**
   - Group by `category` (Security, Tests, i18n, Debt, Feature, Bug)
   - Within each category, sort by severity (critical > high > medium > low)

5. **Present items for selection**
   - Use `AskUserQuestion` to present items as selectable options
   - Enable `multiSelect: true` so user can choose multiple related items
   - Format each option label as: `[Category] [severity] title`
   - Include item ID and description in the option description
   - NOTE: All selected items will be worked on in ONE branch

6. **Create branch and begin work**
   - Generate a descriptive branch name based on selected items:

     **Branch prefix by category:**
     | Category | Prefix |
     |----------|--------|
     | security, bug, tests | `fix/` |
     | feature | `feat/` |
     | debt | `refactor/` |
     | i18n | `chore/` |

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
      "category": "security|tests|i18n|debt|feature|bug",
      "severity": "low|medium|high|critical",
      "fingerprint": "file.ts:42-45|issue-type",
      "source": "manual|/pro:audit|/pro:feature",
      "sourceBranch": "feat/example-branch",
      "createdAt": "2024-12-25T00:00:00Z",
      "status": "open|in-progress|resolved|blocked|wont-fix",
      "resolvedAt": "2024-12-26T00:00:00Z",      // optional, present when status === "resolved"
      "resolvedBranch": "feat/fix-the-issue"     // optional, present when status === "resolved"
    }
  ]
}
```

## Category Display Order

Present categories in this order (skip empty categories):
1. Security
2. Bug
3. Tests
4. Feature
5. Debt
6. i18n

## Example Selection UI

```
Select items to work on (will be grouped into one branch):

[ ] [Security] [critical] Hardcoded API key in config.ts
[ ] [Security] [high]     Missing auth check on /api/users
[ ] [Bug]      [high]     Payment flow crashes on empty cart
[ ] [Tests]    [medium]   Missing unit tests for auth flow
[ ] [Feature]  [low]      Add dark mode support
[ ] [Debt]     [low]      TODO: refactor validation logic
[ ] [i18n]     [low]      Hardcoded "Submit" string

Tip: Select related items to work on together.
```

## Definition of Done

- User has selected items to work on
- Branch created with descriptive name
- Backlog items updated to `in-progress`
- Planning directory created
- Plan mode entered
