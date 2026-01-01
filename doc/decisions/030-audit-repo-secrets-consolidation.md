# 030. Audit Repo Command and Secrets Consolidation

Date: 2026-01-01

## Status

Accepted

## Context

The existing `/pro:audit.security` command included a Phase 4 (Secrets Scanning) that covered:
- Secrets in current files (pattern matching)
- Secrets in git history (truffleHog/gitleaks)

A user request for `/pro:audit.repo` introduced additional repository-level hygiene checks:
- Sensitive file tracking (.gitignore coverage)
- Environment file audit (.env vs .env.example consistency)
- CI/CD secrets hygiene (hardcoded secrets in workflow files)
- Public readiness assessment (go/no-go recommendation)

This created a question: should secrets scanning be duplicated in both commands, or consolidated?

## Decision

**Create `/pro:audit.repo` as the single source of truth for repository-level secrets and hygiene scanning.**

The architecture becomes:

```
/pro:audit
├── /pro:audit.quality       (code quality, tests, docs)
└── /pro:audit.security      (CVE, OWASP, framework-specific)
    └── Phase 4 → /pro:audit.repo  (secrets + repository hygiene)
```

Specific changes:

1. **Create `/pro:audit.repo`** with comprehensive repository checks:
   - Secrets in git history (truffleHog/gitleaks)
   - Secrets in current files (pattern matching)
   - Sensitive file tracking
   - .gitignore hygiene validation
   - Environment file audit
   - CI/CD secrets hygiene
   - Public readiness score

2. **Modify `/pro:audit.security` Phase 4** to delegate to audit.repo rather than duplicate the secrets scanning logic.

3. **No change to `/pro:audit`** - it already runs audit.security, which transitively runs audit.repo.

## Consequences

### Positive

- **Single source of truth** - Secrets scanning logic lives in one place
- **No duplication** - Patterns, tools, and fingerprints defined once
- **Extended coverage** - audit.repo adds .gitignore, .env, and CI/CD checks that weren't in audit.security
- **Standalone utility** - Users can run audit.repo independently for quick public readiness checks
- **Consistent fingerprints** - All repository-level findings use the same fingerprint formats

### Negative

- **Transitive dependency** - audit.security now depends on audit.repo
- **Slightly more complex hierarchy** - Three levels of audit commands instead of two
- **Two reports in standalone mode** - Running audit.repo standalone produces its own report, separate from audit.security

### Migration

No migration needed. The change is additive:
- audit.security's Phase 4 now includes additional checks it didn't have before
- Fingerprint formats are backward compatible (same secret fingerprints work)

## Alternatives Considered

### 1. Duplicate secrets scanning in both commands

**Rejected because:**
- Maintenance burden of keeping two implementations in sync
- Risk of divergent behavior
- Wasted execution time if both run

### 2. Add repository hygiene checks to audit.security directly

**Rejected because:**
- audit.security is already large (~470 lines)
- Repository hygiene is conceptually distinct from CVE/OWASP analysis
- Users may want quick public readiness checks without full security audit

### 3. Keep audit.repo completely separate (no integration)

**Rejected because:**
- Would require users to run two commands for comprehensive security
- Secrets scanning would be duplicated
- Unified scorecard would miss repository findings

## Related

- ADR-015: Audit, Backlog, and Roadmap Command Architecture
- ADR-020: Audit Command Namespace Hierarchy
