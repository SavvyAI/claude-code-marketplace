# Known Issues & Future Enhancements

Items identified during implementation and code review that are out of scope for the initial release.

---

## From CodeRabbit Review

### 1. Enhanced Styling Migration Strategies

**Issue:** The preflight analysis mentions detecting styling patterns but doesn't provide detailed migration strategies for each approach.

**Enhancement:**
- List specific patterns: emotion, styled-components, CSS Modules, global CSS, Tailwind, inline styles
- For each, provide migration approach (server vs client boundaries, SSR setup)
- Include code examples for risky transformations

**Priority:** Medium
**Effort:** Medium

---

### 2. Enhanced Route Verification

**Issue:** Route verification is high-level. Could benefit from more automation.

**Enhancement:**
- Emit user-facing route manifest (JSON/Markdown) for review
- Implement automated coverage comparison
- Classify gaps as auto-fixable vs requiring manual intervention
- Define acceptance criteria for route coverage

**Priority:** Medium
**Effort:** High

---

### 3. Custom Routing Pattern Detection

**Issue:** "Custom routing implementations" is vague in detection scope.

**Enhancement:**
- Enumerate known routing libraries explicitly (React Router v5/v6, reach-router, redux-first-router)
- Add concrete detection examples
- Special handling for `createHashRouter` (hash-based URLs)
- Document how to extend detector with new patterns

**Priority:** Medium
**Effort:** Medium

---

### 4. Data Fetching Migration Strategies

**Issue:** Data fetching patterns are detected but migration strategies aren't detailed.

**Enhancement:**
- For each pattern (useEffect+fetch, React Query, SWR, Axios), provide:
  - Migration to server components where applicable
  - Client component wrapping guidance
  - Hydration setup for client-side data fetching
- Include API route adapter examples

**Priority:** Low
**Effort:** Medium

---

### 5. Cross-Platform Script Support (Windows)

**Issue:** Scripts use Unix-only commands (`rm`, `rm -rf`, `|| true`).

**Current mitigation:** Added documentation note about Windows alternatives.

**Future Enhancement:**
- Detect platform during preflight
- Generate platform-appropriate scripts
- Include `rimraf` or `shx` as devDependencies when needed

**Priority:** Low
**Effort:** Low

---

## Implementation Notes

These items can be addressed in future iterations. The current implementation provides:
- Complete preflight detection
- Route safety guarantee via catch-all
- Comprehensive migration steps
- Documentation generation

All enhancements would improve automation but are not blockers for the core migration capability.
