---
description: "Need to improve existing code? → Creates a dedicated branch for refactoring → Systematic code improvements without breaking features"
allowed-tools: ["Bash", "Read", "Write", "Edit"]
---

Review the coding standards (SEE: @claude.md), docs, and code, and refactor the code follow the standards, including:

  0. Make errors more user-friendly in development while still keeping useful debugging info.
  1. **Magic Strings/Numbers**: Replace with named constants in appropriate constant files or i18n keys
  2. **Hardcoded Values**: Move to configuration files, environment variables, or .dev/pid.json (for ports)
  3. **Duplicated Logic**: Extract to shared utilities/helpers
  4. **User-Facing Text**: Move to i18n/translations.ts with proper keys
  5. **Missing Types**: Add proper TypeScript types (no 'any', no implicit types)
  6. **Error Handling**: Ensure proper error handling with user-friendly messages
  7. **Missing Tests**: Identify what tests are needed for the change
  8. **Code Smells**: Remove commented code, console.logs, TODOs, or placeholder implementations
  9. **CLAUDE.md Violations**: Check against both global and project CLAUDE.md requirements

## Browser Verification

For web applications, use Playwright MCP (if available) rather than screenshots for:
- Visual verification and UI state inspection
- Console log and error analysis
- Network request inspection

## Your Task

0. Enter **plan mode** (announce this to the user).
1. **Check ADRs for related decisions** - Search `doc/decisions/` for prior decisions related to this code. Summarize any relevant decisions before proposing refactors. Do not suggest changes that contradict existing ADRs without explicitly acknowledging them.
2. Generate a clear, descriptive `refactor/` branch name based on the agreed work.
3. Create and switch to the new branch.
4. **Add to backlog as in-progress** - This enables `/pro:backlog.resume` to pick up where you left off:
   - Ensure `.plan/backlog.json` exists (create with `{"lastSequence": 0, "items": []}` if not)
   - Increment `lastSequence` and add item:
     ```json
     {
       "id": <next sequence>,
       "title": "<brief title from refactor scope>",
       "description": "<full description of refactor>",
       "category": "debt",
       "severity": "medium",
       "fingerprint": "debt|<id>|<slugified-title>",
       "source": "/pro:refactor",
       "sourceBranch": "<branch name>",
       "createdAt": "<ISO 8601 timestamp>",
       "status": "in-progress"
     }
     ```
5. Store all planning notes, todos, and related documentation here: `${ProjectRoot}/.plan/${BranchName}` with the following branch naming strategy: `fix/pattern-matcher-tests-static-rule` >> `fix-pattern-matcher-tests-static-rule`.
6. Outline detailed implementation steps.
7. Implement the refactor and document changes.
8. `> coderabbit --prompt-only`
9. Document any known issues that won't be addressed here:
   - Use `/pro:backlog.add <description>` to add items to the backlog
   - Set `source` to `/pro:refactor` and `sourceBranch` to current branch
