# 004. Forensic Capture Workflow for Bug Command

Date: 2025-12-21

## Status

Accepted

## Context

The `/pro:feature` command uses an "intent discovery" workflow: clarifying requirements and scope, then designing an approach before implementation. When adding a bug reporting command, we needed to decide whether to reuse the same workflow or design a bug-specific approach.

Bugs and features have fundamentally different characteristics:
- Features start with unclear requirements that need refinement
- Bugs start with an observable failure that needs investigation
- Features benefit from design before implementation
- Bugs benefit from root cause analysis before implementation

## Decision

We designed `/pro:bug` with a "forensic capture" workflow that differs from `/pro:feature`:

1. **Guided prompts capture structured details** (repro steps, expected/actual behavior, environment, severity) instead of open-ended requirements discussion
2. **Root cause investigation phase** precedes implementation planning
3. **Verification confirms bug no longer reproduces** using original repro steps
4. **`fix/` branch prefix** aligns with Conventional Commits

## Consequences

**Positive:**
- Higher quality bug reports captured when context is fresh
- Root cause investigation reduces "fix the symptom, not the cause" failures
- Structured format improves handoff between developers
- Conventional Commits alignment enables automated changelogs

**Negative:**
- More upfront prompts may feel slower for trivial bugs
- No `hotfix/` variant for urgent production issues (can be added later)
- No issue tracker integration

## Alternatives Considered

1. **Reuse `/pro:feature` workflow** - Rejected because feature's "intent discovery" doesn't match bug's "forensic capture" needs

2. **Minimal wrapper around `/pro:feature`** - Rejected because bug-specific prompts (repro steps, expected vs actual) require different structure

3. **Optional prompts (skippable with Enter)** - Considered but deferred; structured capture is more valuable while context is fresh

## Related

- Planning: `.plan/.done/feat-add-bug-command/`
