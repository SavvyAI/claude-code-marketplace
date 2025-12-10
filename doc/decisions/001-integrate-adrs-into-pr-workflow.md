# 001. Integrate ADRs into PR Workflow

Date: 2025-12-09

## Status

Accepted

## Context

The existing `.plan/` documentation captures task-focused planning (requirements, implementation steps, todos) but doesn't explicitly capture alternatives considered and why they were rejected. This makes "decision archaeology" difficult - answering questions like "Why did we choose X over Y?"

## Decision

Integrate Architecture Decision Records (ADRs) into the `/pro:pr` and `/pro:pr.merged` commands so that every implementation documents its key decisions.

Key aspects:
- **Location:** `doc/decisions/` with numbered files (e.g., `001-title.md`)
- **Format:** Michael Nygard style (Status, Context, Decision, Consequences, Alternatives)
- **Trigger:** Both `/pro:pr` AND `/pro:pr.merged` include ADR creation
- **Discovery:** AI extracts decisions from `.plan/` and code changes, user validates
- **Tracking:** `.plan/adr-index.json` tracks sequence numbers and prevents duplicates

## Consequences

**Positive:**
- Decisions are documented with full context and alternatives
- Future developers can understand "why" not just "what"
- Bidirectional linking connects ADRs to planning docs
- Duplicate prevention ensures ADRs aren't created twice

**Negative:**
- Adds a step to the PR workflow
- Requires maintaining an index file
- AI extraction may miss some decisions (user must validate)

## Alternatives Considered

1. **Structure only (no initial ADRs):** Create template but don't backfill - rejected because it doesn't demonstrate the workflow.

2. **Y-Statements format:** More concise but less detailed - rejected in favor of industry-standard Michael Nygard format.

3. **MADR format:** More detailed with pros/cons tables - rejected as overly complex for this use case.

4. **Optional ADR creation:** Allow skipping - rejected because inconsistent documentation defeats the purpose.

5. **Single command trigger:** Only `/pro:pr` creates ADRs - rejected because users sometimes skip `/pro:pr` and go straight to `/pro:pr.merged`.

## Related

- Planning: `.plan/.done/feat-adr-integration-workflow/`
