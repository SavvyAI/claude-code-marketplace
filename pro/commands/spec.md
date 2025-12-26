---
description: "What specs exist? → View imported specifications and their extracted items → Read-only traceability"
allowed-tools: ["Bash", "Read", "Glob", "Grep"]
---

## Context

$ARGUMENTS

## Purpose

Provide visibility and traceability for imported specifications.

**This command:**
- Lists all imported specifications
- Displays basic metadata (title, source, import timestamp)
- Allows viewing and referencing stored specifications
- Supports traceability from derived items back to source specifications

**Constraints:**
- Read-only
- No side effects
- No work initiation
- No branch creation

## Your Task

1. **Read spec index:**
   - Check if `.plan/specs/index.json` exists
   - If not: Display "No specifications have been imported yet. Use `/pro:spec.import` to import a specification."

2. **Determine display mode:**
   - If `$ARGUMENTS` is empty: List all specs (summary view)
   - If `$ARGUMENTS` contains a spec ID (e.g., `spec-001`): Show detailed view for that spec

### Summary View (no arguments)

Display a table of all imported specs:

```
## Imported Specifications

| ID | Title | Stories | Imported |
|----|-------|---------|----------|
| spec-001 | User Authentication Feature | 5 | 2025-12-25 |
| spec-002 | Dashboard Redesign | 12 | 2025-12-26 |

Use `/pro:spec <spec-id>` to view details.
Use `/pro:spec.import` to import a new specification.
```

### Detailed View (spec ID provided)

1. **Read the spec entry from index**
2. **Read the full spec file**
3. **Query backlog for related items:**
   - Find items where `sourceSpec` matches the spec ID
   - Or where `fingerprint` starts with `spec|{spec-id}|`

4. **Display:**

```
## Specification: spec-001

**Title:** User Authentication Feature
**Imported:** 2025-12-25T14:30:00Z
**Source:** clipboard
**File:** .plan/specs/spec-001-user-authentication-feature.md

### Extracted Items

**Epics:** 2
**Stories:** 5

### Related Backlog Items

| ID | Title | Status | Category |
|----|-------|--------|----------|
| 12 | As a user, I want to log in with email | open | feature |
| 13 | As a user, I want to reset my password | in-progress | feature |
| 14 | As a user, I want to enable 2FA | open | feature |

### Spec Content

<display first 50 lines or offer to show more>

---

Use `/pro:backlog` to work on these items.
```

## Traceability Features

This command enables:

1. **Forward traceability:** Spec → Backlog items
   - See what work was derived from a spec

2. **Backward traceability:** Backlog item → Source spec
   - Understand where a requirement originated

3. **Coverage visibility:**
   - See how many items from a spec are open vs. in-progress vs. resolved

## No Side Effects

This command is strictly read-only:
- Does not modify specs
- Does not modify backlog
- Does not create branches
- Does not start work

To work on items from a spec, use `/pro:backlog`.
To import a new spec, use `/pro:spec.import`.
