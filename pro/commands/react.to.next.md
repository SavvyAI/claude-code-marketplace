---
description: "Migrate React SPA to Next.js → Deterministic pipeline with route safety → Creates working Next.js app"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion", "WebFetch"]
---

# React to Next.js Migration

A deterministic, auditable migration pipeline that converts client-rendered React applications into Next.js applications with **functional parity** and **guaranteed route safety**.

## Core Guarantees

1. **No valid URL may return 404 after migration** (route safety)
2. **Functional parity** prioritized over framework ideology
3. **All changes are observable** and documented
4. **Deterministic output** - same input produces equivalent results

---

## Pre-Execution Checks

### Verify Project Type

```bash
test -f package.json && echo "exists" || echo "missing"
```

If missing: **ABORT** - "No package.json found. This command must be run in a Node.js project root."

### Verify React Dependency

```bash
grep -q '"react"' package.json && echo "react-found" || echo "not-react"
```

If not found: **ABORT** - "This does not appear to be a React project. React dependency not found in package.json."

### Check for Existing Next.js

```bash
grep -q '"next"' package.json && echo "next-found" || echo "no-next"
```

If found: Use `AskUserQuestion` - "Next.js is already installed. This appears to be an existing Next.js project. Do you want to continue anyway?"

---

## Phase 1: Preflight Analysis

> Purpose: Detect patterns, assess risks, and make recommendations before any changes.

Read the preflight report template from `_templates/react-to-next/preflight-report.md`.

### 1.1 Project Summary Detection

Gather from package.json:
- Project name and version
- React version
- TypeScript detection (`typescript` in dependencies or `tsconfig.json` exists)
- Package manager detection (yarn.lock, pnpm-lock.yaml, package-lock.json)
- Build tool detection (vite.config, react-scripts, webpack.config)

### 1.2 Routing Analysis

**React Router Detection:**

```bash
grep -r "react-router" package.json
grep -r "createBrowserRouter\|createHashRouter\|BrowserRouter\|HashRouter" src/ --include="*.tsx" --include="*.jsx" --include="*.ts" --include="*.js" 2>/dev/null | head -20
```

**Route Definition Extraction:**

Search for route patterns:
```bash
grep -r "<Route\|path=\|element=\|component=" src/ --include="*.tsx" --include="*.jsx" -A2 -B2 2>/dev/null | head -50
```

Search for route configuration objects:
```bash
grep -r "path:\|element:\|children:" src/ --include="*.tsx" --include="*.jsx" -A2 -B2 2>/dev/null | head -50
```

**Build Route Manifest:**
- Parse detected routes into a structured list
- Identify dynamic segments (`:param` patterns)
- Identify catch-all routes (`*` patterns)
- Identify nested route structures

**Route Safety Assessment:**
- Count total routes
- Assess confidence level (High/Medium/Low)
- If Low confidence: flag for manual verification prompt

### 1.3 Styling Analysis

Detect styling approaches:
```bash
# CSS Modules
find src -name "*.module.css" -o -name "*.module.scss" 2>/dev/null | wc -l

# styled-components
grep -r "styled-components\|@emotion" package.json

# Tailwind
test -f tailwind.config.js && echo "tailwind"
grep -r "tailwindcss" package.json

# Plain CSS imports
grep -r "import.*\.css" src/ --include="*.tsx" --include="*.jsx" 2>/dev/null | wc -l
```

### 1.4 Data Fetching Analysis

Detect patterns:
```bash
# React Query / TanStack Query
grep -r "@tanstack/react-query\|react-query" package.json

# SWR
grep -r '"swr"' package.json

# useEffect + fetch patterns
grep -r "useEffect.*fetch\|fetch.*useEffect" src/ --include="*.tsx" --include="*.jsx" 2>/dev/null | wc -l

# Axios
grep -r '"axios"' package.json
```

### 1.5 Environment Variable Detection

```bash
# Find REACT_APP_ variables
grep -r "REACT_APP_" src/ --include="*.tsx" --include="*.jsx" --include="*.ts" --include="*.js" 2>/dev/null | grep -o "REACT_APP_[A-Z_]*" | sort -u

# Check for .env files
ls -la .env* 2>/dev/null
```

### 1.6 Browser API Usage Detection

```bash
# window usage
grep -r "\bwindow\." src/ --include="*.tsx" --include="*.jsx" --include="*.ts" --include="*.js" 2>/dev/null | wc -l

# document usage
grep -r "\bdocument\." src/ --include="*.tsx" --include="*.jsx" --include="*.ts" --include="*.js" 2>/dev/null | wc -l

# localStorage/sessionStorage
grep -r "localStorage\|sessionStorage" src/ --include="*.tsx" --include="*.jsx" --include="*.ts" --include="*.js" 2>/dev/null | wc -l
```

### 1.7 Generate Preflight Report

Using the template structure, generate a comprehensive report and display to user.

### 1.8 Router Recommendation

