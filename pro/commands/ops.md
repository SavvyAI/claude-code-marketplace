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

3. **Infer the ops mode (fast + autonomous)**

   Determine execution mode from `$ARGUMENTS` and lightweight repo signals.

   **Modes**
   - `external-only` - Update happens outside the repo (CRM, dashboards, statuses). No repo change is expected.
   - `repo-only` - Update is entirely in-repo (docs/runbooks/dashboard markdown/config).
   - `mixed` - External update + an in-repo record/update.

   **Heuristic signals (examples)**
   - External-first keywords: `crm`, `opportunity`, `pipeline`, `stage`, `deal`, `account`, `attio`, `hubspot`, `salesforce`, `airtable`, `notion`, `status update`, `follow-up`.
   - Repo-first keywords: `readme`, `docs`, `runbook`, `markdown`, `json`, `yaml`, `config`, `update table`.

   **Confidence model (deterministic)**
   - Compute a score per mode from keyword matches and any obvious repo context.
   - Compute confidence from the margin between top-2 scores.
     - High: clear winner (large margin)
     - Medium: winner exists but margin is small
     - Low: ambiguous

   **User snap-out rule**
   - If confidence is High: proceed with the inferred mode automatically.
   - If confidence is Medium: ask a single confirmation (default = inferred).
   - If confidence is Low: use `AskUserQuestion` with 3 choices (external-only / repo-only / mixed).

   Always print a single decision line before executing work, e.g.
   `Decision: mode=mixed confidence=High (0.78); runner-up=external-only (0.55)`

   **Learning artifact (only when needed)**
   - If confidence is Low OR the user overrides the inferred mode, write `.plan/{branch-slug}/inference.json`:
     - input text
     - scores
     - inferred mode + confidence
     - final mode selection
     - timestamp

4. Confirm scope and success criteria (fast):
   - What are we updating? (external system vs repo vs both)
   - What does "done" look like? (1 sentence)

5. **Add to backlog as in-progress** - Lightweight work still needs traceability.
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

6. Create a minimal planning directory: `${ProjectRoot}/.plan/${BranchName}` (branch naming: `ops/foo-bar` -> `ops-foo-bar`).
   Keep it lean:
   - `plan.md`: 5-10 lines: goal, constraints, steps
   - `notes.md`: optional scratchpad
   - `outcome.md`: required for `external-only` (and recommended for all modes)

7. Execute the work.
   - Prefer minimal diffs.
   - If mode is `external-only`: ALWAYS write `.plan/{branch-slug}/outcome.md` describing what changed externally.
   - If mode is `mixed`: write `.plan/{branch-slug}/outcome.md` and make the minimal in-repo update needed.
   - If mode is `repo-only`: make the minimal in-repo update; `outcome.md` is optional.

8. Wrap up (self-contained, no other commands)

   This command must not depend on other `/pro:*` commands.

   ### 8.1 Check what changed

   ```bash
   git status --short --branch
   git diff --stat
   ```

   ### 8.2 If there are NO repo changes

   - If mode is `external-only`, `outcome.md` should exist under `.plan/{branch-slug}/`.
   - Ask the user whether to delete the ops branch now.

   If user confirms deletion:
   ```bash
   git checkout main
   git pull origin main
   git branch -d <ops-branch>
   git push origin --delete <ops-branch>
   ```

   ### 8.3 If there ARE repo changes

   1. Create a single commit (default).
   2. Fast-forward merge into `main`.
   3. Push `main`.
   4. Offer to delete the ops branch.

   **Commit**
   ```bash
   git add -A
   git commit -m "ops: <short summary>"
   ```

   **Merge (fast path)**
   ```bash
   git checkout main
   git pull origin main
   git merge --ff-only <ops-branch>
   git push origin main
   ```

   If `--ff-only` fails, STOP and ask the user what to do (do not create a merge commit without explicit user confirmation).

   **Cleanup (optional, confirm first)**
   ```bash
   git branch -d <ops-branch>
   git push origin --delete <ops-branch>
   ```

## Intentional Differences vs /pro:feature

- No CodeRabbit step by default.
- No expectation of tests/build.
- Optimized for workflow updates and “lightweight” repo work.

## Definition of Done

- Branch exists (safety invariant satisfied)
- Backlog item created for traceability
- Mode inferred (with confidence) and user had a fast chance to override when uncertain
- External-only work recorded in `.plan/{branch-slug}/outcome.md`
- If repo changes exist: committed, ff-merged to main, pushed
- Optional: branch deleted (local + remote)
