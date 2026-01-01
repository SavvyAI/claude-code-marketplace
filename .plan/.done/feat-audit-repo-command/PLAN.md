# Plan: /pro:audit.repo Command

## Summary

A repository health audit focused on secrets exposure, sensitive file hygiene, and public-readiness assessment. This command becomes the **single source of truth** for repository-level secrets scanning, with `audit.security` calling it instead of duplicating Phase 4.

## Architecture Decision

Per user clarification, the hierarchy is:

```
/pro:audit
├── /pro:audit.quality       (code quality, tests, docs)
└── /pro:audit.security      (CVE, OWASP, framework-specific)
    └── Phase 4 → /pro:audit.repo  (secrets + repository hygiene)
```

**Key change:** Move Phase 4 (Secrets Scanning) from `audit.security.md` into `audit.repo.md` to avoid duplication. `audit.security` will reference `audit.repo` at Phase 4.

## Scope

### In Scope (audit.repo)

1. **Secrets in History** - Full git history scan (not just HEAD)
   - Pattern detection: API keys, tokens, passwords, private keys
   - Uses truffleHog or gitleaks (graceful degradation)
   - Reports commit SHA for historical findings

2. **Sensitive File Tracking**
   - Check if sensitive files are tracked: `.env`, `*.pem`, `*.key`, `credentials.json`, `secrets.*`
   - Verify `.gitignore` covers common sensitive patterns
   - Compare against known sensitive file patterns

3. **Environment File Audit**
   - `.env` vs `.env.example` consistency
   - Ensure `.env.example` contains only empty placeholders
   - Detect accidental values in example files

4. **CI/CD Secrets Hygiene**
   - Detect hardcoded secrets in workflow files
   - Verify secrets are referenced via `${{ secrets.* }}`
   - Flag inline credentials in CI config

5. **Public Readiness Score**
   - Aggregate findings into recommendation:
     - ✅ Safe to be public
     - ⚠️ Review recommended (minor issues)
     - ❌ Do not make public (secrets exposed)

### Out of Scope (stays in audit.security)

- CVE scanning (package vulnerabilities)
- OWASP Top 10 static analysis
- Framework-specific attack vectors

## Files to Create/Modify

| File | Action | Description |
|------|--------|-------------|
| `pro/commands/audit.repo.md` | CREATE | New repository audit command |
| `pro/commands/audit.security.md` | MODIFY | Replace Phase 4 with call to audit.repo |
| `doc/decisions/030-audit-repo-secrets-consolidation.md` | CREATE | ADR documenting the consolidation |

## Implementation Steps

### Step 1: Create audit.repo.md

Structure:
- **Phase 1:** Secrets in History (truffleHog/gitleaks)
- **Phase 2:** Sensitive File Tracking (.gitignore hygiene)
- **Phase 3:** Environment File Audit (.env consistency)
- **Phase 4:** CI/CD Secrets Hygiene
- **Phase 5:** Public Readiness Score (aggregate)
- **Phase 6:** Report Generation (scorecard + details)
- **Phase 7:** Backlog Capture (same pattern as other audits)

### Step 2: Modify audit.security.md

Replace:
```markdown
## Phase 4: Secrets Scanning
[current ~40 lines of secrets scanning logic]
```

With:
```markdown
## Phase 4: Repository Secrets Audit

Execute the repository-level secrets and hygiene audit:

This phase is handled by `/pro:audit.repo`. Run all checks from that command and collect findings.

**Note:** audit.repo provides:
- Secrets in current files AND git history
- .gitignore hygiene analysis
- .env/.env.example consistency
- CI/CD secrets validation
- Public readiness assessment

Collect all findings with their fingerprints for the unified report.
```

### Step 3: Create ADR

Document the consolidation decision in `doc/decisions/030-audit-repo-secrets-consolidation.md`.

## Report Format (audit.repo)

