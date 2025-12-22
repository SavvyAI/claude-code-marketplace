# Feature: WTF Alias and Report Output

## Branch
`feat/wtf-alias-and-report-output`

## Summary
Add `/pro:wtf` as an alias for `/pro:handoff` with enhanced output capabilities including file persistence and clipboard copy.

---

## Requirements

### In Scope
- [x] `/pro:wtf` command as alias for `/pro:handoff`
- [x] Unique description for `/pro:wtf`: "WTF is going on here? → Deep-dive analysis of codebase state and health → Comprehensive situation report"
- [x] Report saved to cross-platform temp directory
- [x] Report copied to clipboard (markdown format)
- [x] File naming: `{command}-{project}-{timestamp}.md` (lowercase)
  - Example: `wtf-ccplugins-20241222-143022.md`
  - Example: `handoff-myproject-20241222-150000.md`

### Out of Scope (Future Feature)
- [ ] `/pro:onboarding` - see [Future: Onboarding Command](#future-onboarding-command) below

---

## Design Decisions

### 1. Shared Content via Template Directory
Since Claude Code doesn't support markdown includes, we use a template directory:

```
pro/commands/
├── handoff.md              # Command with unique frontmatter
├── wtf.md                  # Alias with unique frontmatter
└── _templates/
    └── handoff-report.md   # Shared report template (not a command)
```

**Rationale:** Subdirectories under `commands/` are not scanned for commands, allowing us to store shared templates without exposing them as commands.

### 2. Cross-Platform Temp Directory
Use shell expansion: `${TMPDIR:-/tmp}/`
- macOS: Uses `$TMPDIR` (typically `/var/folders/...`)
- Linux: Falls back to `/tmp/`
- Windows/WSL: Falls back to `/tmp/` (WSL) or requires different handling

### 3. Cross-Platform Clipboard
Detection and usage:
- macOS: `pbcopy`
- Linux: `xclip -selection clipboard` or `xsel --clipboard`
- Windows/WSL: `clip.exe`

### 4. File Naming Convention
`{command}-{project}-{timestamp}.md`
- `{command}`: `wtf` or `handoff` (lowercase)
- `{project}`: Project directory name (lowercase, sanitized)
- `{timestamp}`: `YYYYMMDD-HHMMSS` format

---

## Implementation Steps

1. Create `_templates/` directory under `commands/`
2. Extract report template from `handoff.md` to `_templates/handoff-report.md`
3. Update `handoff.md`:
   - Keep unique frontmatter
   - Add instructions to read template
   - Add file output instructions
   - Add clipboard copy instructions
4. Create `wtf.md`:
   - Unique frontmatter with WTF-themed description
   - Same instructions as handoff.md but with `wtf` command identifier
5. Test both commands

---

## Future: Onboarding Command

> Documented here for future implementation in a separate feature branch.

### `/pro:onboarding` - Distinct from Handoff

**Purpose:** Interactive, guided setup for new developers joining a project.

**Key Differences from Handoff:**

| Aspect | Handoff / WTF | Onboarding |
|--------|---------------|------------|
| **Purpose** | "Here's the state of things" | "Here's how to get productive" |
| **Audience** | Anyone needing situational awareness | New developer joining the team |
| **Tone** | Documentary/analytical | Instructional/guided |
| **Output** | Report of what exists | Checklist + verification steps |

**Proposed Features:**
1. **Guided setup walkthrough** - Interactive verification of prerequisites
2. **Environment verification** - Run actual checks with pass/fail status
3. **First-run automation** - Offer to run setup commands
4. **IDE/tooling recommendations** - Extensions, settings, configurations
5. **"Your first task" suggestions** - Good starter issues/tasks
6. **Key files to read first** - Curated, prioritized list
7. **Team contacts** - Who to ask for what

**Suggested Description:**
"Onboarding a new developer? → Interactive setup guide with verification → Get productive in minutes"

---

## Testing Checklist

- [ ] `/pro:handoff` generates report
- [ ] `/pro:handoff` saves to temp directory with correct filename
- [ ] `/pro:handoff` copies to clipboard
- [ ] `/pro:wtf` generates same report
- [ ] `/pro:wtf` saves with `wtf-` prefix
- [ ] `/pro:wtf` copies to clipboard
- [ ] Cross-platform: macOS temp directory works
- [ ] Cross-platform: clipboard works on macOS

---

## Known Issues / Limitations

- Large reports may exceed clipboard size limits on some systems
- Windows native (PowerShell) requires different environment variable syntax (`$env:TEMP` vs `${TMPDIR:-/tmp}`) - documented in commands

## CodeRabbit Review Findings (Addressed)

1. **Windows temp directory** - Added platform-specific documentation for `$env:TEMP` (PowerShell) alongside Unix patterns
2. **Generator attribution** - Kept as-is since these are Claude Code-specific commands and the attribution correctly identifies which command was used

---

## Related ADRs

- [006. Subdirectory Pattern for Shared Templates](../../doc/decisions/006-subdirectory-pattern-for-shared-templates.md)
