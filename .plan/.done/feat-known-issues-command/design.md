# Design: Known Issues System

## JSON Schema

```json
{
  "lastSequence": 6,
  "issues": [
    {
      "id": 1,
      "title": "No Offline Mode for README badge validation",
      "description": "If network is unavailable, badge and link validation will fail. Currently warns user and proceeds with syntax-only checks.",
      "severity": "low",
      "source": "/pro:gaps",
      "sourceBranch": "feat/readme-beauty-mode-formatting-control",
      "createdAt": "2024-12-15T10:30:00Z",
      "status": "open"
    },
    {
      "id": 2,
      "title": "Consider splitting /pro:gaps into analyze and fix commands",
      "description": "The current /pro:gaps command both analyzes gaps AND creates branches to fix them. Consider whether this should be two separate commands for clearer purpose.",
      "severity": "low",
      "source": "manual",
      "sourceBranch": "feat/known-issues-command",
      "createdAt": "2024-12-24T00:00:00Z",
      "status": "open"
    }
  ]
}
```

## Field Definitions

| Field | Type | Description |
|-------|------|-------------|
| id | number | Auto-incremented unique identifier |
| title | string | Brief description (< 80 chars) |
| description | string | Detailed explanation |
| severity | enum | `low`, `medium`, `high`, `critical` |
| source | string | How issue was discovered: `/pro:gaps`, `/pro:feature`, `manual`, or free text |
| sourceBranch | string | Git branch where issue was identified |
| createdAt | string | ISO 8601 timestamp |
| status | enum | `open`, `in-progress`, `resolved`, `wont-fix` |

## Command Behavior

### `/pro:known.issues` (no args)

1. Read `.plan/known-issues.json`
2. Filter to show only `open` issues
3. Present in interactive modal (similar to clarifying questions)
4. User selects one or more issues
5. Enter plan mode to address selected issues

### `/pro:known.issues <description>` (with args)

1. Read `.plan/known-issues.json` (or create if doesn't exist)
2. Increment `lastSequence`
3. Create new issue with:
   - `id`: next sequence number
   - `title`: provided description (truncated to 80 chars if needed)
   - `description`: provided description (full)
   - `severity`: prompt user or infer from context
   - `source`: "manual"
   - `sourceBranch`: current git branch
   - `createdAt`: current ISO timestamp
   - `status`: "open"
4. Write updated JSON
5. Confirm to user

## Integration Points

### In `/pro:gaps` and `/pro:feature` (step 9)

Replace:
```
9. Document any known issues that won't be addressed here so they can be addressed in a subsequent effort.
```

With:
```
9. Document any known issues that won't be addressed here:
   - For each issue, use `/pro:known.issues <description>` to add to the index
   - Or update `.plan/known-issues.json` directly if adding multiple issues
```

## File Location

`.plan/known-issues.json` - Same directory as `adr-index.json` for consistency.
