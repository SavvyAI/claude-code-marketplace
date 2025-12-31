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

### Step 2: Check for Existing Content

Use `AskUserQuestion`:

```
question: "Do you have existing content to import?"
header: "Import"
options:
  - "No, start fresh (Recommended)" (create empty project structure)
  - "Yes, I have a draft to import" (import existing markdown)
```

If "Yes, I have a draft to import":
- Display: "Great! Let's import your existing content."
- Delegate to `/writer:import` command logic (the import command will handle metadata, structure creation, and content parsing)
- Exit this command (import handles everything)

If "No, start fresh":
- Continue with Steps 3-9 below

### Step 3: Gather Book Metadata

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

### Step 4: Select Book Type and Targets

Use `AskUserQuestion`:

```
question: "What type of book are you writing?"
header: "Book Type"
options:
  - "Business/Leadership" (40-60k words, 8-12 chapters)
  - "Technical Manual" (60-100k words, 15-25 chapters)
  - "Field Guide" (20-40k words, 5-10 chapters)
  - "Memoir" (60-80k words, 12-20 chapters)
  - "Academic" (80-100k words, 8-12 chapters)
  - "General" (50-75k words, 10-15 chapters)
multiSelect: false
```

Map selection to `bookType` and default targets:

| Selection | bookType | Chapters | Words/Chapter | Total Words |
|-----------|----------|----------|---------------|-------------|
| Business/Leadership | business | 8-12 | 4,000-6,000 | 40,000-60,000 |
| Technical Manual | technical | 15-25 | 3,000-5,000 | 60,000-100,000 |
| Field Guide | field-guide | 5-10 | 3,000-5,000 | 20,000-40,000 |
| Memoir | memoir | 12-20 | 4,000-6,000 | 60,000-80,000 |
| Academic | academic | 8-12 | 6,000-10,000 | 80,000-100,000 |
| General | general | 10-15 | 4,000-6,000 | 50,000-75,000 |

Then ask:

```
question: "Accept these targets or customize?"
header: "Targets"
options:
  - "Accept defaults (Recommended)" (use defaults for selected book type)
  - "Customize targets" (modify chapter count and word counts)
multiSelect: false
```

If "Customize targets":
- Ask for chapter count range (see `/writer:targets.edit` for options)
- Ask for words per chapter range
- Ask for total word count range

### Step 5: Create Directory Structure

```bash
mkdir -p book/chapters
mkdir -p book/front-matter
mkdir -p book/back-matter
mkdir -p book/dist/specmd
mkdir -p book/dist/latex
mkdir -p book/dist/markdown
```

### Step 6: Create Book Manifest

Write `book/book.json`:

```json
{
  "title": "<user-provided title>",
  "author": "<user-provided or git config author>",
  "version": "0.1.0",
  "created": "<ISO 8601 timestamp>",
  "bookType": "<selected book type>",
  "targets": {
    "chapters": { "min": <N>, "max": <N> },
    "wordsPerChapter": { "min": <N>, "max": <N> },
    "totalWords": { "min": <N>, "max": <N> }
  },
  "chapters": [],
  "frontMatter": [],
  "backMatter": [],
  "compilationTargets": ["specmd", "latex", "markdown"]
}
```

### Step 7: Create Starter Content

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

### Step 8: Update .gitignore

If `.gitignore` exists, append (if not already present):

```
# Writer plugin build outputs
book/dist/
```

### Step 9: Display Confirmation

```
╔════════════════════════════════════════════════════════════════╗
║  BOOK PROJECT INITIALIZED                                       ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Title: <Book Title>                                            ║
║  Author: <Author Name>                                          ║
║  Type: <Book Type>                                              ║
║                                                                 ║
║  Targets:                                                       ║
║  - Chapters: <min>-<max>                                        ║
║  - Words/Chapter: <min>-<max>                                   ║
║  - Total Words: <min>-<max>                                     ║
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
║  - View progress: /writer:status                                ║
║  - Compile book: /writer:compile                                ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

## Edge Cases

- **Existing project:** Inform user, do not overwrite
- **No git config:** Prompt for author name explicitly
- **Special characters in title:** Sanitize for filesystem when creating slugs
