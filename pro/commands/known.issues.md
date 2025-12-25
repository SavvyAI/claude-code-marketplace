---
description: "Track deferred work → Lists known issues for selection → Address them without having to remember"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "AskUserQuestion"]
---

## Context

Known issues are tracked in `.plan/known-issues.json` at the project root.

## Your Task

Determine the mode based on whether arguments were provided:

### Mode 1: List Issues (no arguments)

If the user ran `/pro:known.issues` without arguments:

1. **Read the index**
   - Check if `.plan/known-issues.json` exists
   - If not, inform user: "No known issues tracked yet. Use `/pro:known.issues <description>` to add one."

2. **Filter open issues**
   - Only show issues with `status: "open"`
   - If no open issues, inform user: "No open issues. Nice work!"

3. **Present issues for selection**
   - Use `AskUserQuestion` to present issues as selectable options
   - Enable `multiSelect: true` so user can choose multiple
   - Format each option as: `[severity] title`
   - Include issue ID in the description for reference

4. **Address selected issues**
   - Enter **plan mode**
   - Create a feature branch for the work (e.g., `fix/known-issue-{id}` or descriptive name)
   - Plan the implementation to address the selected issue(s)
   - Follow standard implementation workflow

### Mode 2: Add Issue (with arguments)

If the user ran `/pro:known.issues <description>`:

1. **Parse the description**
   - The full argument string is the issue description
   - Generate a title (first 80 characters, or first sentence)

2. **Determine severity**
   - If severity is obvious from context, use it
   - Otherwise, ask the user:
     ```
     What severity level?
     - low: Nice-to-have improvement
     - medium: Should be addressed soon
     - high: Causing problems for users
     - critical: Blocking or security issue
     ```

3. **Ensure directory and index exist**
   - Check if `.plan/` directory exists; create it if missing: `mkdir -p .plan`
   - If `.plan/known-issues.json` doesn't exist, initialize with:
     ```json
     {
       "lastSequence": 0,
       "issues": []
     }
     ```
   - If directory creation or file write fails, inform user of the error and stop

4. **Add the issue**
   - Increment `lastSequence`
   - Get current git branch for `sourceBranch`
   - Create the issue object:
     ```json
     {
       "id": <next sequence>,
       "title": "<first 80 chars or first sentence>",
       "description": "<full description>",
       "severity": "<chosen severity>",
       "source": "manual",
       "sourceBranch": "<current branch>",
       "createdAt": "<ISO 8601 timestamp>",
       "status": "open"
     }
     ```

5. **Write and confirm**
   - Save updated JSON to `.plan/known-issues.json`
   - Confirm: "Added issue #<id>: <title>"

## Schema Reference

```json
{
  "lastSequence": 1,
  "issues": [
    {
      "id": 1,
      "title": "Brief description",
      "description": "Full detailed description",
      "severity": "low|medium|high|critical",
      "source": "manual|/pro:gaps|/pro:feature|development",
      "sourceBranch": "feat/example-branch",
      "createdAt": "2024-12-24T00:00:00Z",
      "status": "open|in-progress|resolved|wont-fix"
    }
  ]
}
```

## Examples

**Adding an issue:**
```
/pro:known.issues Consider splitting /pro:gaps into separate analyze and fix commands
```

**Listing and selecting issues:**
```
/pro:known.issues
```
