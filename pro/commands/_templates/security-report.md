# Security Report Template

> This template is used by `/pro:audit.security` to generate comprehensive security audit reports.

---

## Report Structure

### 1. Executive Summary (Scorecard)

```
═══════════════════════════════════════════════════════════════════════════════
  SECURITY AUDIT REPORT                                        {project-name}
═══════════════════════════════════════════════════════════════════════════════

  Generated: {ISO 8601 timestamp}
  Branch: {current branch}
  Commit: {short SHA}

  ┌─────────────────────────────────────────────────────────────────────────┐
  │                                                                          │
  │   SECURITY SCORE: {score}/100                         {rating}           │
  │                                                                          │
  └─────────────────────────────────────────────────────────────────────────┘

  Rating thresholds: 90+ EXCELLENT | 75-89 GOOD | 50-74 NEEDS WORK | 25-49 POOR | <25 CRITICAL

═══════════════════════════════════════════════════════════════════════════════
```

### 2. Category Breakdown

```
  CATEGORY SCORES
  ───────────────────────────────────────────────────────────────────────────

  Category                              Score      Status       Findings
  ─────────────────────────────────────────────────────────────────────────
  Dependency CVEs                       {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A01 - Broken Access Control     {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A02 - Cryptographic Failures    {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A03 - Injection                 {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A04 - Insecure Design           {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A05 - Security Misconfiguration {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A07 - Auth Failures             {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A08 - Integrity Failures        {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A09 - Logging Failures          {xx}/100   {PASS/WARN/FAIL}   {n}
  OWASP A10 - SSRF                      {xx}/100   {PASS/WARN/FAIL}   {n}
  Secrets (Current Files)               {xx}/100   {PASS/WARN/FAIL}   {n}
  Secrets (Git History)                 {xx}/100   {PASS/WARN/FAIL}   {n}
  Framework: {name}                     {xx}/100   {PASS/WARN/FAIL}   {n}

  Status legend: PASS (80+) | WARN (50-79) | FAIL (<50)
```

### 3. Findings Summary

```
  FINDINGS SUMMARY
  ───────────────────────────────────────────────────────────────────────────

  Total: {n} findings

  By Severity:
  ├─ Critical: {n}  ████████░░░░░░░░  {%}
  ├─ High:     {n}  ██████░░░░░░░░░░  {%}
  ├─ Medium:   {n}  ████░░░░░░░░░░░░  {%}
  └─ Low:      {n}  ██░░░░░░░░░░░░░░  {%}

  By Category:
  ├─ CVE:      {n}
  ├─ OWASP:    {n}
  ├─ Secrets:  {n}
  └─ Framework:{n}
```

### 4. Project Profile

```
  PROJECT PROFILE
  ───────────────────────────────────────────────────────────────────────────

  Package Managers Detected:
  ├─ {package-manager}: {lock-file}

  Frameworks Detected:
  ├─ {framework}: {detection-file}

  Infrastructure Detected:
  ├─ {type}: {file}

  Scans Completed: {n}/{total}
  Scans Skipped:
  ├─ {tool}: {reason - e.g., "not installed"}
```

---

## Detailed Findings

### Critical Findings ({n})

#### [{category}] {title}

| Field | Value |
|-------|-------|
| **Severity** | Critical |
| **Category** | {category} |
| **File** | {file:line} |
| **CVE/CWE** | {id if applicable} |
| **CVSS** | {score if applicable} |

**Description:**
{description}

**Evidence:**
```
{code snippet or evidence}
```

**Remediation:**
{how to fix}

**Fingerprint:** `{fingerprint}`

---

### High Findings ({n})

{same format as critical}

---

### Medium Findings ({n})

{same format as critical}

---

### Low Findings ({n})

{same format as critical}

---

## Recommendations

### Immediate Actions (Critical/High)

1. {action item}
2. {action item}

### Short-Term Improvements (Medium)

1. {action item}
2. {action item}

### Long-Term Hardening (Low/Best Practice)

1. {action item}
2. {action item}

---

## Appendix

### A. Tools Used

| Tool | Version | Scans | Status |
|------|---------|-------|--------|
| npm audit | {version} | CVE | Completed |
| trufflehog | {version} | Git secrets | Completed |
| {tool} | N/A | {type} | Skipped (not installed) |

### B. OWASP Top 10 Reference

| ID | Name | CWE Examples |
|----|------|-------------|
| A01 | Broken Access Control | CWE-200, CWE-284, CWE-285 |
| A02 | Cryptographic Failures | CWE-259, CWE-327, CWE-331 |
| A03 | Injection | CWE-79, CWE-89, CWE-78 |
| A04 | Insecure Design | CWE-209, CWE-256, CWE-501 |
| A05 | Security Misconfiguration | CWE-16, CWE-611, CWE-1004 |
| A06 | Vulnerable Components | (See CVE findings) |
| A07 | Auth Failures | CWE-287, CWE-384, CWE-613 |
| A08 | Integrity Failures | CWE-502, CWE-829, CWE-915 |
| A09 | Logging Failures | CWE-117, CWE-223, CWE-532 |
| A10 | SSRF | CWE-918 |

### C. Severity Definitions

| Severity | Impact | Exploitability | Response Time |
|----------|--------|---------------|---------------|
| Critical | System compromise, data breach | Easy, automated | Immediate (< 24h) |
| High | Significant data exposure | Moderate skill | Urgent (< 1 week) |
| Medium | Limited data/function access | Complex attack | Planned (< 1 month) |
| Low | Minimal impact, hardening | Requires insider | Backlog |

### D. Score Calculation

```
Category Score = max(0, 100 - (critical * 30 + high * 15 + medium * 5 + low * 2))

Category Weights:
- CVE Scanning: 25%
- OWASP A01-A03: 35% (split evenly ~11.67% each)
- OWASP A04-A10: 25% (split evenly ~3.57% each)
- Secrets: 15%

Overall Score = sum(category_score * weight)
```

---

## Report Footer

```
───────────────────────────────────────────────────────────────────────────────
Report generated: {ISO 8601 timestamp}
Git commit: {full SHA}
Generator: Claude Code /pro:audit.security
───────────────────────────────────────────────────────────────────────────────
```
