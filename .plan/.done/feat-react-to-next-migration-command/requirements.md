# /pro:react.to.next Requirements

## Summary

A deterministic, auditable migration pipeline that converts client-rendered React applications into Next.js applications with functional parity and documented outcomes.

---

## Authoritative Decisions

| Category          | Decision                             |
| ----------------- | ------------------------------------ |
| Target Scope      | External React projects              |
| Output Mode       | In-place migration                   |
| Branching         | Standard feature branch              |
| Router Default    | App Router                           |
| Pages Router      | Fallback only                        |
| Route Safety      | Guaranteed via catch-all + detection |
| Broken URL Risk   | Eliminated                           |
| Flags             | None                                 |
| Interaction Model | Guided prompts                       |
| Tracking          | Full, consistent with other work     |

---

## Core Guarantees

1. **Deterministic output** - Same input produces equivalent results
2. **No silent rewrites** - All changes are observable and documented
3. **No bundler lock-in** - Works regardless of original bundler
4. **Functional parity** - Runtime behavior is preserved
5. **Route safety** - No valid URL may return 404 after migration

---

## Execution Phases

### Phase 1: Preflight (Decision Engine)

**Purpose:** Establish constraints, risks, and sane defaults before modifying code.

**Detects:**
- Runtime assumptions (browser globals, DOM-at-import)
- Routing structure (React Router, custom routing, hash routing)
- Environment variable usage and exposure patterns
- Asset handling (public folder, imports, CDN references)
- Styling strategies (CSS Modules, styled-components, Tailwind, etc.)
- Data-fetching patterns (SWR, React Query, fetch, axios)
- Third-party integrations and global side effects
- Bundler coupling (Vite, CRA, Webpack, Parcel)
- Hosting assumptions (SPA fallback routing, base paths)

**Outputs:**
- Human-readable preflight report
- Router recommendation (App Router vs Pages Router fallback)
- Risk assessment with confidence levels
- Required user confirmations

### Phase 2: Scaffold

**Purpose:** Establish minimal Next.js baseline.

**Actions:**
- Add Next.js dependencies
- Create `next.config.js` with detected settings
- Set up `app/` or `pages/` directory structure
- Configure TypeScript (if detected)
- Preserve existing configuration where possible

**Constraints:**
- No forced language conversion
- No stylistic tooling mandates
- No unnecessary reorganization

### Phase 3: Migration & Translation

**Purpose:** Move behavior, not just files.

**Actions:**
- Map existing routes to Next.js routes
- Add `'use client'` directives where needed
- Preserve component structure
- Handle environment variable renaming (`REACT_APP_*` → `NEXT_PUBLIC_*`)
- Migrate assets to `public/` if needed
- Update import paths

**Route Safety Implementation:**
- Detect all client-side routes from routing configuration
- Create explicit Next.js routes for each detected path
- Generate catch-all route (`[[...slug]]`) for unmatched paths
- Catch-all delegates to migrated application shell
- Ensure deep links and direct URL access resolve correctly

### Phase 4: Normalization

**Purpose:** Make application compatible with Next.js execution semantics.

**Actions:**
- Isolate client-only behavior with `'use client'`
- Handle browser global access (window, document, localStorage)
- Wrap SSR-unsafe code with dynamic imports or client checks
- Normalize environment variable access

**Principles:**
- Default to least invasive change
- Prefer explicit boundaries over global opt-outs
- Conservative environment variable exposure

### Phase 5: Validation

**Purpose:** Confirm the migrated application is operational.

**Actions:**
- Run `next build` to verify compilation
- Check for TypeScript errors
- Surface routing mismatches
- Report hydration warnings
- Verify route manifest covers all detected routes

**Behavior on failure:**
- Report specific errors
- Do not auto-remediate
- Provide actionable guidance

### Phase 6: Documentation

**Purpose:** Make the migration explainable and supportable.

**Outputs:**
- Migration summary report
- List of all changes made
- Known issues requiring follow-up
- Environment variable mapping
- Route mapping table

---

## Scripts Baseline

The migrated project must expose these scripts:

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

---

## Fallback to Pages Router

Trigger conditions:
- Detected structural incompatibilities
- Heavy reliance on imperative router APIs
- Complex nested route guards
- User explicit request

When falling back:
- Document reason in migration report
- Use `pages/` directory structure
- Still maintain route safety guarantee

---

## Explicit Non-Goals

- Rewriting business logic
- Modernizing code for stylistic reasons
- Guaranteeing SEO or performance improvements
- Eliminating all client-side code
- Refactoring beyond correctness requirements
- Test migration (document incompatibilities only)

---

## Error Handling

### Unrecoverable States
- No package.json found → Abort with message
- Not a React project → Abort with message
- Cannot infer routing structure → Prompt user for manual input or abort

### Recoverable States
- Missing optional dependencies → Warn and continue
- Deprecated patterns detected → Document and continue
- Minor TypeScript errors → Report and continue

---

## Related ADRs

- ADR-017: Branch Naming Invariant and Work-Type Taxonomy
- ADR-006: Subdirectory Pattern for Shared Templates
- ADR-019: React to Next.js Migration Design Decisions (to be created)
