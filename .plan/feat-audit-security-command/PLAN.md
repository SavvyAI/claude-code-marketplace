# /pro:audit.security - Comprehensive Security Audit Command

## Overview

A standalone security audit command that provides deep security analysis far beyond what `/pro:audit.quality` offers. Generates compliance-style reports with scores and detailed findings.

## Requirements

### Agreed Design Decisions

| Decision | Choice |
|----------|--------|
| Architecture | Standalone `/pro:audit.security` command |
| CVE Scanning | Multiple tools (npm audit, pip-audit, cargo audit, etc.) - merge results |
| OWASP Scope | All 10 categories (A01-A10) |
| Attack Vectors | Generic + framework-specific with severity weighting |
| Report Style | Both formats (detailed findings + summary scorecard with scores) |
| Secrets Scope | Current files + git history (truffleHog/gitleaks) |
| Tool Dependencies | Graceful degradation - run available, note skipped scans |

### Comparison with /pro:audit.quality

| Aspect | /pro:audit.quality | /pro:audit.security |
|--------|-----------|---------------------|
| Security checks | Basic (hardcoded secrets, input validation) | Comprehensive (CVE, OWASP, secrets history) |
| CVE scanning | None | Multi-tool (npm/pip/cargo audit) |
| OWASP coverage | None | All 10 categories |
| Secrets in git | No | Yes (truffleHog/gitleaks) |
| Framework analysis | No | Yes (with severity weighting) |
| Report format | Findings list | Scorecard + detailed findings |
| Tool requirements | None | Graceful degradation |

## Security Scan Categories

### 1. Dependency CVE Scanning

Run all available package manager audit tools and merge results:

| Tool | Ecosystem | Detection |
|------|-----------|-----------|
| `npm audit` | Node.js | package-lock.json |
| `yarn audit` | Node.js | yarn.lock |
| `pnpm audit` | Node.js | pnpm-lock.yaml |
| `pip-audit` | Python | requirements.txt, Pipfile, pyproject.toml |
| `cargo audit` | Rust | Cargo.lock |
| `bundle audit` | Ruby | Gemfile.lock |
| `composer audit` | PHP | composer.lock |
| `go vuln` | Go | go.mod |

### 2. OWASP Top 10 (2021) Static Analysis

| ID | Category | Static Analysis Approach |
|----|----------|-------------------------|
| A01 | Broken Access Control | Auth decorators, route protection, RBAC patterns |
| A02 | Cryptographic Failures | Weak algorithms, hardcoded keys, insecure defaults |
| A03 | Injection | SQL, NoSQL, command, LDAP, XPath injection patterns |
| A04 | Insecure Design | Missing rate limiting, no input validation architecture |
| A05 | Security Misconfiguration | Debug mode, default credentials, exposed endpoints |
| A06 | Vulnerable Components | Covered by CVE scanning |
| A07 | Auth Failures | Weak passwords, session issues, MFA gaps |
| A08 | Software/Data Integrity | Unsigned updates, insecure deserialization |
| A09 | Logging Failures | Missing audit logs, sensitive data in logs |
| A10 | SSRF | Unvalidated URLs, internal service access |

### 3. Secrets Scanning

**Current Files:**
- API keys, passwords, tokens in code
- Environment files committed
- Private keys, certificates
- Connection strings with credentials

**Git History:**
- Use truffleHog or gitleaks to scan all commits
- Flag secrets that were committed then removed
- Report commit SHA and author for remediation

### 4. Framework-Specific Attack Vectors

Detect frameworks and check for known vulnerability patterns:

| Framework | Attack Vectors |
|-----------|----------------|
| Next.js | getServerSideProps data exposure, API routes without auth, middleware bypass |
| Express | Missing helmet, no rate limiting, CORS misconfiguration |
| Django | DEBUG=True, SECRET_KEY exposure, CSRF bypass |
| Rails | Mass assignment, SQL injection, CSRF token leaks |
| React | XSS via dangerouslySetInnerHTML, exposed API keys in bundle |
| Vue | v-html XSS, template injection |
| Spring | Actuator exposure, SpEL injection |
| FastAPI | Missing auth dependency, Pydantic validation bypass |

### 5. Infrastructure Security (if detectable)

- Dockerfile security (running as root, secrets in layers)
- Kubernetes manifests (privileged containers, missing network policies)
- Terraform/CloudFormation (public S3, open security groups)
- CI/CD configs (secrets in plain text, missing branch protection)

## Report Format

### Executive Summary (Scorecard)

