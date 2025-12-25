# 013. Centralized JSON Index for Known Issues

Date: 2024-12-24

## Status

Accepted

## Context

During development, issues are often discovered but deferred for later. Previously, these were documented inconsistently - sometimes in per-branch markdown files (`.plan/{branch}/known-issues.md`), sometimes not at all. This made it difficult to:

1. Remember what issues existed across different feature efforts
2. Find and prioritize issues for future work
3. Track where issues originated and their severity

We needed a standardized way to capture, store, and retrieve known issues.

## Decision

Create a centralized JSON index at `.plan/known-issues.json` that:

1. **Mirrors the ADR index pattern** - Uses the same structure as `adr-index.json` with `lastSequence` for auto-incrementing IDs
2. **Stores issues globally, not per-branch** - Issues persist and are accessible from any branch
3. **Tracks provenance** - Each issue records `source` (which command discovered it) and `sourceBranch` (where it was found)
4. **Uses JSON over Markdown** - Enables programmatic filtering, aggregation, and future tooling

The new `/pro:known.issues` command provides:
- **List mode** (no args): Interactive selection of issues to address
- **Add mode** (with args): Quick issue capture with severity prompts

## Consequences

### Positive

- Single source of truth for all known issues
- Queryable and filterable structure
- Consistent with existing `adr-index.json` pattern
- Enables future features (e.g., issue counts, severity dashboards)

### Negative

- JSON less human-readable than Markdown when browsing files directly
- Requires tooling to view/edit (vs. plain text editing)
- Migration needed for any existing per-branch `known-issues.md` files

## Alternatives Considered

### Per-branch Markdown Files
Keep `known-issues.md` in each `.plan/{branch}/` directory.

**Rejected because:** Issues would be scattered, hard to aggregate, and lost when branches are deleted.

### Single Markdown File
Use `.plan/known-issues.md` as a flat Markdown list.

**Rejected because:** Harder to parse programmatically, no automatic ID assignment, prone to formatting inconsistencies.

### GitHub Issues Integration
Store issues directly in GitHub Issues.

**Rejected because:** Adds external dependency, requires network access, mixes internal development notes with public-facing issues.

## Related

- Planning: `.plan/.done/feat-known-issues-command/`
- Similar pattern: `.plan/adr-index.json`
