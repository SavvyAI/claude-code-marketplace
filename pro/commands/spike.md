---
description: "Exploring something uncertain? → Time-boxed investigation with optional documentation → Creates a spike branch for learning-first work"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

## Context

Let's explore: $ARGUMENTS

## What is a Spike?

A spike is time-boxed exploratory work focused on **uncertainty reduction**, not delivery.

**Spike characteristics:**
- Learning over completion
- Exploration over delivery
- No guarantee of merge or continuation
- May be discarded, promoted to feature, or merged as-is

## Your Task

0. Enter **plan mode** (announce this to the user).
1. **Check ADRs for related decisions** - Search `doc/decisions/` for prior decisions related to this exploration. Summarize any relevant decisions.
2. Clarify the spike scope:
   - What uncertainty are we trying to reduce?
   - What would "success" look like for this spike?
   - What is the time-box? (suggest a reasonable default if not specified)
3. Generate a clear, descriptive `spike/` branch name based on the exploration goal.
4. Create and switch to the new branch.
5. **Add to backlog as in-progress** - This enables `/pro:backlog.resume` to pick up where you left off:
   - Ensure `.plan/backlog.json` exists (create with `{"lastSequence": 0, "items": []}` if not)
   - Increment `lastSequence` and add item:
     ```json
     {
       "id": <next sequence>,
       "title": "<brief title from exploration goal>",
       "description": "<full description including what we're trying to learn>",
       "category": "spike",
       "severity": "medium",
       "fingerprint": "spike|<id>|<slugified-title>",
       "source": "/pro:spike",
       "sourceBranch": "<branch name>",
       "createdAt": "<ISO 8601 timestamp>",
       "status": "in-progress"
     }
     ```
6. Create minimal planning directory: `${ProjectRoot}/.plan/${BranchName}` (branch naming: `spike/foo-bar` → `spike-foo-bar`)
7. Begin exploration. Document findings as you go (inline comments, notes, or code).
8. **After exploration, prompt the user:**
   > "Would you like to document your findings? This helps preserve institutional memory for future reference."
   - If yes: Create `.plan/{branch}/findings.md` with:
     - What was explored
     - Key learnings
     - Decisions made (or deferred)
     - Recommendations for next steps
   - If no: Proceed without formal documentation

## Spike Lifecycle

After exploration, the spike can:
1. **Be discarded** - Learning complete, no further action needed
2. **Be promoted to feature** - Use `/pro:feature` to start proper implementation based on findings
3. **Be merged as-is** - If the spike produced usable code

**Note:** Spikes do not require CodeRabbit review since they may not merge.

## Browser Verification

For web applications, use Playwright MCP (if available) rather than screenshots for:
- Visual verification and UI state inspection
- Console log and error analysis
- Network request inspection

## Definition of Done

- The uncertainty that motivated the spike has been reduced or resolved.
- Findings are documented (if user opted in).
- Next steps are clear (discard, promote, or merge).
