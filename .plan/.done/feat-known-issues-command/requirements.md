# Requirements: /pro:known.issues Command

## Problem Statement

Known issues discovered during development are documented inconsistently or forgotten entirely. Developers shouldn't have to remember issues - they should be captured and easily retrievable.

## User Stories

1. As a developer, I want to quickly add a known issue so I can continue working without losing track of deferred work.
2. As a developer, I want to see all open issues in an interactive list so I can choose which to address now.
3. As a developer, I want issues captured automatically from `/pro:gaps` analysis so I don't have to manually transcribe them.

## Functional Requirements

### FR1: Issue Storage
- Issues stored in `.plan/known-issues.json` (centralized index)
- Each issue includes: id, title, description, severity, source, sourceBranch, createdAt, status

### FR2: List Issues (no args)
- `/pro:known.issues` displays all open issues
- Interactive modal allows selecting one or more issues to address
- After selection, enters plan mode to work on selected issues

### FR3: Add Issue (with args)
- `/pro:known.issues <description>` adds a new issue
- Auto-generates next ID from sequence
- Prompts for severity if not obvious from context
- Sets source to "manual" and captures current branch

### FR4: Integration with Existing Commands
- `/pro:gaps` step 9 saves identified issues to the index
- `/pro:feature` step 9 saves identified issues to the index
- Model can suggest adding issues during development

## Non-Functional Requirements

### NFR1: Consistency
- JSON schema mirrors `adr-index.json` pattern
- Command naming follows `pro:x.y` convention

### NFR2: Simplicity
- Adding an issue should be a single command
- Listing issues should be immediate with no setup

## Out of Scope

- Issue assignment to specific developers
- Due dates or sprint tracking
- Integration with external issue trackers (GitHub Issues, Jira)
- Whether `/pro:gaps` should be split into separate commands (documented as future consideration)
