---
description: "Found a bug? → Capture repro steps and investigate root cause → Creates a fix branch with structured bug documentation"
allowed-tools: ["Bash"]
---

## Context

Let's investigate and fix: $ARGUMENTS

## Bug Details Capture

Before planning the fix, gather the following information through guided prompts:

1. **Steps to Reproduce** - Ordered, copy-pastable steps that reliably trigger the bug
2. **Expected Behavior** - What should happen when following those steps
3. **Actual Behavior** - What actually happens (error messages, incorrect output, etc.)
4. **Environment** - Relevant context (environment, browser, device, OS, commit/branch)
5. **Severity** - Impact level (blocks work, degraded experience, minor annoyance)

## Your Task

0. Enter **plan mode** (announce this to the user).
1. Capture bug details via the guided prompts above. Ask each question interactively.
2. Generate a clear, descriptive `fix/` branch name based on the bug description.
3. Create and switch to the new branch.
4. Store all planning notes, bug details, and related documentation here: `${ProjectRoot}/.plan/${BranchName}` with the following branch naming strategy: `fix/pattern-matcher-tests-static-rule` >> `fix-pattern-matcher-tests-static-rule`.
5. **Investigate root cause** - Gather empirical evidence, trace code paths, identify where the bug originates. Do not proceed to implementation until the root cause is understood.
6. Outline fix implementation steps.
7. Implement the fix and document changes.
8. **Verify fix** - Confirm the reproduction steps no longer trigger the bug.
9. `> coderabbit --prompt-only`
10. Document any related issues discovered that won't be addressed here.

## Browser Verification

For web applications, use Playwright MCP (if available) rather than screenshots for:
- Visual verification and UI state inspection
- Console log and error analysis
- Network request inspection

## Definition of Done
> SEE: @claude.md

- Bug no longer reproduces using the original reproduction steps.
- Root cause is documented in planning notes.
- Fix does not introduce regressions.
- Verified by both user and assistant.
- No errors, bugs, or warnings.
