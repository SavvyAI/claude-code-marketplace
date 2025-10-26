---
description: "Create & check out a new feature branch, entering plan mode to define its implementation"
allowed-tools: ["Bash"]
---

## Context

Let's plan the implementation for: $ARGUMENTS

## Your Task

0. Enter **plan mode** (announce this to the user).
1. Confirm and document the requirements and scope.
2. Ask clarifying questions until mutual clarity is reached on the design and approach.
3. Generate a clear, descriptive feature branch name based on the agreed work.
4. Create and switch to the new branch.
5. Store all planning notes, todos, and related documentation here: `${ProjectRoot}/.plan/${BranchName}` with the following branch naming strategy: `fix/pattern-matcher-tests-static-rule` >> `fix-pattern-matcher-tests-static-rule`.
6. Outline detailed implementation steps.
7. Implement the feature and document changes.
8. `> coderabbit --prompt-only`
9. Document any known issues that won't be addressed here so they can be addressed in a subsequent effort.

## Definition of Done
> SEE: @claude.md

- All features meet the agreed specification.
- Verified by both user and assistant.
- No errors, bugs, or warnings.
