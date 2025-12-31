---
description: "Have existing content? → Import a draft into book structure → Auto-creates chapters from your markdown"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

## Context

Import existing content: $ARGUMENTS

## Purpose

Import existing markdown content (drafts, outlines, chapter stubs) into a Writer book project. Supports single files with H1 chapter boundaries, directories of markdown files, or pasted content.

**Given** existing markdown content with chapter-like structure
**When** `/writer:import` is invoked
**Then** a book project is created/updated with properly structured chapters

## Arguments

- `<file or directory path>` - Optional: Path to markdown file or directory

## Examples

```
/writer:import                           # Interactive mode
/writer:import draft.md                  # Import single file
/writer:import ./drafts/                 # Import directory
/writer:import "# Preface\n\nContent..." # Import pasted content
```

## Your Task

### Step 1: Check for Existing Book Project

```bash
test -d book/ && echo "exists" || echo "missing"
```

If `book/` exists:
- Read `book/book.json` to understand current structure
- Import will add to existing project

If `book/` missing:
- Will create full book structure

### Step 2: Determine Input Source

If argument provided, use it directly.

If no argument, use `AskUserQuestion`:

```
question: "Where is your existing content?"
header: "Source"
options:
  - "Single markdown file" (I'll provide the file path)
  - "Directory of markdown files" (I'll provide the directory path)
  - "Paste it here" (I'll paste my content)
```

### Step 3: Collect Content

**For file path:**
1. Verify file exists
2. Read file content

**For directory path:**
1. Glob for `*.md` files
2. Sort by filename (to preserve order: `00-`, `01-`, etc.)
3. Read each file, treat each as a section

**For pasted content:**
```
question: "Paste your content below. Include everything (preface, chapters, etc.):"
header: "Content"
freeform: true
```

### Step 4: Parse and Classify Content

Split content by H1 headings (`# `):

```javascript
// Pseudo-logic for parsing
sections = content.split(/^# /m)
  .filter(s => s.trim())
  .map(s => {
    lines = s.split('\n')
    title = lines[0].trim()
    body = lines.slice(1).join('\n').trim()
    return { title, body }
  })
```

**Classification rules:**

| Title Pattern | Classification | Destination |
|---------------|----------------|-------------|
| `Preface` | front-matter | `book/front-matter/preface.md` |
| `Foreword` | front-matter | `book/front-matter/foreword.md` |
| `Dedication` | front-matter | `book/front-matter/dedication.md` |
| `Acknowledgments` | front-matter | `book/front-matter/acknowledgments.md` |
| `Introduction` | chapter | `book/chapters/NN-introduction.md` |
| `Chapter N: Title` | chapter | `book/chapters/NN-title.md` |
| `Appendix` / `Appendix: Title` | back-matter | `book/back-matter/appendix.md` |
| `Bibliography` | back-matter | `book/back-matter/bibliography.md` |
| `Index` | back-matter | `book/back-matter/index.md` |
| `Epilogue` | back-matter | `book/back-matter/epilogue.md` |
| Other | chapter | `book/chapters/NN-slugified-title.md` |

### Step 5: Display Analysis and Confirm

```
[ writer:import ]
-----------------
Analyzing content...

Detected structure:
  • Preface (234 words) → front-matter
  • Introduction (156 words) → chapter 01
  • Getting Started (89 words) → chapter 02
  • Core Concepts (112 words) → chapter 03
  • Appendix (45 words) → back-matter

Total: 5 sections, 636 words

Book project will be created at: book/

Proceed with import? [Y/n]
```

Wait for confirmation before proceeding.

### Step 6: Create Book Structure (if needed)

If `book/` doesn't exist:

```bash
mkdir -p book/chapters
mkdir -p book/front-matter
mkdir -p book/back-matter
mkdir -p book/dist/specmd
mkdir -p book/dist/latex
mkdir -p book/dist/markdown
```

### Step 7: Gather Metadata (if new project)

If creating new project, ask for book metadata:

```
question: "What is the title of your book?"
header: "Title"
freeform: true
```

```
question: "Who is the author?"
header: "Author"
options:
  - Use git config user.name
```

### Step 8: Write Chapter Files

For each classified section:

**Front matter:**
```markdown
# {Title}

{Body content}
```

**Chapters:**
```markdown
# {Title}

{Body content}
```

Use numbering based on order detected:
- `01-introduction.md`
- `02-getting-started.md`
- etc.

**Back matter:**
```markdown
# {Title}

{Body content}
```

### Step 9: Create/Update Book Manifest

Write or update `book/book.json`:

```json
{
  "title": "<user-provided or inferred title>",
  "author": "<user-provided or git config author>",
  "version": "0.1.0",
  "created": "<ISO 8601 timestamp>",
  "imported": "<ISO 8601 timestamp>",
  "chapters": [
    {
      "number": 1,
      "title": "Introduction",
      "file": "01-introduction.md",
      "wordCount": 156,
      "lastModified": "<ISO 8601 timestamp>"
    },
    ...
  ],
  "frontMatter": [
    {
      "title": "Preface",
      "file": "preface.md",
      "wordCount": 234
    }
  ],
  "backMatter": [
    {
      "title": "Appendix",
      "file": "appendix.md",
      "wordCount": 45
    }
  ],
  "compilationTargets": ["specmd", "latex", "markdown"]
}
```

### Step 10: Update .gitignore

If `.gitignore` exists, append (if not already present):

```
# Writer plugin build outputs
book/dist/
```

### Step 11: Display Summary

```
╔════════════════════════════════════════════════════════════════╗
║  IMPORT COMPLETE                                                ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Book: <Title>                                                  ║
║  Author: <Author>                                               ║
║                                                                 ║
║  Imported: 5 sections (636 words)                               ║
║                                                                 ║
║  Structure created:                                             ║
║  book/                                                          ║
║  ├── book.json                                                  ║
║  ├── front-matter/                                              ║
║  │   └── preface.md                                             ║
║  ├── chapters/                                                  ║
║  │   ├── 01-introduction.md                                     ║
║  │   ├── 02-getting-started.md                                  ║
║  │   └── 03-core-concepts.md                                    ║
║  └── back-matter/                                               ║
║      └── appendix.md                                            ║
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
- **Existing book/ project:** Ask "Merge with existing?" or "Abort?"
- **Empty sections:** Create placeholder files with `[Content to be added]`
- **Duplicate titles:** Append suffix (`-1`, `-2`) to filename
- **Chapter N: Title format:** Extract title, use N for ordering
- **Very long content:** Show progress as sections are processed
- **Non-markdown content:** Warn user, attempt to import as plain text
- **Directory with non-md files:** Skip non-markdown files, inform user

## Slugification Rules

Convert titles to filenames:
1. Lowercase
2. Remove `Chapter N:` prefix if present
3. Replace spaces with hyphens
4. Remove special characters
5. Truncate to 50 characters

Examples:
- "Getting Started with Basics" → `getting-started-with-basics`
- "Chapter 1: Introduction" → `introduction`
- "What's Next?" → `whats-next`
