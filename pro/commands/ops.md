---
description: "Not quite a chore or feature? → Fast branch + minimal planning → Execute lightweight repo workflows (exec/ops/opportunities)"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion", "WebFetch"]
---

## Context

We need to handle a lightweight work item: $ARGUMENTS

This is for tasks that are:
- Not really a feature (no implementation spec, no code-heavy review)
- Not really a chore (not maintenance/infra/tests/deps)
- Often operational/executive workflow updates (dashboards, records, statuses)
- Sometimes results in no repo changes at all

## Your Task

**CRITICAL: Branch creation is MANDATORY and must happen FIRST. Never perform any
investigation, code reading, or changes until the branch exists. This is a non-negotiable
safety invariant per ADR-017.**

0. **IMMEDIATELY create branch** - Generate an `ops/` branch name from the initial description
   (`$ARGUMENTS`) and create it. Do NOT proceed to any other step until this is complete.
   Example: "update opportunity stage" -> `ops/update-opportunity-stage`

1. Enter **plan mode** (announce this to the user).

2. **Check ADRs for related decisions** - Search `doc/decisions/` for prior decisions related to this work.
   Summarize any relevant decisions before proposing changes.

3. Confirm scope and success criteria (fast):
   - What system are we updating? (repo files vs external system like CRM)
   - If external-only: what should be recorded in-repo (if anything)?
   - What does "done" look like? (1 sentence)

4. **Add to backlog as in-progress** - Lightweight work still needs traceability.
   - Ensure `.plan/backlog.json` exists (create with `{"lastSequence": 0, "items": []}` if not)
   - Increment `lastSequence` and add item:
     ```json
     {
       "id": <next sequence>,
       "title": "<brief title>",
       "description": "<full description>",
       "category": "ops",
       "severity": "medium",
       "fingerprint": "ops|<id>|<slugified-title>",
       "source": "/pro:ops",
       "sourceBranch": "<branch name>",
       "createdAt": "<ISO 8601 timestamp>",
       "status": "in-progress"
     }
     ```

5. Create a minimal planning directory: `${ProjectRoot}/.plan/${BranchName}` (branch naming: `ops/foo-bar` -> `ops-foo-bar`).
   Keep it lean:
   - `plan.md`: 5-10 lines: goal, constraints, steps
   - `notes.md`: optional scratchpad

6. Execute the work.
   - Prefer minimal diffs.
   - If the work is external-only and there are no repo changes, write a short outcome note under the planning directory (so the branch can be merged or archived with evidence).

7. Wrap up:
   - If changes are worth keeping: proceed to `/pro:pr` (often `fast` mode is sufficient)
   - If this should be paused: use `/pro:branch.park`
   - If this was a dead-end/no-op: use `/pro:branch.rmrf`

## Intentional Differences vs /pro:feature

- No CodeRabbit step by default.
- No expectation of tests/build.
- Optimized for workflow updates and “lightweight” repo work.

## Definition of Done

- Branch exists (safety invariant satisfied)
- Backlog item created for traceability
- Repo changes made and documented, OR external-only work recorded with a brief outcome note
