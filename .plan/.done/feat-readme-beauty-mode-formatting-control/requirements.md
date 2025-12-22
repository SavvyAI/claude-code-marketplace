# README Beauty Mode & Formatting Control

## Feature Summary

A new `/pro:readme` command that provides explicit control over README beautification, allowing users to choose between a fully polished, elite open-source–quality document or minimal, non-disruptive improvements.

## Confirmed Requirements

### 1. Command Name & Target

- **Command:** `/pro:readme`
- **Default target:** `./README.md` in project root
- **Flexible targeting:** Can target any README via argument or conversation
- **Auto-detect:** When ambiguous, discover READMEs and let user choose

### 2. Modes of Operation

#### Beautify Mode (Full Enhancement)

Transforms the README into a first-class artifact:

- Strong visual hierarchy
- Clean, modern section structure
- Carefully curated repository badges
- Tight, confident language
- Consistent formatting and spacing
- Removal of clutter, redundancy, and weak phrasing
- Fixing or removing broken links (with user approval)
- Detecting missing but relevant badges and offering to add them
- Updating broken or outdated badges

**May significantly reformat the README.**

#### Preserve Structure Mode (Light Cleanup)

Respects existing structure:

- Preserves layout and formatting
- Avoids stylistic changes
- Focuses on:
  - Fixing broken links (flagged for user decision)
  - Correcting factual inaccuracies
  - Updating outdated instructions
  - Minor clarity improvements
  - Badge fixes only if explicitly approved

### 3. User Choice Behavior

| Scenario | Behavior |
|----------|----------|
| Creating README from scratch | Recommend beautify mode (user must still confirm) |
| Updating existing README | Always ask user to choose explicitly |
| Mode selection | Binary choice: Beautify vs Preserve |

### 4. Validation Behavior

| Item | Behavior |
|------|----------|
| Badge URLs | Validate live (fetch to verify they return valid images) |
| Links | Validate live, flag broken links for user decision |
| Broken links | Never auto-remove; always show user and let them decide |

### 5. Template Strategy

- **Dynamic generation** based on project analysis
- No pre-built templates
- Structure adapts to project type (CLI, library, web app, etc.)

### 6. Granular Opt-In Requirements

User must be able to approve or decline:

- [ ] Formatting changes
- [ ] Badge additions
- [ ] Badge removals
- [ ] Section rewrites
- [ ] Link removals or replacements

### 7. End State Guarantees

Regardless of mode:

- [ ] No broken links introduced
- [ ] README is internally consistent
- [ ] README accurately represents the repository

If beautify mode:

- [ ] README feels "finished"
- [ ] Signals quality, care, and professionalism
- [ ] Comparable to best-maintained open source projects

## Acceptance Criteria

- [ ] Users can explicitly choose between beautification and preservation
- [ ] Beautify mode produces a visually clean, modern, high-quality README
- [ ] Preserve mode avoids disruptive formatting changes
- [ ] All changes are opt-in and transparent
- [ ] The README is always in a better state than before the command ran
- [ ] Badge validation works live over network
- [ ] Broken links are flagged (not auto-removed)
- [ ] Command works with any README path (not just root)
