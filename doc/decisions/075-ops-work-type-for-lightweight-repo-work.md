# 075. Ops Work-Type for Lightweight Repo Work

Date: 2026-05-07

## Status

Accepted

## Context

Some repos act less like "software projects" and more like an operating system for work: executive dashboards, opportunities/CRM, agent runbooks, status updates, and lightweight record changes.

These tasks:
- Aren't features (no implementation spec, minimal or no code)
- Aren't chores (not maintenance/infra/tests/deps)
- Often result in no repository changes (external-only actions)

The existing `/pro:*` work-initiating workflows are optimized for code-heavy work (deep planning, testing expectations, review tooling). That overhead creates friction for lightweight operational tasks.

## Decision

Introduce a new work-initiating command: `/pro:ops`.

- Branch prefix: `ops/`
- Backlog category: `ops`

The `/pro:ops` workflow is intentionally streamlined:
- Still enforces branch-first safety per ADR-017/ADR-052
- Creates a backlog entry for traceability
- Creates minimal planning artifacts
- Does not require CodeRabbit/test/build steps by default

## Consequences

### Positive

- Faster, lower-friction workflow for operational/executive repo tasks.
- Preserves the safety and traceability of branch-based work.
- Makes it explicit when work is not code-centric.

### Negative

- Adds another category and branch prefix to the taxonomy.
- Risk of category confusion (when to use chore vs ops) unless the command definition stays crisp.

## Alternatives Considered

### 1. Use `/pro:chore` for everything non-feature

Rejected because it conflates maintenance/code-adjacent work with operational/executive workflows.

### 2. Use `/pro:feature` but skip steps

Rejected because it encodes the wrong intent and still pulls in heavy expectations by default.

## Related

- ADR-017: `doc/decisions/017-branch-naming-invariant-and-work-type-taxonomy.md`
- ADR-052: `doc/decisions/052-branch-first-enforcement-for-work-commands.md`
