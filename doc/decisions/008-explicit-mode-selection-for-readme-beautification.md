# 008. Explicit Mode Selection for README Beautification

Date: 2025-12-22

## Status

Accepted

## Context

The `/pro:readme` command needed to support both comprehensive beautification (transforming READMEs into elite open-source quality) and light cleanup (preserving existing structure while fixing issues). The key design question was whether to:

1. Auto-detect the appropriate mode based on README quality
2. Always apply beautification
3. Require explicit user selection between modes

Users have strong opinions about README formatting. Some prefer minimal, functional documentation while others want polished, visually striking READMEs. Silent aesthetic changes could frustrate users who prefer their current style.

## Decision

Require explicit user selection between two modes:

1. **Beautify Mode** - Full transformation with curated badges, strong visual hierarchy, and polished language
2. **Preserve Mode** - Light cleanup that respects existing structure, focusing only on fixing broken links and updating outdated information

Key behaviors:
- New READMEs: Recommend beautify mode but still require confirmation
- Existing READMEs: No default; user must explicitly choose
- All changes are opt-in and surfaced for approval
- Broken links are flagged, not auto-removed

## Consequences

**Positive:**
- Users maintain full control over README aesthetics
- No surprise formatting changes
- Clear expectations about what each mode does
- Supports both "just fix the broken stuff" and "make it beautiful" workflows

**Negative:**
- Additional user interaction required (mode selection)
- Cannot silently improve README quality over time
- User must understand the difference between modes

## Alternatives Considered

### Auto-detection based on README quality

Analyze the existing README and choose mode automatically. Rejected because:
- Quality is subjective
- Users may disagree with the assessment
- Doesn't respect user intent

### Always beautify with undo option

Apply full beautification by default, offer to revert. Rejected because:
- Violates principle of explicit opt-in
- Git revert isn't always clean
- User may not notice unwanted changes until later

### Dynamic generation vs pre-built templates

Chose dynamic generation based on project type analysis rather than pre-built templates. This allows the command to adapt to any project type without maintaining a library of templates.

## Related

- Planning: `.plan/.done/feat-readme-beauty-mode-formatting-control/`
