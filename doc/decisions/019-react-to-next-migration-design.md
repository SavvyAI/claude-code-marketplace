# ADR 019: React to Next.js Migration Design

## Status

Accepted

## Date

2025-12-26

## Context

Users need to migrate existing client-rendered React applications (SPAs) to Next.js for improved performance, SEO, and modern React patterns. Manual migrations are error-prone, time-consuming, and often result in broken routes or lost functionality.

The plugin needs a capability that:
1. Performs migrations deterministically
2. Preserves functional parity
3. Guarantees no broken URLs
4. Documents all changes
5. Allows review before committing

## Decision

### In-Place Migration

The command modifies the existing project directory rather than creating a new one.

**Rationale:**
- Preserves Git history for traceability
- Avoids duplication and drift
- Enables incremental migration
- Matches existing development workflows

### Work-Initiating Command

The command creates a feature branch (`feat/react-to-next-migration`) and adds a backlog entry.

**Rationale:**
- Real changes require auditable trail
- Branch-based workflow enables safe review
- Consistent with other work-initiating commands per ADR-017

### App Router as Default

App Router is the default migration target, with Pages Router as fallback.

**Rationale:**
- Aligns with Next.js future direction
- Enables streaming, layouts, RSC benefits
- Avoids accumulating technical debt
- Pages Router fallback handles edge cases

### Route Safety Guarantee

No valid URL in the original application may return 404 after migration.

**Implementation:**
1. Detect all client-side routes during preflight
2. Create explicit Next.js routes for each path
3. Generate catch-all route (`[[...slug]]`) for unmapped paths
4. Catch-all delegates to migrated application shell
5. Verify route coverage before completion

**Rationale:**
- Broken links are unacceptable in production
- Deep links and bookmarks must continue working
- Direct URL access must resolve correctly
- Better to over-catch than miss routes

### Guided Prompt Model

Migration proceeds through explicit phases with user confirmation.

**Flow:**
1. Preflight analysis (automatic)
2. Show findings and recommendations
3. Confirm router choice
4. Confirm proceeding
5. Execute migration with status updates
6. Validation and documentation

**Rationale:**
- No flags to remember
- User understands what will happen
- Explicit confirmation before changes
- Non-experts can use confidently

### Template-Based Reporting

Preflight and migration reports use shared templates in `_templates/react-to-next/`.

**Rationale:**
- Consistent output structure
- Templates can evolve independently
- Follows ADR-006 subdirectory pattern

## Consequences

### Positive

- **Deterministic:** Same input produces equivalent output
- **Observable:** All changes documented
- **Safe:** Route safety guaranteed, branch-based workflow
- **Accessible:** Guided prompts require no expertise
- **Extensible:** Pattern supports future migrations (vue.to.next, react.to.rsc)

### Negative

- **Single router target:** Must pick App or Pages Router, not hybrid
- **Detection limitations:** Complex custom routing may require manual input
- **No test migration:** Tests are documented but not automatically converted

### Neutral

- Creates additional files (catch-all route, migration report)
- Adds eslint-config-next as dev dependency

## Alternatives Considered

### New Directory Output

Create Next.js project in separate directory, copy converted files.

**Rejected because:**
- Loses Git history
- Creates drift between directories
- More complex cleanup

### Utility Command (No Branch)

Run on current branch without backlog tracking.

**Rejected because:**
- Real changes need audit trail
- Inconsistent with work-initiating command pattern
- Harder to review/rollback

### Pages Router Default

Default to Pages Router for simpler migration.

**Rejected because:**
- Accumulates technical debt
- Misses RSC benefits
- Going against Next.js direction

### Automatic Route Remediation

Auto-fix routes that fail to map.

**Rejected because:**
- Could silently break functionality
- Better to halt and prompt than guess
- User should make routing decisions

## Related

- ADR-006: Subdirectory Pattern for Shared Templates
- ADR-017: Branch Naming Invariant and Work-Type Taxonomy
- Planning: `.plan/feat-react-to-next-migration-command/`
