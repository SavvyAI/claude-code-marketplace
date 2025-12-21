# Plan: Add `/pro:bug` Command

## Objective

Create a bug reporting command that guides users through structured bug capture with reproduction steps, root cause investigation, and systematic fix implementation.

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Command name | `/pro:bug` | Short, clear, parallel to `/pro:feature` |
| Branch prefix | `fix/` | Industry standard, maps to Conventional Commits |
| Repro capture | Guided prompts | Capture forensic details while context is fresh |
| Investigation | Yes, investigate first | Gather evidence before implementing |

## Files Modified

| File | Action |
|------|--------|
| `pro/commands/bug.md` | Created |
| `pro/readme.md` | Updated commands table and workflow |

## Bug Details Captured

1. Steps to Reproduce (ordered, copy-pastable)
2. Expected Behavior
3. Actual Behavior
4. Environment (env, browser, device, commit/branch)
5. Severity (blocks work vs annoyance)

## Workflow Comparison

| Aspect | `/pro:feature` | `/pro:bug` |
|--------|----------------|------------|
| Focus | Intent discovery | Forensic capture |
| Initial questions | Requirements/scope | Repro steps, expected vs actual |
| Before implementation | Design approach | Investigate root cause |
| Branch prefix | `feat/` | `fix/` |
| Verification | Features work | Bug no longer reproduces |

## Tasks

- [x] Create feature branch
- [x] Create `/pro/commands/bug.md`
- [x] Update `/pro/readme.md`
- [x] Store planning docs
- [ ] Run coderabbit review

## Known Limitations

- Currently no `hotfix/` variant for urgent production issues (could be added later as `/pro:hotfix`)
- No integration with issue trackers (GitHub Issues, Jira, etc.)

## Related ADRs

- [004. Forensic Capture Workflow for Bug Command](../../doc/decisions/004-forensic-workflow-for-bug-command.md)