**Default: App Router** unless any of these are detected:
- Hash router usage (`HashRouter`, `createHashRouter`)
- Complex imperative navigation patterns
- Heavy reliance on router state not available in App Router
- User explicitly requests Pages Router

If Pages Router fallback is recommended, explain why.

### 1.9 User Confirmation

Use `AskUserQuestion`:
- Show route count and complexity assessment
- Confirm router choice (App Router / Pages Router)
- Confirm proceeding with migration

If user declines: **ABORT** gracefully with no changes made.

---

## Phase 2: Branch Creation

### 2.1 Create Migration Branch

```bash
git checkout -b feat/react-to-next-migration
```

Report: `[PASS] Created branch: feat/react-to-next-migration`

---

## Phase 3: Scaffold Next.js

### 3.1 Install Dependencies

```bash
npm install next@latest
npm install -D eslint-config-next@latest
```

If TypeScript detected:
```bash
npm install -D @types/node
```

### 3.2 Create next.config.js

Write `next.config.js`:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Preserve trailing slashes if detected in original routing
  // trailingSlash: true,

  // Disable strict mode only if original app had issues with it
  // reactStrictMode: false,
}

module.exports = nextConfig
```

### 3.3 Create Directory Structure

**For App Router:**
```bash
mkdir -p app
```

**For Pages Router (fallback):**
```bash
mkdir -p pages
```

### 3.4 Update tsconfig.json (if TypeScript)

Read existing `tsconfig.json` and update for Next.js compatibility:
- Add `"jsx": "preserve"` if not present
- Add Next.js paths if needed
- Preserve existing configuration where possible

### 3.5 Update package.json Scripts

Read current `package.json` and merge/add these scripts:

```json
{
  "scripts": {
    "predev": "rm -f .next/dev/lock",
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "prebuild": "npm run lint || true",
    "verify": "next build && next lint || true",
    "clean": "rm -rf .next node_modules/.cache",
    "dev:clean": "npm run clean && npm run dev"
  }
}
```

**Platform Note:** These scripts use Unix shell commands. For Windows support, consider:
- Install `rimraf` for cross-platform `rm -rf`
- Use `shx` package for shell command portability
- Or document that scripts are macOS/Linux-only

Preserve existing scripts that don't conflict (e.g., `test`, custom scripts).

Report: `[PASS] Next.js scaffold created`

---

## Phase 4: Migration

### 4.1 Create Root Layout (App Router)

Write `app/layout.tsx`:

```tsx
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: '{project name}',
  description: '{from package.json description or generic}',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
```

### 4.2 Create Global Styles

If global CSS detected, create `app/globals.css`:
- Copy content from detected global CSS file
- Or create minimal reset if none found

### 4.3 Migrate Routes

For each route detected in preflight:

**Example: `/` → `app/page.tsx`**
**Example: `/users/:id` → `app/users/[id]/page.tsx`**
**Example: `/dashboard/*` → `app/dashboard/[...slug]/page.tsx`**

For each migrated route:
1. Create directory structure
2. Create `page.tsx` with component
3. Add `'use client'` directive if component uses:
   - useState, useEffect, useContext
   - Browser APIs
   - Event handlers
4. Update imports to new paths

### 4.4 Create Catch-All Safety Route

**Critical for route safety guarantee.**

The catch-all route ensures no valid URL returns 404. Next.js route precedence means:
1. Explicit routes (migrated pages) are matched first
2. Only unmatched routes reach the catch-all
3. API routes (`/api/*`) are excluded by directory structure

Write `app/[[...slug]]/page.tsx`:

```tsx
'use client'

import { usePathname } from 'next/navigation'
import { useEffect, useState } from 'react'
// Import your migrated React app entry point
// import App from '@/components/App'

/**
 * Catch-all route for URL safety.
 *
 * Routes handled by explicit Next.js pages will NOT reach this component
 * due to Next.js routing priority. This only catches unmapped routes.
 */
