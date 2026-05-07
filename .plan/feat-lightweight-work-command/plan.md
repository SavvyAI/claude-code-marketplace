# Plan: /pro:ops (Lightweight Work Command)

## Goal

Add a new `/pro:ops` command for lightweight operational/executive repo work that is neither a feature nor a chore.

## Why

Existing work-initiating commands are optimized for code-heavy workflows (planning depth, review, verification). Ops work needs lower ceremony while keeping branch-first safety and traceability.

## Scope

- Add `pro/commands/ops.md` with a streamlined workflow.
- Extend backlog category taxonomy to include `ops` for `/pro:backlog` display + branch prefix mapping.
- Document decision via ADR.

## Non-Goals

- No new automation hooks.
- No changes to `/pro:pr` workflow.

## Implementation Steps

1. Implement `pro/commands/ops.md`.
2. Update `/pro:backlog` command spec to recognize `ops` category and map it to `ops/` branches.
3. Update taxonomy documentation (ADR + ADR-017 update).
4. Add backlog item for traceability.
5. Verify docs and JSON parsing.
