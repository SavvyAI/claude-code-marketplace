---
description: "Want to see the big picture? → Dashboard of in-progress, completed, and backlog → Snapshot of project status"
allowed-tools: ["Bash", "Read", "Glob", "Grep"]
---

## Context

Roadmap provides a high-level view of project status by reading from git history and the backlog.

## Your Task

### 1. Gather Data

#### In Progress
- Get current branch name
- Check for uncommitted changes: `git status --porcelain`
- Check for open PRs: `gh pr list --state open --json number,title,headRefName`

#### Completed
- Read backlog items with `status: "resolved"`
- Cross-reference with merged commits on main branch
- Get recent merged PRs: `gh pr list --state merged --limit 10 --json number,title,mergedAt`

#### Backlog
- Read `.plan/backlog.json`
- Filter items with `status: "open"`
- Group by category, count items

#### Blocked
- Filter backlog items with `status: "blocked"`

### 2. Generate Dashboard

```
═══════════════════════════════════════════════════════════════
  ROADMAP                                        {project-name}
═══════════════════════════════════════════════════════════════

▶ IN PROGRESS ({count})
  ├─ {branch-name}                               ← current branch
  │   └─ {uncommitted changes summary if any}
  └─ PR #{number}: {title}

✓ RECENTLY COMPLETED ({count})
  ├─ #{id}: {title}
  ├─ #{id}: {title}
  └─ ... {n} more

☐ BACKLOG ({total count})
  ├─ [Security]  {count} items
  ├─ [Bug]       {count} items
  ├─ [Tests]     {count} items
  ├─ [Feature]   {count} items
  ├─ [Debt]      {count} items
  └─ [i18n]      {count} items

⚠ BLOCKED ({count})
  └─ #{id}: {title} — {reason if available}

═══════════════════════════════════════════════════════════════
  Generated: 2024-12-25T14:30:00Z
═══════════════════════════════════════════════════════════════
```

### 3. Output Report

1. Display dashboard on screen
2. Write timestamped report to temp directory:
   - Path: `$TMPDIR/roadmap-{YYYY-MM-DD-HHmmss}.md` (filesystem-friendly format)
   - Example: `$TMPDIR/roadmap-2024-12-25-143000.md`
   - Tell user: "Report saved to {path}"

### 4. Offer to Open Report

Ask: "Would you like to open the report?"
- If yes, open in default editor based on platform:
  - macOS: `open {report-path}`
  - Linux: `xdg-open {report-path}`
  - Windows: `start {report-path}`

## Section Details

### In Progress Section
- Always show current branch
- Show uncommitted changes count if any
- List open PRs from GitHub

### Completed Section
- Show backlog items with `status: "resolved"` that have been merged
- Show up to 5 recent items, then "+ N more"
- Order by resolution date (most recent first)

### Backlog Section
- Group by category in this order: Security, Bug, Tests, Feature, Debt, i18n
- Skip categories with 0 items
- Show count per category

### Blocked Section
- Show items with `status: "blocked"`
- If item has a blocking reason in description, show it

## Edge Cases

- **No backlog file:** Show "No backlog found"
- **Empty backlog:** Show "Backlog is empty"
- **No git repo:** Show error and exit
- **No GitHub access:** Skip PR sections, show local data only

## Definition of Done

- Dashboard displayed on screen with all sections
- Report written to temp file
- User offered to open report