export default function CatchAllPage() {
  const pathname = usePathname()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return null // Prevent hydration mismatch
  }

  // OPTION A: Render original React app shell (SPA fallback)
  // return <App />

  // OPTION B: Explicit 404 for fail-loud migration
  // return <NotFound />

  // OPTION C: Placeholder showing unmigrated route (default)
  return (
    <div>
      <p>Route not explicitly migrated: {pathname}</p>
      <p>Add an explicit Next.js route for this path.</p>
    </div>
  )
}
```

**Implementation Choices:**

| Approach | When to Use | Trade-offs |
|----------|-------------|------------|
| **SPA Fallback** | Partially migrated, client-heavy apps | SSR benefits lost for unmigrated routes |
| **Fail-Loud 404** | Fully migrated, want to catch missed routes | Breaks if routes were missed |
| **Placeholder** | During migration, identifies gaps | Not production-ready |

**Recommendation:** Start with placeholder during migration, switch to SPA fallback for production if any routes remain unmigrated.

### 4.5 Migrate Components

For each component file:
1. Check for browser API usage
2. Add `'use client'` directive if needed
3. Update import paths
4. Preserve component logic unchanged

### 4.6 Environment Variable Rename

For each `REACT_APP_*` variable detected:
1. Find all usages in source files
2. Rename to `NEXT_PUBLIC_*`
3. Update `.env.example` if exists

```bash
# Example sed command (run carefully)
find src app -type f \( -name "*.tsx" -o -name "*.ts" -o -name "*.jsx" -o -name "*.js" \) -exec sed -i '' 's/REACT_APP_/NEXT_PUBLIC_/g' {} \;
```

### 4.7 Remove React Router

1. Update components to use Next.js navigation:

| React Router | Next.js Equivalent | Import |
|--------------|-------------------|--------|
| `useNavigate()` | `useRouter()` | `next/navigation` |
| `<Link to="">` | `<Link href="">` | `next/link` |
| `useParams()` | `useParams()` | `next/navigation` |
| `useLocation().pathname` | `usePathname()` | `next/navigation` |
| `useLocation().search` | `useSearchParams()` | `next/navigation` |
| `useLocation().state` | **No direct equivalent** | Use URL params or Context |
| `<Navigate to="">` | `redirect()` or `useRouter().push()` | `next/navigation` |
| `<Outlet />` | `{children}` in layouts | N/A |

**Preflight Detection:** Scan for `useLocation().state` usage and flag for manual review.

2. Remove react-router-dom from dependencies

### 4.8 Handle Provider Wrappers

If the app uses context providers:

Write `app/providers.tsx`:

```tsx
'use client'

// Import your providers
// import { ThemeProvider } from './contexts/theme'
// import { AuthProvider } from './contexts/auth'

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    // <ThemeProvider>
    //   <AuthProvider>
        {children}
    //   </AuthProvider>
    // </ThemeProvider>
  )
}
```

Update `app/layout.tsx` to wrap with Providers.

Report: `[PASS] Migration complete - {count} routes migrated`

---

## Phase 5: Normalization

### 5.1 Add Client Directives

For each file with browser API or React hooks usage:
- Add `'use client'` at top of file
- Verify no server-only imports in client components

### 5.2 Handle Dynamic Imports

For components with heavy browser dependencies:

```tsx
import dynamic from 'next/dynamic'

const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  ssr: false,
})
```

### 5.3 Update Asset References

If assets need migration:
- Move from `src/assets/` to `public/`
- Update import references to use absolute paths

Report: `[PASS] Normalization complete`

---

## Phase 6: Validation

### 6.1 Run Build

```bash
npm run build 2>&1
```

Capture output. If errors:
- Report each error with file and line
- Do NOT auto-fix
- Provide guidance for manual resolution

### 6.2 Run Lint

```bash
npm run lint 2>&1
```

Report warnings (non-blocking).

### 6.3 Route Verification

Compare:
- Routes detected in preflight
- Routes created in Next.js

If any gaps: **FLAG** - "Route coverage incomplete. The following routes may not work:"

Report: `[PASS] Validation complete` or `[WARN] Validation completed with issues`

---

## Phase 7: Documentation

Read the migration report template from `_templates/react-to-next/migration-report.md`.

### 7.1 Generate Migration Report

Create comprehensive report with:
- All changes made
- Route mapping table
- Environment variable changes
- Known issues
- Next steps

### 7.2 Write Report to File

Write to `MIGRATION_REPORT.md` in project root.

### 7.3 Display Summary

Show abbreviated summary to user:
- Files changed count
- Routes migrated
- Known issues count
- Build status

---

## Phase 8: Completion

### 8.1 Final Summary

```
/pro:react.to.next Complete
────────────────────────────────────────

Branch: feat/react-to-next-migration
Router: {App Router / Pages Router}

Changes:
  {count} files created
  {count} files modified
  {count} routes migrated

Route Safety: ✓ All routes covered
Build: {PASS/FAIL}

Next Steps:
  1. Review changes: git diff main
  2. Update .env.local with renamed variables
  3. npm install && npm run dev
  4. Test all routes manually
  5. Create PR when ready

Report saved to: MIGRATION_REPORT.md

────────────────────────────────────────
```

---

## Error Handling

### Unrecoverable Errors

| Error | Action |
|-------|--------|
| No package.json | Abort immediately |
| Not a React project | Abort immediately |
| Cannot parse routes | Prompt for manual route input or abort |
| Build fails critically | Report errors, do not auto-fix |

### Recoverable Warnings

| Warning | Action |
|---------|--------|
| Some routes not detected | Create catch-all, document in report |
| TypeScript errors | Report, continue |
| Lint warnings | Report, continue |
| Deprecated patterns | Document in report |

---

## Rollback

If the user needs to abandon the migration:

```bash
git checkout main
git branch -D feat/react-to-next-migration
```

No changes will have been committed to main branch.
