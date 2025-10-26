---
description: "Resolve ALL PR Comments"
allowed-tools: ["Bash", "Read", "Edit", "Write", "Glob", "Grep", "TodoWrite"]
---

Resolve all unresolved comments on this PR and address every single one of them completely, regardless of priority level, severity, or whether they seem optional. Do not skip any comment - treat nitpicks, suggestions, warnings, and critical issues all with equal importance.

## Workflow:

### Phase 1: Discovery and Planning
1. Get the current PR number: `gh pr view --json number,title,url`
2. List ALL unresolved review threads with gh api graphql
3. Create a TodoWrite task list with all unresolved comments for tracking

Phase 2: Fix Each Issue

For each unresolved comment:
1. Read the current code at that location
2. Implement the suggested fix or improvement
3. Verify the fix is correct
4. Mark the todo item as completed
5. Track which threads have been addressed

Phase 3: Quality Checks

- Run all quality checks (lint, type-check, tests, build)
- Fix any issues found
- Commit all changes with a clear message listing what was fixed

Phase 4: Reply to All Comments

For each thread that was addressed, post a detailed reply of what was fixed

Commit: [commit-hash]'

Phase 5: Mark All Threads as Resolved

For each review thread, mark it as resolved using GraphQL mutation

Phase 6: Final Verification

Verify ALL threads are resolved (must return empty output):

If this returns ANY output, you are NOT done. Go back and resolve those threads.

Critical Requirements:

- ✅ Use TodoWrite to track all comments and mark them completed as you go
- ✅ Do not skip ANY comment - address all of them
- ✅ Reply to ALL comment threads with detailed explanations of fixes
- ✅ Resolve ALL threads programmatically using the GraphQL mutation
- ✅ Verify completion by confirming the verification query returns empty output
- ✅ Do not stop until verification confirms ZERO unresolved threads

Notes:

- Do not make judgment calls about which comments to address - address ALL of them
- If a comment suggests an improvement, implement it
- If it points out a potential issue, fix it
- If it recommends a change, make it
- If a comment was already addressed in a previous commit, verify the fix and still reply to the thread explaining it was
already fixed

Start by listing all unresolved comments with their file paths and line numbers using TodoWrite, then work through them one
by one until the verification query returns empty output.
