---
description: "Track something for later? → Add an item to the backlog → Never forget important work"
allowed-tools: ["Bash", "Read", "Write", "Edit", "AskUserQuestion"]
---

## Context

The backlog is stored in `.plan/backlog.json` at the project root.

## Your Task

Add a new item to the backlog based on the user's description.

1. **Parse the description**
   - The full argument string after `/pro:backlog.add` is the item description
   - Generate a title (first 80 characters, or first sentence)

2. **Determine category and severity**
   - Ask the user using `AskUserQuestion`:

   ```
   Question 1: What category?
   - Security: Auth, secrets, vulnerabilities
   - Bug: Something broken
   - Tests: Missing or needed tests
   - Feature: New functionality
   - Debt: Refactoring, TODOs, cleanup
   - i18n: Localization, hardcoded strings

   Question 2: What severity?
   - critical: Blocking or security issue
   - high: Causing problems for users
   - medium: Should be addressed soon
   - low: Nice-to-have improvement
   ```

3. **Ensure backlog exists**
   - Check if `.plan/` directory exists; create it if missing: `mkdir -p .plan`
   - If `.plan/backlog.json` doesn't exist, initialize with:
     ```json
     {
       "lastSequence": 0,
       "items": []
     }
     ```

4. **Add the item**
   - Increment `lastSequence`
   - Get current git branch for `sourceBranch`
   - Generate fingerprint: `manual|{id}|{slugified-title}`
     - Slug algorithm: lowercase → replace spaces/non-alphanumeric with hyphens → collapse consecutive hyphens → trim leading/trailing hyphens → truncate to 50 chars
   - Create the item object:
     ```json
     {
       "id": <next sequence>,
       "title": "<first 80 chars or first sentence>",
       "description": "<full description>",
       "category": "<chosen category>",
       "severity": "<chosen severity>",
       "fingerprint": "manual|{id}|{slug}",
       "source": "manual",
       "sourceBranch": "<current branch>",
       "createdAt": "<ISO 8601 timestamp>",
       "status": "open"
     }
     ```

5. **Write and confirm**
   - Save updated JSON to `.plan/backlog.json`
   - Confirm: "Added to backlog #<id>: <title>"

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

## Example

**Adding an item:**
```
/pro:backlog.add Consider adding retry logic to the API client for transient failures
```

**Result:**
```
Added to backlog #9: Consider adding retry logic to the API client for transient failures
```
