# Improve Command Help Descriptions

## Branch
`docs/improve-command-help-descriptions`

## Objective
Update command descriptions shown in Claude Code autocomplete to be more beginner-friendly and provide context about when/why to use each command.

## Problem Statement
Current command descriptions are terse technical statements that don't help beginners understand:
- When to run each command in the SDLC workflow
- Why they would use this command
- What scenario/use case it addresses
- The sequence and flow between commands

## User Requirements
- Conversational & friendly tone (use "you")
- Subtle workflow sequencing hints (without explicit command references)
- Help beginners understand the development cycle
- Keep descriptions scannable in autocomplete UI
- Focus on the "when/why/what" pattern

## Approach
Update the `description` field in each command's YAML frontmatter using this format:
**"When/Why question? → What happens → Result"**

Example transformation:
- **Before:** "Create & check out a new feature branch, entering plan mode to define its implementation"
- **After:** "Starting something new? → Plan your approach with guided questions → Creates a feature branch ready for implementation"

## Commands to Update

1. `/pro:feature` - commands/feature.md
2. `/pro:continue` - commands/continue.md
3. `/pro:gaps` - commands/gaps.md
4. `/pro:refactor` - commands/refactor.md
5. `/pro:pr` - commands/pr.md
6. `/pro:pr.resolve` - commands/pr.resolve.md
7. `/pro:pr.merged` - commands/pr.merged.md

## New Descriptions

### /pro:feature
```
Starting something new? → Plan your approach with guided questions → Creates a feature branch ready for implementation
```

### /pro:continue
```
Picking up where you left off? → Resumes your work using saved planning notes → Jump back into active development
```

### /pro:gaps
```
Ready to verify completeness? → Analyzes requirements coverage, tests, and edge cases → Catches what you might have missed
```

### /pro:refactor
```
Need to improve existing code? → Creates a dedicated branch for refactoring → Systematic code improvements without breaking features
```

### /pro:pr
```
Feature complete and tested? → Archives planning docs and analyzes commits → Creates a comprehensive pull request
```

### /pro:pr.resolve
```
Received review feedback? → Addresses all PR comments systematically → Resolves reviewer concerns efficiently
```

### /pro:pr.merged
```
PR successfully merged? → Cleans up planning artifacts and branches → Completes the development cycle
```

## Testing
- Verify descriptions display correctly in Claude Code autocomplete
- Check length/formatting in the UI
- Ensure tone is consistent across all commands

## Success Criteria
- All 7 command descriptions updated
- Descriptions are beginner-friendly and contextual
- User confirms improvements in autocomplete display
- No errors or formatting issues
