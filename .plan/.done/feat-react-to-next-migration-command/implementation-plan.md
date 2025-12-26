# Implementation Plan

## Files to Create

### 1. Command File
`pro/commands/react.to.next.md`
- Main command definition with YAML frontmatter
- Phased execution instructions
- User interaction prompts

### 2. Templates
`pro/commands/_templates/react-to-next/`
- `preflight-report.md` - Preflight analysis output structure
- `migration-report.md` - Final migration documentation structure

### 3. ADR
`doc/decisions/019-react-to-next-migration-design.md`
- Document design decisions
- Router choice rationale
- Route safety guarantee implementation

---

## Implementation Steps

### Step 1: Create Preflight Report Template
Define the structure for preflight analysis output including:
- Detected patterns (routing, styling, data fetching)
- Risk assessment
- Recommendations
- Required confirmations

### Step 2: Create Migration Report Template
Define the structure for final documentation including:
- Changes summary
- Route mapping table
- Environment variable mapping
- Known issues
- Next steps

### Step 3: Create Command File
Implement `react.to.next.md` with:
- Phase 1: Preflight detection
- Phase 2: Scaffold creation
- Phase 3: Migration execution
- Phase 4: Normalization
- Phase 5: Validation
- Phase 6: Documentation

### Step 4: Create ADR
Document the design decisions made during planning.

---

## Command Structure Design

```yaml
---
description: "Migrate React SPA to Next.js → Deterministic pipeline with route safety → Creates working Next.js app"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion", "WebFetch"]
---
```

### Interaction Flow

1. **Announce mode**: "Starting React to Next.js migration..."
2. **Preflight analysis**: Detect and report findings
3. **Present preflight report**: Show detected patterns, risks, recommendations
4. **Confirm router choice**: App Router (default) or Pages Router (fallback)
5. **Confirm branch creation**: Create migration branch
6. **Execute migration phases**: With status updates
7. **Validation**: Build and report issues
8. **Documentation**: Generate migration report
9. **Summary**: Final status and next steps

---

## Route Safety Implementation Detail

### Detection Strategy
1. Look for React Router configuration files
2. Parse route definitions from:
   - `<Route>` components
   - `createBrowserRouter` / `createHashRouter` calls
   - Custom routing implementations
3. Extract path patterns

### Catch-All Implementation
```typescript
// app/[[...slug]]/page.tsx (App Router)
// or pages/[[...slug]].tsx (Pages Router)

export default function CatchAll({ params }) {
  // Render migrated React app shell
  // This ensures any URL not explicitly mapped still renders
}
```

### Verification
- Generate route manifest from detected routes
- Compare against created Next.js routes
- Report any gaps in coverage
