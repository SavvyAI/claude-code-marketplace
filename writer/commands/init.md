## Context

Initialize a new book project with standard structure.

## Purpose

Create the directory structure and manifest files needed for a long-form writing project.

**Given** no existing `book/` directory
**When** `/writer:init` is invoked
**Then** the directory structure and manifest files are created

## Your Task

### Step 1: Check for Existing Project

```bash
ls book/ 2>/dev/null
```

If `book/` exists and contains files:
- Display: "A book project already exists. Use `/writer:chapter` to add content."
- Exit

### Step 2: Gather Book Metadata

Use `AskUserQuestion` to collect:

```
question: "What is the title of your book?"
header: "Title"
options:
  - "Untitled Book" (placeholder - I'll name it later)
```

```
question: "Who is the author?"
header: "Author"
options:
  - Use git config user.name
```

### Step 3: Create Directory Structure

```bash
mkdir -p book/chapters
mkdir -p book/front-matter
mkdir -p book/back-matter
mkdir -p book/dist/specmd
mkdir -p book/dist/latex
mkdir -p book/dist/markdown
```

### Step 4: Create Book Manifest

Write `book/book.json`:

```json
{
  "title": "<user-provided title>",
  "author": "<user-provided or git config author>",
  "version": "0.1.0",
  "created": "<ISO 8601 timestamp>",
  "chapters": [],
  "frontMatter": [],
  "backMatter": [],
  "compilationTargets": ["specmd", "latex", "markdown"]
}
```

### Step 5: Create Starter Content

Write `book/front-matter/title.md`:

```markdown
# <Book Title>

By <Author Name>

---

*Draft version 0.1.0*
```

Write `book/chapters/00-preface.md`:

```markdown
# Preface

[Your preface goes here. This chapter explains the motivation behind the book, who it's for, and what readers will learn.]
```

### Step 6: Update .gitignore

If `.gitignore` exists, append (if not already present):

```
# Writer plugin build outputs
book/dist/
```

### Step 7: Display Confirmation

```
╔════════════════════════════════════════════════════════════════╗
║  BOOK PROJECT INITIALIZED                                       ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Title: <Book Title>                                            ║
║  Author: <Author Name>                                          ║
║                                                                 ║
║  Structure created:                                             ║
║  book/                                                          ║
║  ├── book.json           (manifest)                             ║
║  ├── chapters/           (your content)                         ║
║  │   └── 00-preface.md   (starter chapter)                      ║
║  ├── front-matter/       (title, dedication)                    ║
║  │   └── title.md        (title page)                           ║
║  ├── back-matter/        (appendix, bibliography)               ║
║  └── dist/               (compiled outputs)                     ║
║                                                                 ║
║  Next steps:                                                    ║
║  - Add chapters: /writer:chapter "Chapter Title"                ║
║  - Compile book: /writer:compile                                ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

## Edge Cases

- **Existing project:** Inform user, do not overwrite
- **No git config:** Prompt for author name explicitly
- **Special characters in title:** Sanitize for filesystem when creating slugs