```
═══════════════════════════════════════════════════════════════
  SECURITY AUDIT                               project-name
═══════════════════════════════════════════════════════════════

  SECURITY SCORE: 72/100                        ⚠ NEEDS WORK

  ┌─────────────────────────────────────────────────────────┐
  │ Category                    Score    Status             │
  ├─────────────────────────────────────────────────────────┤
  │ Dependency CVEs             85/100   ✓ PASS             │
  │ OWASP A01 - Access Control  60/100   ⚠ WARN             │
  │ OWASP A02 - Crypto          90/100   ✓ PASS             │
  │ OWASP A03 - Injection       45/100   ✗ FAIL             │
  │ Secrets                     70/100   ⚠ WARN             │
  │ Framework (Next.js)         80/100   ✓ PASS             │
  └─────────────────────────────────────────────────────────┘

  FINDINGS: 23 total
  ├─ Critical: 2
  ├─ High: 5
  ├─ Medium: 8
  └─ Low: 8

  SCANS COMPLETED: 6/8 (npm audit, pip-audit skipped - not installed)

═══════════════════════════════════════════════════════════════
```

### Detailed Findings

```markdown
## Findings

### Critical (2)

#### [CVE-2024-XXXXX] Remote Code Execution in lodash
- **Severity:** Critical (CVSS 9.8)
- **Package:** lodash@4.17.20
- **Fix:** Upgrade to lodash@4.17.21
- **Fingerprint:** cve|lodash|4.17.20|CVE-2024-XXXXX

#### [A03] SQL Injection in user query
- **Severity:** Critical
- **File:** src/db/users.ts:45
- **Code:** `db.query(\`SELECT * FROM users WHERE id = ${userId}\`)`
- **Fix:** Use parameterized queries
- **Fingerprint:** src/db/users.ts:45-45|sql-injection

### High (5)
...
```

## Implementation Steps

### Phase 1: Command Structure
1. Create `pro/commands/audit.security.md` with frontmatter
2. Define allowed tools: Bash, Read, Glob, Grep, Write, WebFetch, AskUserQuestion
3. Set up report template structure

### Phase 2: Project Detection
1. Detect package managers (package.json, requirements.txt, Cargo.toml, etc.)
2. Detect frameworks (Next.js, Express, Django, etc.)
3. Detect infrastructure files (Dockerfile, k8s, terraform)
4. Build project profile for targeted scanning

### Phase 3: CVE Scanning Layer
1. Check which audit tools are available
2. Run each available tool, capture JSON output
3. Normalize findings to common schema
4. Deduplicate across tools
5. Map to severity levels

### Phase 4: OWASP Static Analysis
1. Implement pattern matching for each category
2. A01: Check auth middleware, route decorators, RBAC
3. A02: Scan for weak crypto, hardcoded keys
4. A03: SQL/NoSQL/command injection patterns
5. A04: Rate limiting, validation architecture
6. A05: Debug flags, default creds, exposed endpoints
7. A07: Password handling, session management
8. A08: Deserialization, update verification
9. A09: Logging patterns, sensitive data exposure
10. A10: URL validation, SSRF patterns

### Phase 5: Secrets Scanning
1. Scan current files for secrets patterns
2. Check if truffleHog/gitleaks available
3. If available, scan git history
4. Deduplicate findings
5. Flag historical vs current exposure

### Phase 6: Framework Analysis
1. For each detected framework, run targeted checks
2. Weight findings based on framework context
3. Framework-specific remediation guidance

### Phase 7: Report Generation
1. Calculate scores per category
2. Calculate overall security score
3. Generate executive summary
4. Generate detailed findings
5. Save to temp file
6. Offer backlog capture (reuse /pro:audit.quality pattern)

### Phase 8: Backlog Integration
1. Fingerprint each finding
2. Check against existing backlog items
3. Multi-select for capture
4. Use category mapping from ADR-015

## Scoring Algorithm

```
Category Score = 100 - (critical_count * 25 + high_count * 15 + medium_count * 5 + low_count * 2)
Min score per category: 0

Overall Score = weighted_average(category_scores)
Weights:
- CVE: 20%
- OWASP A01-A03 (critical): 15% each = 45%
- OWASP A04-A10: 5% each = 35%
```

## Files to Create/Modify

| File | Action |
|------|--------|
| `pro/commands/audit.security.md` | CREATE - main command |
| `pro/commands/_templates/security-report.md` | CREATE - report template |
| `pro/readme.md` | UPDATE - add command to list |
| `.plan/feat-audit-security-command/PLAN.md` | CREATE - this file |

## Definition of Done

- [ ] Command file created with proper frontmatter
- [ ] Project detection working (package managers, frameworks)
- [ ] CVE scanning with graceful degradation
- [ ] OWASP Top 10 static analysis patterns
- [ ] Secrets scanning (files + git history)
- [ ] Framework-specific attack vector checks
- [ ] Scorecard generation
- [ ] Detailed findings report
- [ ] Backlog integration with fingerprinting
- [ ] README updated
- [ ] Manual testing on sample projects
