# 020. Audit Command Namespace Hierarchy

Date: 2025-12-29

## Status

Accepted

## Context

The existing `/pro:audit` command (ADR-015) provided completeness checking for requirements, tests, documentation, and basic production readiness including light security checks. Users requested a comprehensive security audit capability covering CVE scanning, OWASP Top 10, secrets in git history, and framework-specific attack vectors.

Two approaches were considered:
1. Extend `/pro:audit` with a `--security` flag
2. Create a separate `/pro:audit.security` command

The choice of approach would establish a pattern for how related commands should be organized in the plugin.

## Decision

Adopt a **namespace hierarchy** for the audit commands:

```
/pro:audit           → Full suite (runs quality + security)
├── /pro:audit.quality   → Completeness checks (tests, docs, requirements)
└── /pro:audit.security  → Deep security analysis (CVE, OWASP, secrets)
```

Key design choices:

1. **Rename existing `/pro:audit` to `/pro:audit.quality`** - The original audit focused on code quality and completeness, so `.quality` accurately describes its scope.

2. **Create `/pro:audit.security`** for comprehensive security scanning:
   - CVE scanning via multiple tools (npm/pip/cargo audit, etc.)
   - OWASP Top 10 static analysis (all 10 categories)
   - Secrets scanning in files AND git history
   - Framework-specific attack vector analysis
   - Security scorecard with pass/fail per category

3. **Create `/pro:audit`** as a meta-command that runs both `.quality` and `.security`, producing a unified report with combined scorecard.

4. **Graceful degradation** - Security tools (truffleHog, gitleaks, pip-audit) may not be installed. The audit runs available tools and reports which scans were skipped.

## Consequences

### Positive

- **Intuitive hierarchy** - Base command runs everything, specific variants for targeted use
- **Establishes namespace pattern** - Future command groups can follow `command.subcommand` convention
- **Flexibility** - Users can run quick quality checks or deep security scans as needed
- **Comprehensive coverage** - Security audit goes far beyond basic checks
- **No tool lock-in** - Graceful degradation allows audits even without all tools installed

### Negative

- **Breaking change** - `/pro:audit` behavior changes (now runs full suite instead of just quality)
- **Increased complexity** - Three commands instead of one
- **Tool dependencies** - Full security scan benefits from optional tools (truffleHog, gitleaks)

### Migration Path

Users expecting the old `/pro:audit` behavior should use `/pro:audit.quality`. The base `/pro:audit` now provides more comprehensive coverage by default.

## Alternatives Considered

### 1. Flag-based approach (`/pro:audit --security`)

**Rejected because:**
- Flags add complexity to invocation
- Harder to document and discover
- Mixed responsibilities in single command file

### 2. Keep separate without namespace (`/pro:security-audit`)

**Rejected because:**
- Doesn't establish pattern for related commands
- Less discoverable as a related capability
- Misses opportunity for combined meta-command

## Related

- ADR-015: Audit, Backlog, and Roadmap Command Architecture
- Planning: `.plan/.done/feat-audit-security-command/`
