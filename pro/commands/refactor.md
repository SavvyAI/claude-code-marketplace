---
description: "Feature Branch for Refactoring"
allowed-tools: ["Bash"]
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

## Your Task

0. Enter **plan mode** (announce this to the user).
1. Generate a clear, descriptive feature branch name based on the agreed work.
2. Create and switch to the new branch.
3. Store all planning notes, todos, and related documentation here: `${ProjectRoot}/.plan/${BranchName}` with the following branch naming strategy: `fix/pattern-matcher-tests-static-rule` >> `fix-pattern-matcher-tests-static-rule`.
4. Outline detailed implementation steps.
5. Implement the feature and document changes.
6. `> coderabbit --prompt-only`
7. Document any known issues that won't be addressed here so they can be addressed in a subsequent effort.
