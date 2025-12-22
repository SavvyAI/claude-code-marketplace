# Known Issues & Future Enhancements

Issues that will not be addressed in this PR but should be considered for future iterations.

## Known Limitations

### 1. No Offline Mode

**Issue:** If network is unavailable, badge and link validation will fail.

**Current behavior:** Command warns user and proceeds with syntax-only checks.

**Future enhancement:** Could cache validation results or provide explicit offline mode flag.

---

### 2. No Badge Preview Images

**Issue:** When proposing badges, we describe them but don't show actual rendered previews.

**Current behavior:** Text descriptions of what each badge shows.

**Future enhancement:** Could use terminal image rendering or generate a preview document.

---

### 3. No README Templates for Specific Frameworks

**Issue:** Dynamic generation works well but some frameworks (Next.js, Rails, etc.) have community-standard README patterns.

**Current behavior:** Generic structure adapted to project type.

**Future enhancement:** Could add optional framework-specific templates as a starting point.

---

### 4. No Automated Section Ordering

**Issue:** When generating sections, the order is hardcoded rather than learned from the ecosystem.

**Current behavior:** Fixed section order based on common patterns.

**Future enhancement:** Could analyze popular repositories to determine optimal ordering.

---

### 5. No Diff Visualization

**Issue:** Changes are described in text but not shown as an actual diff.

**Current behavior:** Summarizes changes in categories (sections, badges, links).

**Future enhancement:** Could show side-by-side or unified diff format.

---

### 6. No CI/CD Badge Auto-Detection

**Issue:** Currently checks for GitHub Actions but not all CI providers.

**Current behavior:** Detects GitHub Actions workflows.

**Future enhancement:** Could detect CircleCI, Travis CI, GitLab CI, etc.

---

## Future Feature Ideas

- **README scoring** - Rate the current README on clarity, completeness, etc.
- **Competitive analysis** - Compare to similar project READMEs
- **Auto-update mode** - Watch for changes and suggest README updates
- **Localization support** - Generate README in multiple languages
- **Changelog integration** - Link version badges to CHANGELOG.md
