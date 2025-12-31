# Spike: Import Existing Content into Writer Book Project

## Summary

Explore and implement the ability to import existing markdown content (a draft book with preface and chapter stubs) into the Writer plugin's book structure.

## Uncertainty Being Reduced

1. What's the best UX for importing existing markdown content?
2. How should we detect and parse chapter boundaries?
3. Should this be a new command or enhancement to existing command?

## Decision

Implement **both**:
- **Option A:** `/writer:import` - Standalone command for importing into existing or new projects
- **Option B:** Enhance `/writer:init` - Ask "Do you have existing content to import?" and delegate

## Design

### Input Formats Supported

1. **Single markdown file with H1 chapter boundaries**
   ```markdown
   # Preface
   Content...

   # Chapter 1: Introduction
   Content...

   # Chapter 2: Getting Started
   Content...
   ```

2. **Multiple markdown files** (directory or glob pattern)
   ```
   draft/
   ├── 00-preface.md
   ├── 01-introduction.md
   └── 02-getting-started.md
   ```

3. **Pasted content** (clipboard/stdin)

### Chapter Detection Heuristics

| Pattern | Detection |
|---------|-----------|
| `# Preface` | Front matter → `book/front-matter/preface.md` |
| `# Introduction` | Chapter (unless explicitly "foreword") |
| `# Chapter N:` | Explicit chapter marker |
| `# Appendix` | Back matter → `book/back-matter/appendix.md` |
| Other H1 | Default to chapter |

### `/writer:import` Command Flow

```
1. Check if book/ exists
   - If exists: Import into existing structure
   - If not: Offer to create via /writer:init first OR auto-create

2. Determine input source
   - AskUserQuestion: "Where is your existing content?"
     - "Single markdown file" → prompt for path
     - "Directory of markdown files" → prompt for path
     - "Paste it here" → accept multiline input
     - "Read from clipboard" → pbpaste

3. Parse content
   - Split by H1 headings
   - Classify each section (front-matter, chapter, back-matter)
   - Extract title from H1 text
   - Preserve existing content as chapter body

4. Generate book structure
   - Create numbered chapter files: `01-slug.md`, `02-slug.md`
   - Place front-matter in `book/front-matter/`
   - Place back-matter in `book/back-matter/`
   - Update `book/book.json` manifest

5. Display summary
   - Show what was imported
   - List created files
   - Offer next steps
```

### `/writer:init` Enhancement

Add Step 2.5 after metadata gathering:

```
question: "Do you have existing content to import?"
header: "Import"
options:
  - "Yes, I have a draft to import"
  - "No, start fresh (Recommended)"
```

If "Yes":
- Delegate to import logic (shared with /writer:import)
- Skip creating starter content (preface stub)

## Files to Create/Modify

| File | Action |
|------|--------|
| `writer/commands/import.md` | Create - New import command |
| `writer/commands/init.md` | Modify - Add "existing content?" question |
| `writer/CLAUDE.md` | Modify - Add import command to table |
| `writer/readme.md` | Modify - Document import workflow |

## Example Session

```
$ claude
> /writer:import

[ writer:import ]
-----------------
Where is your existing content?
  ○ Single markdown file
  ○ Directory of markdown files
  ● Paste it here
  ○ Read from clipboard

> [user pastes content]

Analyzing content...

Detected structure:
  • Preface (234 words)
  • Chapter 1: Introduction (156 words)
  • Chapter 2: Getting Started (89 words)
  • Chapter 3: Core Concepts (112 words)
  • Appendix: Resources (45 words)

Book project will be created at: book/

Proceed? [Y/n]

Creating book structure...
✔ book/book.json
✔ book/front-matter/preface.md
✔ book/chapters/01-introduction.md
✔ book/chapters/02-getting-started.md
✔ book/chapters/03-core-concepts.md
✔ book/back-matter/appendix.md

╔════════════════════════════════════════════════════════════════╗
║  IMPORT COMPLETE                                                ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Imported: 5 sections (636 words)                               ║
║  Front matter: 1 file                                           ║
║  Chapters: 3 files                                              ║
║  Back matter: 1 file                                            ║
║                                                                 ║
║  Next steps:                                                    ║
║  - Edit chapters: /writer:chapter 01                            ║
║  - Add content: /writer:chapter "New Chapter"                   ║
║  - Compile book: /writer:compile                                ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

## Edge Cases

- **No H1 headings:** Treat entire content as single chapter, prompt for title
- **Existing book/:** Ask whether to merge or abort
- **Empty sections:** Create placeholder files with stub content
- **Non-markdown content:** Warn and skip, or attempt conversion
- **Duplicate chapter titles:** Append suffix (-1, -2)

## Definition of Done

- [ ] `/writer:import` command created
- [ ] `/writer:init` enhanced with import option
- [ ] Chapter detection heuristics working
- [ ] Manifest properly populated
- [ ] Edge cases handled gracefully
