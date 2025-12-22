# Command Design: /pro:readme

## Command Structure

```yaml
description: "Need a professional README? → Analyzes project and offers beautification options → Creates or updates documentation"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "WebFetch"]
```

**Note:** `WebFetch` is required for live badge and link validation.

## Phased Approach

### Phase 1: Discovery

Analyze the project to understand current state:

1. **Locate README files**
   - Check for `README.md`, `readme.md`, `README`, `README.txt`
   - Identify all README files in project (for multi-package repos)
   - Determine target README (argument > root > ask user)

2. **Detect project type**
   - Language/framework from package.json, Cargo.toml, go.mod, pyproject.toml, etc.
   - Project category: CLI tool, library, web app, monorepo, etc.
   - Tech stack and dependencies

3. **Analyze existing README (if updating)**
   - Current structure and sections
   - Existing badges and their status
   - Links present and their validity
   - Overall quality assessment

4. **Gather project metadata**
   - Repository name and description
   - License
   - Version/release info
   - Contributing guidelines existence
   - Test coverage indicators

### Phase 2: Mode Selection

Present the user with a clear choice:

```
README Mode Selection

Your README currently exists with [X sections, Y badges, Z links].

How would you like to proceed?

1. **Beautify** (Recommended for new READMEs)
   Full enhancement with modern structure, curated badges, and polished language.
   May significantly change the current format.

2. **Preserve Structure**
   Light cleanup only: fix broken links, update outdated info, minor clarity improvements.
   Keeps your current layout and style intact.
```

- For new READMEs: Default recommendation is Beautify
- For existing READMEs: No default, require explicit choice

### Phase 3: Validation (Both Modes)

Before making changes, validate current state:

1. **Badge validation**
   - Fetch each badge URL
   - Flag broken/outdated badges
   - Identify badges returning errors

2. **Link validation**
   - Check all internal links (relative paths)
   - Check all external links (HTTP requests)
   - Flag 404s and redirects

3. **Present findings to user**
   - List broken badges (with recommendations)
   - List broken links (with options: fix/remove/ignore)
   - Get user approval before proceeding

### Phase 4: Content Analysis & Generation

#### Beautify Mode

1. **Generate section structure dynamically**
   - Based on project type, include relevant sections:
     - Overview/Description
     - Features (if applicable)
     - Installation
     - Quick Start / Usage
     - Configuration (if complex)
     - API Reference (for libraries)
     - Examples
     - Contributing
     - License
     - Acknowledgments (if appropriate)

2. **Badge strategy**
   - Detect which badges are relevant:
     - npm version (if package.json)
     - CI/CD status (GitHub Actions, etc.)
     - Test coverage (if configured)
     - License badge
     - Downloads (if published package)
   - Propose badges with previews
   - User approves each badge addition/removal

3. **Content transformation**
   - Tighten language (remove filler, passive voice)
   - Improve hierarchy (proper heading levels)
   - Standardize formatting (consistent code blocks, lists)
   - Add visual structure (horizontal rules, spacing)

#### Preserve Mode

1. **Keep existing structure**
   - Same sections in same order
   - Same heading styles
   - Same overall format

2. **Apply fixes only**
   - Fix validated broken links (with approval)
   - Update outdated version numbers
   - Correct factual inaccuracies
   - Minor grammar/clarity fixes

3. **Badge changes require explicit approval**
   - Only fix broken badges if user approves
   - No new badges unless user requests

### Phase 5: Review & Approval

Present changes for user approval:

1. **Diff preview**
   - Show what will change
   - Highlight significant rewrites

2. **Granular approval**
   - Allow user to accept/reject specific changes:
     - [ ] Section restructuring
     - [ ] Badge changes
     - [ ] Link fixes
     - [ ] Content rewrites

3. **Final confirmation**
   - Summary of all changes
   - User approves or requests modifications

### Phase 6: Application & Verification

1. **Apply changes**
   - Write updated README
   - Preserve git-friendly formatting (consistent line endings, etc.)

2. **Post-application validation**
   - Re-validate all links
   - Confirm no new broken links introduced
   - Verify README renders correctly (markdown preview)

3. **Summary**
   - Report what was changed
   - Highlight improvements
   - Note any items deferred for future

## Badge Categories

### Standard Badges (propose when relevant)

| Category | When to Suggest | Example |
|----------|-----------------|---------|
| Version | Published package | `![npm version](https://img.shields.io/npm/v/package)` |
| Build Status | Has CI config | `![CI](https://github.com/owner/repo/actions/workflows/ci.yml/badge.svg)` |
| License | Has LICENSE file | `![License](https://img.shields.io/badge/license-MIT-blue)` |
| Coverage | Has coverage config | `![Coverage](https://codecov.io/gh/owner/repo/branch/main/graph/badge.svg)` |
| Downloads | npm/pypi published | `![Downloads](https://img.shields.io/npm/dm/package)` |
| TypeScript | Has tsconfig.json | `![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)` |

### Avoid

- Too many badges (visual noise)
- Vanity badges with no information value
- Redundant badges (e.g., multiple version badges)
- Broken/outdated badges

## Error Handling

| Scenario | Behavior |
|----------|----------|
| No README and no context | Ask user for project description |
| Network unavailable | Skip live validation, warn user |
| User declines all changes | Exit gracefully, no changes made |
| Validation finds critical issues | Warn before proceeding |

## File Structure

```
pro/commands/
├── readme.md              # Main command file
└── _templates/
    └── (no templates needed - dynamic generation)
```
