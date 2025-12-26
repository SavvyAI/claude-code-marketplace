# ADR 018: MVP Cut Line with MoSCoW Prioritization

## Status

Accepted

## Date

2025-12-25

## Context

When working through a backlog toward MVP, users need visibility into:
1. What items are required for MVP vs. post-MVP
2. Progress toward MVP completion
3. A way to work through all MVP items systematically

Currently, the backlog system has `severity` (critical/high/medium/low) and `category` (security/bug/feature/etc.) but no concept of "release phase" or "MVP scope."

When importing PRDs/specs via `/pro:spec.import`, there's no way to capture priority annotations that distinguish MVP from future work.

## Decision

### 1. Adopt MoSCoW Notation as the Phase System

MoSCoW (Must/Should/Could/Won't) is an industry-standard prioritization framework that:
- Originated in DSDM (1994) and is widely recognized
- Maps cleanly to MVP thinking: MUST = MVP, everything else = post-MVP
- Provides semantic richness beyond simple P0/P1/P2 labels
- Is self-documenting for stakeholders

### 2. Add Phase Fields to Backlog Schema

```json
{
  "phase": "must|should|could|wont",
  "phaseSource": "explicit|inferred"
}
```

- `phase`: The MoSCoW classification
- `phaseSource`: Whether phase was explicitly marked in source or inferred

### 3. Detect MoSCoW Markers in Spec Import

When `/pro:spec.import` parses specs, detect patterns:

| Pattern | Phase |
|---------|-------|
| `[MUST]`, `[M]`, `(MUST)` | `must` |
| `[SHOULD]`, `[S]`, `(SHOULD)` | `should` |
| `[COULD]`, `[C]`, `(COULD)` | `could` |
| `[WONT]`, `[W]`, `(WON'T)`, `[WON'T]` | `wont` |

Example spec line:
```markdown
- US-001 [MUST] As a user, I can sign up with email
```

### 4. Infer Phase from Severity When Not Explicit

For items without explicit MoSCoW markers:

| Severity | Inferred Phase | Rationale |
|----------|----------------|-----------|
| `critical` | `must` | Must work for product to function |
| `high` | `must` | Core functionality, blocking issues |
| `medium` | `should` | Important but not MVP-blocking |
| `low` | `could` | Nice to have, polish |

Set `phaseSource: "inferred"` to distinguish.

### 5. New Command: `/pro:backlog.mvp`

A dedicated command to run through all MVP items:

1. Filter for `phase: "must"` items
2. Show MVP scope summary
3. Confirm with user
4. Create single branch: `mvp/{project-slug}`
5. Mark items as `in-progress` with `mvpBatch: true`
6. Work through items sequentially
7. Support pause/resume via `/pro:backlog.resume`

### 6. Enhanced `/pro:backlog` Display

- Show phase badges: `[MUST]`, `[SHOULD]`, etc.
- Group/sort by phase within categories
- MVP items selected by default when running selection

## Consequences

### Positive

- **Clear MVP visibility:** Users know exactly what's in vs. out of MVP
- **Industry-standard notation:** MoSCoW is recognizable by stakeholders
- **Seamless import:** Specs with MoSCoW markers flow through cleanly
- **Graceful fallback:** Severity-based inference when no explicit markers
- **Single-branch MVP:** All MVP work consolidated for easier tracking

### Negative

- **Schema addition:** New optional fields on backlog items
- **Command addition:** `/pro:backlog.mvp` adds to command count
- **Inference may differ from intent:** Severity != priority in all cases

### Mitigations

- Fields are optional; existing items continue to work
- Inference is marked as such; users can override
- Clear confirmation step before starting MVP workflow

## Alternatives Considered

### 1. Priority Numbers (P0, P1, P2)

Rejected because:
- Less semantic richness than MoSCoW
- Tells "when" but not "why"
- Varies across organizations

### 2. Simple MVP Boolean

Rejected because:
- No granularity for post-MVP prioritization
- Forces binary choice with no nuance

### 3. Release Field (v1.0, v1.1, v2.0)

Rejected because:
- Requires knowing release plan upfront
- More complex to manage
- MoSCoW abstracts away versioning details

## Related

- ADR-015: Audit, Backlog, and Roadmap Command Architecture
- ADR-017: Branch Naming Invariant and Work-Type Taxonomy
- Backlog item #10: MVP cut line workflow
