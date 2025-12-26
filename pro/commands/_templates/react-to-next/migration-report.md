# Migration Report Template

> This template defines the output structure for the final migration documentation.

---

## Report Structure

### Header

```markdown
# React to Next.js Migration Report

Generated: {ISO 8601 timestamp}
Project: {project name}
Migration Branch: {branch name}
Router: {App Router / Pages Router}

---
```

### 1. Migration Summary

```markdown
## Migration Summary

| Metric | Count |
|--------|-------|
| Files Created | {count} |
| Files Modified | {count} |
| Files Deleted | {count} |
| Routes Migrated | {count} |
| Components Updated | {count} |

### Execution Time
- Preflight: {duration}
- Scaffold: {duration}
- Migration: {duration}
- Validation: {duration}
- **Total:** {total duration}
```

### 2. Route Mapping

```markdown
## Route Mapping

### Explicit Routes

| Original Path | Next.js Path | File | Notes |
|---------------|--------------|------|-------|
| `/` | `/` | `app/page.tsx` | - |
| `/users/:id` | `/users/[id]` | `app/users/[id]/page.tsx` | Dynamic segment |
| `/dashboard/*` | `/dashboard/[...slug]` | `app/dashboard/[...slug]/page.tsx` | Catch-all |

### Catch-All Safety Route

| Path | File | Purpose |
|------|------|---------|
| `[[...slug]]` | `app/[[...slug]]/page.tsx` | Fallback for unmapped routes |

### Route Safety Verification
- **All original routes covered:** Yes/No
- **Deep link safety:** Verified
- **Direct URL access:** Verified
```

### 3. File Changes

```markdown
## File Changes

### Created Files

| File | Purpose |
|------|---------|
| `next.config.js` | Next.js configuration |
| `app/layout.tsx` | Root layout |
| `app/page.tsx` | Home page |
| `app/globals.css` | Global styles |

### Modified Files

| File | Changes |
|------|---------|
| `package.json` | Added Next.js deps, updated scripts |
| `tsconfig.json` | Updated for Next.js |

### Deleted Files

| File | Reason |
|------|--------|
| `src/index.tsx` | Replaced by Next.js entry point |
| `public/index.html` | Replaced by Next.js document |
```

### 4. Environment Variables

```markdown
## Environment Variables

### Renamed Variables

| Original | New | File Updates |
|----------|-----|--------------|
| `REACT_APP_API_URL` | `NEXT_PUBLIC_API_URL` | 5 files |
| `REACT_APP_GA_ID` | `NEXT_PUBLIC_GA_ID` | 2 files |

### .env.example Updated
Location: `.env.example`

### Action Required
Update your `.env.local` file with the renamed variables.
```

### 5. Client Boundary Additions

```markdown
## Client Boundaries

### Files with 'use client' Directive

| File | Reason |
|------|--------|
| `app/components/Counter.tsx` | Uses useState |
| `app/components/Modal.tsx` | Uses useEffect, window |
| `app/providers.tsx` | Context providers |

### Total Client Components: {count}
### Total Server Components: {count}
```

### 6. Dependency Changes

```markdown
## Dependency Changes

### Added

| Package | Version | Purpose |
|---------|---------|---------|
| `next` | `^14.x` | Framework |
| `eslint-config-next` | `^14.x` | Linting |

### Removed

| Package | Reason |
|---------|--------|
| `react-router-dom` | Replaced by Next.js routing |
| `react-scripts` | CRA build tool |

### Unchanged
All other dependencies preserved.
```

### 7. Configuration Changes

```markdown
## Configuration

### next.config.js

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration details
}

module.exports = nextConfig
```

### Notable Settings
- {Any important configuration decisions}
```

### 8. Known Issues

```markdown
## Known Issues

### Requires Manual Review

| Issue | Location | Recommendation |
|-------|----------|----------------|
| Complex animation library | `components/Animated.tsx` | Test SSR behavior |
| Direct DOM manipulation | `utils/scroll.ts` | Verify in browser |

### Potential Breaking Changes
{List any changes that might affect functionality}

### Not Migrated
{List any patterns that were intentionally not migrated}
```

### 9. Validation Results

```markdown
## Validation Results

### Build Status
```
{build output or summary}
```

### TypeScript Errors: {count}
### ESLint Warnings: {count}
### Hydration Warnings: {potential count if any detected}
```

### 10. Next Steps

```markdown
## Next Steps

### Immediate Actions
1. Review the changes: `git diff main`
2. Update `.env.local` with renamed environment variables
3. Install dependencies: `npm install`
4. Run development server: `npm run dev`
5. Test all routes manually

### Recommended Testing
- [ ] Verify all routes load correctly
- [ ] Test navigation between pages
- [ ] Check deep links work
- [ ] Verify forms and interactions
- [ ] Test on mobile viewport

### Deployment Considerations
- Update CI/CD for Next.js build commands
- Configure hosting for Next.js (Vercel, Netlify, etc.)
- Update environment variables in deployment platform

### Documentation Updates
- Update README with new scripts
- Document any manual configuration needed
```

### 11. Rollback Instructions

```markdown
## Rollback

If issues are encountered:

```bash
# Discard all changes and return to main
git checkout main
git branch -D {migration-branch}
```

Or to keep the branch for reference:

```bash
git checkout main
```
```
