# Bug Analysis: MVP Command Prompts Instead of Running Unattended

## Bug Details

**Severity:** High (degraded experience)
**Branch:** fix/mvp-unattended-workflow
**Backlog ID:** #40

### Steps to Reproduce
1. Run `/pro:backlog.mvp`
2. Command shows MVP scope summary
3. **BUG:** Command prompts for confirmation to proceed
4. After each item, command prompts for next action

### Expected Behavior
- Command runs through ALL MVP items unattended
- Makes a commit at each milestone
- Continues automatically until MVP is complete
- No prompts or questions asked

### Actual Behavior
- Command prompts for confirmation before starting (Step 4)
- After each item, prompts "[N]ext item | [P]ause | [Q]uit" (Step 7.3)
- Requires user interaction at multiple points

## Root Cause Analysis

The bug is in the command definition at `pro/commands/backlog.mvp.md`.

### Issue 1: Step 4 - Confirmation Prompt

Lines 86-96 explicitly define a confirmation prompt:

```markdown
### Step 4: Confirm with User

Use `AskUserQuestion`:
question: "Proceed with MVP workflow? This will create branch and work through all {N} items."
options:
  - "Start MVP workflow" (recommended)
  - "Review items first" → show detailed list, then re-prompt
  - "Cancel"
```

**This is unnecessary friction.** When a user runs `/pro:backlog.mvp`, they are explicitly requesting the MVP workflow. No confirmation needed.

### Issue 2: Step 7.3 - Per-Item Prompt

Lines 152-158 define a prompt after each item:

```markdown
3. After item is complete:
   - Update item: `status: "resolved"`, `resolvedAt: "<timestamp>"`
   - Remove `mvpBatch: true` (no longer in active batch)
   - Prompt for next action:
     ```
     Item #{id} complete!

     [N]ext item | [P]ause (resume later) | [Q]uit MVP workflow
     ```
```

**This contradicts the unattended goal.** The MVP command should:
1. Complete an item
2. Make a commit
3. **Automatically** proceed to next item
4. Only stop when all items are done or a critical error occurs

### Issue 3: Missing Commit at Milestones

The current command definition does NOT specify committing after each item. Step 7.2 says:
- "Implement the item"
- "Verify completion"

But it never says "commit the changes". This is a gap in the original design.

## Proposed Fix

1. **Remove Step 4 confirmation** - Treat running the command as implicit consent
2. **Remove Step 7.3 prompt** - Auto-proceed to next item
3. **Add commit step** after each item completion
4. **Keep pause/resume capability** via `/pro:backlog.resume` (already exists)
5. **Update Definition of Done** to reflect unattended operation

## Files to Modify

- `pro/commands/backlog.mvp.md` - Main command definition

## ADR Considerations

This fix aligns with ADR-018 which states:
> "Work through items sequentially"

The ADR doesn't mandate user prompts between items. The prompts were an over-cautious implementation choice, not a design requirement.