```
Repository Audit: {project-name}
══════════════════════════════════════════════════

  Generated: {ISO 8601 timestamp}
  Branch: {current branch}
  Commit: {short SHA}

  ┌──────────────────────────────────────────────┐
  │                                               │
  │   PUBLIC READINESS: {✅/⚠️/❌} {RECOMMENDATION} │
  │                                               │
  └──────────────────────────────────────────────┘

══════════════════════════════════════════════════

  CHECKS                                   Status
  ──────────────────────────────────────────────

  Secrets in History ..................... {PASS/WARN/FAIL}
    {details or "No secrets found in git history"}

  Sensitive Files ........................ {PASS/WARN/FAIL}
    {.gitignore coverage details}

  Environment Files ...................... {PASS/WARN/FAIL}
    {.env/.env.example consistency details}

  CI/CD Secrets .......................... {PASS/WARN/FAIL}
    {workflow file analysis details}

══════════════════════════════════════════════════

Recommendations:
1. {action item}
2. {action item}
```

## Fingerprint Formats

| Finding Type | Fingerprint Format |
|--------------|-------------------|
| Secret (current) | `{file}:{line}\|secret-{type}` |
| Secret (historical) | `git\|{commit}\|{file}\|secret-{type}` |
| Gitignore gap | `gitignore\|missing-pattern-{pattern}` |
| Env consistency | `.env.example:{line}\|value-not-placeholder` |
| CI inline secret | `{workflow-file}:{line}\|ci-inline-secret` |

## Sensitive Pattern Library

### Secret Detection Patterns

| Type | Pattern | Example |
|------|---------|---------|
| AWS Key | `AKIA[0-9A-Z]{16}` | AKIAIOSFODNN7EXAMPLE |
| GitHub Token | `ghp_[a-zA-Z0-9]{36}` | ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
| Generic API Key | `api[_-]?key.*=.*['"][a-zA-Z0-9]{20,}['"]` | api_key = "abc123..." |
| Private Key | `-----BEGIN (RSA\|DSA\|EC\|OPENSSH) PRIVATE KEY-----` | PEM format |
| Connection String | `(mongodb\|postgres\|mysql)://[^:]+:[^@]+@` | postgres://user:pass@host |
| JWT Secret | `jwt[_-]?secret.*=.*['"].+['"]` | jwt_secret = "..." |
| Generic Password | `password\s*[:=]\s*['"][^'"]+['"]` | password: "secret123" |

### Sensitive File Patterns (for .gitignore validation)

| Category | Patterns |
|----------|----------|
| Environment | `.env`, `.env.*` (except `.env.example`) |
| Keys | `*.pem`, `*.key`, `*.p12`, `*.pfx` |
| Credentials | `credentials.json`, `secrets.*`, `*.secret` |
| Cloud | `.aws/credentials`, `.gcloud/`, `.azure/` |
| SSH | `id_rsa`, `id_dsa`, `id_ecdsa`, `id_ed25519` |

## Graceful Degradation

| Tool | Purpose | Fallback if Missing |
|------|---------|---------------------|
| truffleHog | Git history secrets scan | Skip with warning, suggest `pip install trufflehog` |
| gitleaks | Git history secrets scan | Skip with warning, suggest `brew install gitleaks` |

If neither tool is available:
- Scan current files only (still valuable)
- Report that history scan was skipped
- Provide installation instructions

## Definition of Done

- [x] `audit.repo.md` created with all 7 phases
- [x] `audit.security.md` Phase 4 replaced with audit.repo reference
- [x] ADR-030 created documenting consolidation
- [x] Pattern library covers common secrets
- [x] Graceful degradation for missing tools
- [x] Public Readiness Score calculated correctly
- [x] Fingerprints enable backlog deduplication
- [x] Report format consistent with other audits

## Questions Resolved

1. **Overlap with audit.security?** → Move Phase 4 entirely to audit.repo
2. **Integration into hierarchy?** → audit.security calls audit.repo at Phase 4
3. **Duplicate scanning?** → No, single source of truth in audit.repo

---

## Implementation Complete

**Date:** 2026-01-01

### Files Created

| File | Description |
|------|-------------|
| `pro/commands/audit.repo.md` | New repository health audit command |
| `doc/decisions/030-audit-repo-secrets-consolidation.md` | ADR documenting the consolidation decision |

### Files Modified

| File | Changes |
|------|---------|
| `pro/commands/audit.security.md` | Phase 4 replaced with audit.repo reference |
| `pro/commands/audit.md` | Updated to reflect new hierarchy |
| `.plan/backlog.json` | Added item #45 (in-progress) |

### Next Steps

1. Test `/pro:audit.repo` standalone
2. Test `/pro:audit.security` to verify it calls audit.repo
3. Test `/pro:audit` for full suite execution
4. Create PR when satisfied
