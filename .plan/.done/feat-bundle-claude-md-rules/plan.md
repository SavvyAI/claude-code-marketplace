# Feature: Bundle CLAUDE.md Rules in Pro Plugin

## Problem Statement

Having a global `~/.claude/CLAUDE.md` file provides universal instructions for Claude Code, but it's not version controlled sitting in the home directory. A better approach is to centralize it within a globally-used plugin for proper version control.

## Research Findings

- **Plugins cannot directly bundle CLAUDE.md files** - This is not a supported plugin component
- CLAUDE.md files are loaded at user (`~/.claude/`), project (`.claude/`), or enterprise level only
- Workaround: Bundle the file in the plugin and provide symlink commands for installation

## Solution Design

### Two Commands

#### 1. `/pro:rules` (Documentation)
Shows:
- Location of the bundled CLAUDE.md within the installed plugin
- Current content of the rules for review
- Ready-to-run symlink commands for manual installation (global & project-level)

#### 2. `/pro:rules.install` (Action)
Interactive command that:
- Asks user: global or project-level installation?
- Creates the symlink with proper confirmation
- Verifies the symlink was created successfully

### Files to Create

1. `pro/CLAUDE.md` - The bundled rules file (copied from user's current ~/.claude/CLAUDE.md)
2. `pro/commands/rules.md` - Documentation command
3. `pro/commands/rules.install.md` - Installation command

## Content Source

**One-time copy approach**: The content from the user's `~/.claude/CLAUDE.md` is copied into
`pro/CLAUDE.md` and committed to version control. This provides:
- Version control for the rules (git history)
- Consistent rules across all machines where the plugin is installed
- Updates require committing changes to the plugin repository

The copied content contains:
- Global Claude Code Rules
- ALWAYS section (UX first, DX second, empirical evidence, e2e tests, etc.)
- Regressions policy
- NEVER section (shortcuts, hardcoding, skipping validations, etc.)
- Server & Port Management guidelines

## Implementation Steps

1. ~~Create feature branch~~ ✓
2. ~~Create planning documentation~~ ✓
3. ~~Add CLAUDE.md file to pro plugin~~ ✓
4. ~~Create /pro:rules command~~ ✓
5. ~~Create /pro:rules.install command~~ ✓
6. ~~Test both commands~~ ✓
   - Verify command files follow plugin command format (YAML frontmatter + markdown)
   - Ensure allowed-tools are appropriate for each command
   - Confirm instructions are clear and actionable
7. ~~Run coderabbit analysis~~ ✓
   - Address feedback about variable naming clarity
   - Clarify one-time copy vs dynamic read behavior

## Definition of Done

- Both commands work as designed
- Rules file is properly bundled in the plugin
- Symlink commands are accurate and functional
- No errors, bugs, or warnings

## Related ADRs

- [003. Symlink Approach for Plugin Instructions](../../doc/decisions/003-symlink-approach-for-plugin-instructions.md)
