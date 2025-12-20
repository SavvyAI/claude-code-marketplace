# /pro:copy.questions Command

## Objective

Create a utility command that copies the most recent clarifying questions from the conversation to the clipboard, formatted as Markdown.

## Use Case

User flow:
1. Model presents clarifying questions in tabbed interface
2. User presses `Escape` to dismiss
3. User runs `/pro:copy.questions`
4. Command copies questions to clipboard
5. User pastes into another model or document

## Requirements

- No arguments needed - infers from conversation context
- Format: Markdown list with header
- Output: Copy to clipboard via `pbcopy`, confirm to user

## Files Modified

- `pro/commands/copy.questions.md` - Simplified to retrieval-based approach

## Tasks

- [x] Create feature branch
- [x] Update copy.questions.md with retrieval-based approach
- [x] Create planning docs
- [x] Commit changes
- [x] Create PR

## Known Limitations

- Relies on model's ability to recall recent conversation context
- Cannot intercept questions before they're shown (user accepts this)
