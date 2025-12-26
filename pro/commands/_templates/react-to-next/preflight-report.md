# Preflight Report Template

> This template defines the output structure for the preflight analysis phase.

---

## Report Structure

### Header

```markdown
# React to Next.js Migration - Preflight Report

Generated: {ISO 8601 timestamp}
Project: {project name from package.json}
Source Path: {absolute path}

---
```

### 1. Project Summary

```markdown
## Project Summary

| Property | Value |
|----------|-------|
| Name | {name} |
| Version | {version} |
| React Version | {react version} |
| TypeScript | Yes/No |
| Package Manager | npm/yarn/pnpm |
| Build Tool | Vite/CRA/Webpack/Parcel/Other |
```

### 2. Routing Analysis

```markdown
## Routing Analysis

### Detected Router
{React Router v6 / React Router v5 / Custom / None detected}

### Route Definitions

| Path | Component | Dynamic Segments | Notes |
|------|-----------|------------------|-------|
| `/` | Home | - | - |
| `/users/:id` | UserProfile | `id` | - |
| `/dashboard/*` | Dashboard | catch-all | Nested routes |

### Route Safety Assessment

- **Total routes detected:** {count}
- **Dynamic routes:** {count}
- **Catch-all routes:** {count}
- **Confidence level:** High/Medium/Low

{If Low confidence, explain why and what manual verification is needed}
```

### 3. Styling Analysis

```markdown
## Styling Analysis

### Detected Approaches

| Approach | Files | Notes |
|----------|-------|-------|
| CSS Modules | 15 | Native Next.js support |
| styled-components | 8 | Requires SSR configuration |
| Tailwind CSS | - | Detected in config |
| Plain CSS | 3 | Will be migrated to app/globals.css |

### Migration Impact
{Assessment of styling migration complexity}
```

### 4. Data Fetching Analysis

```markdown
## Data Fetching Analysis

### Detected Patterns

| Pattern | Occurrences | Migration Path |
|---------|-------------|----------------|
| useEffect + fetch | 12 | Keep as client-side or convert to RSC |
| React Query | 8 | Keep as client-side |
| SWR | 0 | - |
| Redux async | 3 | Keep as client-side |

### API Base URL Detection
- Environment variable: `REACT_APP_API_URL`
- Rename to: `NEXT_PUBLIC_API_URL`
```

### 5. Environment Variables

```markdown
## Environment Variables

### Detected Variables

| Original | Next.js Equivalent | Exposure |
|----------|-------------------|----------|
| `REACT_APP_API_URL` | `NEXT_PUBLIC_API_URL` | Client |
| `REACT_APP_GA_ID` | `NEXT_PUBLIC_GA_ID` | Client |
| `API_SECRET` | `API_SECRET` | Server only |

### Notes
- Variables prefixed with `REACT_APP_` will be renamed to `NEXT_PUBLIC_`
- Server-only variables remain unchanged
```

### 6. Browser API Usage

```markdown
## Browser API Usage

### Detected Usage

| API | Files | Risk Level | Mitigation |
|-----|-------|------------|------------|
| `window.location` | 5 | Medium | Wrap in useEffect or dynamic import |
| `localStorage` | 3 | Low | Already guarded |
| `document.querySelector` | 2 | High | Requires 'use client' |

### SSR Safety Assessment
{Assessment of SSR compatibility}
```

### 7. Third-Party Dependencies

```markdown
## Third-Party Dependencies

### Migration Compatibility

| Package | Version | Next.js Compatible | Notes |
|---------|---------|-------------------|-------|
| react-router-dom | 6.x | N/A | Will be replaced |
| @tanstack/react-query | 5.x | Yes | No changes needed |
| styled-components | 6.x | Yes | Needs SSR config |
| some-client-lib | 1.x | Partial | Requires 'use client' |

### Packages to Remove
- `react-router-dom` (replaced by Next.js routing)
- `react-scripts` (if CRA)
```

### 8. Risk Assessment

```markdown
## Risk Assessment

### Overall Risk Level: Low/Medium/High

### Risk Factors

| Risk | Severity | Mitigation |
|------|----------|------------|
| Complex nested routing | Medium | Manual verification recommended |
| Heavy browser API usage | Low | Will add 'use client' directives |
| No risks detected | - | - |

### Blocking Issues
{List any issues that would prevent migration, or "None detected"}
```

### 9. Recommendations

```markdown
## Recommendations

### Router Choice

**Recommended:** App Router

**Rationale:**
- Modern Next.js architecture
- Detected patterns are compatible
- No blocking incompatibilities

{OR if Pages Router recommended}

**Recommended:** Pages Router (Fallback)

**Rationale:**
- {Specific reason for fallback}
- Simpler migration path for this codebase

### Pre-Migration Actions
1. {Any manual steps needed before proceeding}
2. {e.g., "Update react-router-dom to v6"}

### Post-Migration Actions
1. {Any manual steps needed after migration}
2. {e.g., "Review SEO metadata configuration"}
```

### 10. Confirmation Prompt

```markdown
## Ready to Proceed?

Based on this analysis:
- **{count} routes** will be migrated
- **{count} files** will be modified
- **Router:** {App Router / Pages Router}
- **Estimated changes:** {Low/Medium/High complexity}

Proceed with migration?
```
