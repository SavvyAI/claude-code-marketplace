---
description: "Starting something new? → Plan your approach with guided questions → Creates a feature branch ready for implementation"
allowed-tools: ["Bash", "Read", "Write", "Edit"]
---

## Context

Let's plan the implementation for: $ARGUMENTS

## Your Task

0. Enter **plan mode** (announce this to the user).
1. **Check ADRs for related decisions** - Search `doc/decisions/` for prior decisions related to this work. Summarize any relevant decisions before proposing changes. Do not suggest reversing or contradicting existing ADRs without explicitly acknowledging them.
2. Confirm and document the requirements and scope.
3. Ask clarifying questions until mutual clarity is reached on the design and approach.
4. Generate a clear, descriptive feature branch name based on the agreed work.
5. Create and switch to the new branch.
6. **Add to backlog as in-progress** - This enables `/pro:backlog.resume` to pick up where you left off:
   - Ensure `.plan/backlog.json` exists (create with `{"lastSequence": 0, "items": []}` if not)
   - Increment `lastSequence` and add item:
     ```json
     {
       "id": <next sequence>,
       "title": "<brief title from requirements>",
       "description": "<full description>",
       "category": "feature",
       "severity": "medium",
       "fingerprint": "feature|<id>|<slugified-title>",
       "source": "/pro:feature",
       "sourceBranch": "<branch name>",
       "createdAt": "<ISO 8601 timestamp>",
       "status": "in-progress"
     }
     ```
7. Store all planning notes, todos, and related documentation here: `${ProjectRoot}/.plan/${BranchName}` with the following branch naming strategy: `fix/pattern-matcher-tests-static-rule` >> `fix-pattern-matcher-tests-static-rule`.
8. Outline detailed implementation steps.
9. Implement the feature and document changes.
10. `> coderabbit --prompt-only`
11. Document any known issues that won't be addressed here:
    - Use `/pro:backlog.add <description>` to add items to the backlog
    - Set `source` to `/pro:feature` and `sourceBranch` to current branch

## Browser Verification

For web applications, use Playwright MCP (if available) rather than screenshots for:
- Visual verification and UI state inspection
- Console log and error analysis
- Network request inspection

## Definition of Done
> SEE: @claude.md

- All features meet the agreed specification.
- Verified by both user and assistant.
- No errors, bugs, or warnings.
