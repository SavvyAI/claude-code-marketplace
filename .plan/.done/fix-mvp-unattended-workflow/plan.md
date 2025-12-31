# Implementation Plan: Fix MVP Unattended Workflow

## Summary

The `/pro:backlog.mvp` command currently prompts users at multiple points:
1. **Step 4:** Confirmation before starting
2. **Step 7.3:** Next/Pause/Quit after each item

This contradicts the expected behavior: running through ALL MVP items unattended with commits at each milestone.

## Root Cause

The command definition in `pro/commands/backlog.mvp.md` explicitly includes these prompts. This was an over-cautious implementation choice, not a design requirement from ADR-018.

## Implementation Steps

### Step 1: Remove Step 4 Confirmation Prompt

**Current (lines 83-96):**
```markdown
### Step 4: Confirm with User

Use `AskUserQuestion`:
...
```

**Change to:**
```markdown
### Step 4: Start MVP Workflow

No confirmation needed - running `/pro:backlog.mvp` is explicit intent.
Display a brief "Starting MVP workflow..." message and proceed.
```

### Step 2: Remove Step 7.3 Per-Item Prompt

**Current (lines 148-158):**
```markdown
3. After item is complete:
   - Update item...
   - Prompt for next action:
     [N]ext item | [P]ause | [Q]uit
```

**Change to:**
```markdown
3. After item is complete:
   - Update item: `status: "resolved"`, `resolvedAt: "<timestamp>"`
   - Remove `mvpBatch: true`
   - **Commit the changes** with message: "feat(mvp): #{id} {title}"
   - Display brief completion message
   - **Automatically proceed** to next item (no prompt)
```

### Step 3: Add Commit at Each Milestone

After each item is resolved:
```bash
git add -A && git commit -m "feat(mvp): #{id} {title}"
```

### Step 4: Remove Pause/Quit Options from Iterative Workflow

The current Step 7.4-7.6 handle Pause/Next/Quit. Since we're making this unattended:
- Remove the interactive prompt
- Keep the pause/resume capability via `/pro:backlog.resume` (items stay marked with `mvpBatch: true` if session is interrupted)
- Natural interruption (Ctrl+C, session timeout) will leave items in `in-progress` state, which `/pro:backlog.resume` can pick up

### Step 5: Update allowed-tools

Remove `AskUserQuestion` from allowed-tools since we're eliminating prompts.

### Step 6: Update Definition of Done

Clarify that the command runs unattended.

## Files Modified

| File | Changes |
|------|---------|
| `pro/commands/backlog.mvp.md` | Remove prompts, add commit step, update allowed-tools |

## Verification

After fix, running `/pro:backlog.mvp` should:
1. Read and filter backlog (no prompt)
2. Check for existing MVP work (no prompt, just inform if found)
3. Display MVP scope summary (no prompt)
4. Create branch (no prompt)
5. Update backlog items (no prompt)
6. For each item:
   - Show progress
   - Implement item
   - Commit changes
   - Auto-proceed to next
7. Show completion summary when done

The command should run from start to finish without any `AskUserQuestion` calls.
