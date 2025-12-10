---
description: "Ready to verify completeness? → Analyzes requirements coverage, tests, and edge cases → Catches what you might have missed"
allowed-tools: ["Bash"]
---

## Context

create a comprehensive verification and gap analysis plan 

## Your Task

0. Enter **plan mode** (announce this to the user).
1. Create a comprehensive verification and gap analysis plan 
2. Ask clarifying questions until mutual clarity is reached on the design and approach.
3. Generate a clear, descriptive feature branch name based on the agreed work.
4. Create and switch to the new branch.
5. Store all planning notes, todos, and related documentation here: `${ProjectRoot}/.plan/${BranchName}` with the following branch naming strategy: `fix/pattern-matcher-tests-static-rule` >> `fix-pattern-matcher-tests-static-rule`.
6. Outline detailed implementation steps.
7. Implement the feature and document changes.
8. `> coderabbit --prompt-only`
9. Document any known issues that won't be addressed here so they can be addressed in a subsequent effort.

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
