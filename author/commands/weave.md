---
description: "Content to weave? → Bulk import or integrate references → Context-aware dialogue"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "WebSearch", "WebFetch", "AskUserQuestion"]
---

## Context

Weave content into book: $ARGUMENTS

## Purpose

Weave content into a book project. This command is context-aware:

- **Empty/new book**: Bulk scaffold mode - auto-detect chapter structure from H1 headings, minimal dialogue
- **Existing book**: Integration mode - collaborative dialogue to place content strategically

Supports pasted text, markdown files, images/screenshots, PDFs, URLs, and file paths.

**Given** content to incorporate (any format)
**When** `/author:weave` is invoked
**Then** content is analyzed and woven into the book structure

## Arguments

- `<input>` - Optional: file path, URL, or pasted content

## Examples

```
/author:weave                              # Interactive mode
/author:weave draft.md                     # Weave from markdown file
/author:weave screenshot.png               # Weave from screenshot
/author:weave https://example.com/article  # Weave from URL
/author:weave notes.md                     # Weave from file
/author:weave "The key insight is..."      # Weave pasted content
```

## Your Task

### Step 1: Check Book Project State

```bash
test -f book/book.json && echo "exists" || echo "missing"
```

**If book.json is missing:**
- The book project doesn't exist yet
- Will use **Bulk Scaffold Mode** to create structure

**If book.json exists:**
- Check if chapters directory has content:
```bash
ls book/chapters/*.md 2>/dev/null | wc -l
```

**Determine mode:**
- If `book/book.json` missing OR `book/chapters/` has 0-1 files → **Bulk Scaffold Mode**
- Otherwise → **Integration Mode**

Display mode:
```
[ author:weave ]
----------------
Mode: [Bulk Scaffold | Integration]
```

---

## BULK SCAFFOLD MODE

Use this mode when the book is empty or nearly empty. This is for importing existing drafts to create book structure.

### Bulk Step 2: Collect Content

**If argument provided:**
- Detect type by pattern:
  - Ends with `.md`, `.txt` → Text file (likely a draft)
  - Starts with `http://` or `https://` → URL
  - Ends with `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp` → Image
  - Ends with `.pdf` → PDF
  - Otherwise → Pasted content

**If no argument:**

Use `AskUserQuestion`:
```
question: "Where is your existing content?"
header: "Source"
options:
  - "Single markdown file" (I'll provide the file path)
  - "Directory of markdown files" (I'll provide the directory path)
  - "Paste it here" (I'll paste my content)
```

### Bulk Step 3: Parse and Classify Content

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

### Bulk Step 4: Display Analysis and Confirm

```
[ author:weave | bulk scaffold ]
--------------------------------
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

### Bulk Step 5: Create Book Structure (if needed)

If `book/` doesn't exist:

```bash
mkdir -p book/chapters
mkdir -p book/front-matter
mkdir -p book/back-matter
mkdir -p book/dist/specmd
mkdir -p book/dist/latex
mkdir -p book/dist/markdown
```

### Bulk Step 6: Gather Metadata (if new project)

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
```

### Bulk Step 7: Write Chapter Files

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

### Bulk Step 8: Create/Update Book Manifest

Write or update `book/book.json`:

```json
{
  "title": "<user-provided or inferred title>",
  "author": "<user-provided or git config author>",
  "version": "0.1.0",
  "created": "<ISO 8601 timestamp>",
  "bookType": "<selected book type>",
  "targets": {
    "chapters": { "min": <N>, "max": <N> },
    "wordsPerChapter": { "min": <N>, "max": <N> },
    "totalWords": { "min": <N>, "max": <N> }
  },
  "chapters": [
    {
      "number": 1,
      "title": "Introduction",
      "file": "01-introduction.md",
      "wordCount": 156,
      "lastModified": "<ISO 8601 timestamp>"
    }
  ],
  "frontMatter": [...],
  "backMatter": [...],
  "compilationTargets": ["specmd", "latex", "markdown"]
}
```

### Bulk Step 9: Update .gitignore

If `.gitignore` exists, append (if not already present):

```
# Author plugin build outputs
book/dist/
```

### Bulk Step 10: Display Summary

```
╔════════════════════════════════════════════════════════════════╗
║  WEAVE COMPLETE (Bulk Scaffold)                                 ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Book: <Title>                                                  ║
║  Author: <Author>                                               ║
║  Type: <Book Type>                                              ║
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
║  - Edit chapters: /author:chapter 01                            ║
║  - Add content: /author:chapter "New Chapter"                   ║
║  - View progress: /author:status                                ║
║  - Compile book: /author:compile                                ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

**Exit after bulk scaffold is complete.**

---

## INTEGRATION MODE

Use this mode when the book already has content. This is for weaving external references and additional material into existing chapters.

### Integration Step 2: Intake - Collect Reference Material

**If argument provided:**
- Detect type by pattern:
  - Starts with `http://` or `https://` → URL
  - Ends with `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp` → Image
  - Ends with `.pdf` → PDF
  - Ends with `.md`, `.txt`, or other text extension → Text file
  - Otherwise → Pasted content

**If no argument:**

Use `AskUserQuestion`:
```
question: "What reference material would you like to weave into your book?"
header: "Source"
options:
  - "Paste text" (I'll paste the content directly)
  - "Image/screenshot" (I'll provide a file path or it's already in the conversation)
  - "URL" (I'll provide a web link)
  - "File" (I'll provide a file path)
```

### Integration Step 3: Extract Content

**For images (screenshots, photos):**
- The image should already be visible in the conversation
- Extract all text content using vision
- Note any structural elements (headers, bullets, tables)
- Describe any non-text visual information

**For URLs:**
- Use `WebFetch` to retrieve page content
- Extract main article/content, strip navigation and ads
- Capture title, author, publication date if available

**For PDFs:**
- Read the PDF file (Claude can read PDFs directly)
- Extract structured content

**For text files:**
- Read file content directly

**For pasted text:**
- Use content as-is

**Display extraction result:**
```
[ author:weave | intake ]
-------------------------
Extracted from: [source type and name]
Content type: [description - e.g., "Structured notes (4 sections, 22 points)"]

Preview:
─────────────────────────────────────────
[First ~500 chars of extracted content]
[...]
─────────────────────────────────────────

Is this content extracted correctly? [Y/n]
```

Wait for confirmation before proceeding.

### Integration Step 4: Source Verification (Optional)

Use `AskUserQuestion`:
```
question: "Should I research this material before weaving?"
header: "Verify"
options:
  - "Find original source (Recommended)" (Search for where this came from)
  - "Verify key claims" (Research specific facts for accuracy)
  - "Skip verification" (I trust this source)
```

**If "Find original source":**
- Use `WebSearch` with key phrases from the content
- Look for the original publication
- Report findings:

```
[ author:weave | source ]
-------------------------
Search results:

Found likely original: [Title]
URL: [url]
Author: [author if found]
Published: [date if found]

Confidence: [High/Medium/Low]

Notes:
- [Any discrepancies or additional context]

Use this source for citation? [Y/n]
```

**If "Verify key claims":**
- Identify factual claims in the material
- Present them to user:

```
question: "Which claims should I verify?"
header: "Claims"
multiSelect: true
options:
  - "[Claim 1 summary]"
  - "[Claim 2 summary]"
  - "[Claim 3 summary]"
  - "All of the above"
```

- Use `WebSearch` for selected claims
- Report verification results with sources

### Integration Step 5: Load Book Structure

```bash
cat book/book.json
```

Read chapter list and understand current structure:
```bash
ls book/chapters/
```

For each chapter, read the first ~50 lines to understand content:
```bash
head -50 book/chapters/*.md
```

### Integration Step 6: Analyze Themes and Match to Structure

Identify distinct themes/topics in the reference material.

For each theme, determine:
1. Does it match an existing chapter? (strong/moderate/weak fit)
2. Does it fill a gap in existing content?
3. Would it warrant a new section or chapter?

Present analysis:
```
[ author:weave | analysis ]
---------------------------
Reference themes identified:
1. [Theme 1]
2. [Theme 2]
3. [Theme 3]

Your book structure:
├── [chapter list from book.json]

Theme mapping:
• [Theme 1] → [Chapter X] ([fit level])
• [Theme 2] → [Chapter Y] or new section ([reasoning])
• [Theme 3] → [Recommendation] ([reasoning])
```

### Integration Step 7: Present Proposal

For each theme/section of the reference material, present a concrete proposal:

```
[ author:weave | proposal ]
---------------------------

PROPOSAL: Weave [Reference Title]

┌─────────────────────────────────────────────────────────────────┐
│ 1. "[Section/Theme name]" → [Target chapter]: [Chapter title]   │
│    ──────────────────────────────────────────────────────────   │
│    Transform: [How the content will be adapted]                 │
│    Placement: [Specific location - new subsection, append, etc] │
│    Est. words: ~[number]                                        │
│    Rationale: [Why this placement makes sense]                  │
└─────────────────────────────────────────────────────────────────┘

[Repeat for each section]

Total estimated addition: ~[X] words across [N] chapters

How would you like to proceed?
```

Use `AskUserQuestion` for each item:
```
question: "How should I handle '[Section name]'?"
header: "Section 1"
options:
  - "Include as proposed" (Proceed with this placement)
  - "Let's discuss" (I have questions or want to explore options)
  - "Skip this" (Don't include in the book)
```

### Integration Step 8: Dialogue Phase

**For "Let's discuss":**

Enter conversational mode. The user may:
- Ask for more detail about the reference content
- Request alternative placement options
- Ask Claude to expound on a topic
- Suggest a different transformation approach
- Ask about how it relates to existing content

Respond naturally to questions. Use `WebSearch` if the user wants more information on a topic.

Continue dialogue until user makes a decision (include, skip, or modified include).

### Integration Step 9: Draft Woven Content

For each approved item:

1. **Detect voice** - Analyze the target chapter to understand:
   - Person (I/you/we/one)
   - Formality level
   - Sentence length and complexity
   - Use of examples
   - Technical depth

2. **Generate draft** - Transform reference material into prose that:
   - Matches detected voice
   - Synthesizes rather than copies
   - Adds value through expansion/connection
   - Includes citation (footnote or inline per user preference)

3. **Present with context:**

```
[ author:weave | draft ]
------------------------

Drafting: "[Section title]" for [Chapter name]

SUMMARY:
• Adding: [What's being added and where]
• Word count: ~[N] words
• Citation style: [footnote/inline]
• Voice: [Detected voice characteristics]

DRAFT:
─────────────────────────────────────────
[Full drafted content including citation]
─────────────────────────────────────────

CONTEXT (surrounding content):
[Previous paragraph or section ending...]

[YOUR NEW CONTENT WOULD GO HERE]

[Next paragraph or section beginning...]
─────────────────────────────────────────
```

Use `AskUserQuestion`:
```
question: "How does this draft look?"
header: "Review"
options:
  - "Approve" (Write this to the chapter)
  - "Needs adjustment" (I'll tell you what to change)
  - "Rewrite completely" (Start over with different approach)
  - "Skip this section" (Don't include after all)
```

### Integration Step 10: Refinement Loop

**If "Needs adjustment":**

Ask what to change:
```
question: "What would you like me to adjust?"
header: "Adjust"
options:
  - "Tone/voice" (Make it more/less formal, casual, etc.)
  - "Length" (Expand or condense)
  - "Citation style" (Change footnote to inline or vice versa)
  - "Content focus" (Emphasize different aspects)
```

Apply changes and re-present draft.

Repeat until user approves or skips.

### Integration Step 11: Store Reference (Conditional)

Use `AskUserQuestion`:
```
question: "Should I archive this reference for future use?"
header: "Archive"
options:
  - "Yes, archive it" (Store in book/references/ with full content)
  - "Just cite it" (Only add to bibliography, don't store content)
```

**If archiving:**

Create `book/references/` if it doesn't exist:
```bash
mkdir -p book/references
```

Generate reference ID:
```bash
ls book/references/ref-*.md 2>/dev/null | wc -l
```
Use: `ref-{next number}-{slugified-title}.md`

Write reference file:
```markdown
---
id: ref-[NNN]
title: "[Title]"
author: [Author if known]
url: [URL if applicable]
accessed: [Today's date ISO 8601]
type: [article/book/video/other]
archived: true
---

# [Title]

[Full extracted content]
```

Update or create `book/references/references.json`:
```json
{
  "references": [
    {
      "id": "ref-[NNN]",
      "title": "[Title]",
      "author": "[Author]",
      "url": "[URL]",
      "accessed": "[Date]",
      "type": "[Type]",
      "archived": true,
      "usedIn": ["[chapter-file.md]", ...]
    }
  ]
}
```

### Integration Step 12: Commit Changes

Display summary of all changes:
```
[ author:weave | committing ]
-----------------------------

Writing changes:

✓ book/chapters/[chapter].md
  [Description of change] (+[N] words)

[Repeat for each changed chapter]

✓ book/references/ref-[NNN]-[slug].md (if archived)
  Archived reference with metadata

✓ book/back-matter/bibliography.md
  Added citation entry

✓ book/book.json
  Updated word counts and lastModified

Total additions: ~[N] words across [N] chapters

Commit these changes? [Y/n]
```

**If confirmed:**

1. Write approved drafts to chapter files at specified locations
2. Write reference file (if archiving)
3. Update bibliography:

```markdown
## Bibliography

[Existing entries...]

[Author]. "[Title]." [Publication], [Year].
[URL if applicable]
```

4. Update `book/book.json`:
   - Increment word counts for affected chapters
   - Update `lastModified` timestamps
   - Add to `revisions` array if it exists

### Integration Step 13: Display Completion

```
╔════════════════════════════════════════════════════════════════╗
║  WEAVE COMPLETE                                                 ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Reference: [Title]                                             ║
║  Source: [URL or description]                                   ║
║                                                                 ║
║  Woven into:                                                    ║
║  • [Chapter X]: [Section title] (+[N] words)                    ║
║  • [Chapter Y]: [Section title] (+[N] words)                    ║
║                                                                 ║
║  Citation added to bibliography: Yes                            ║
║  Reference archived: [Yes/No]                                   ║
║                                                                 ║
║  Next steps:                                                    ║
║  - Review changes: /author:chapter [N]                          ║
║  - Revise for tone: /author:revise [N] --tone                   ║
║  - Compile book: /author:compile                                ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

---

## Citation Formats

### Footnote (default for most books)

In chapter text:
```markdown
...this becomes your safety net.[^1]
```

At end of chapter or in back-matter:
```markdown
[^1]: Y Combinator, "How to Vibe Code," 2025. https://www.ycombinator.com/blog/vibe-coding
```

### Inline Parenthetical

```markdown
...this becomes your safety net (Y Combinator, 2025).
```

When presenting draft, ask user preference if not already established:
```
question: "What citation style do you prefer for this book?"
header: "Citations"
options:
  - "Footnotes (Recommended)" ([^1] style, common in trade books)
  - "Inline parenthetical" (Author, Year style, common in academic)
```

Store preference in `book/book.json` under `"citationStyle": "footnote"` or `"inline"`.

## Edge Cases

| Scenario | Handling |
|----------|----------|
| No H1 headings in bulk mode | Treat entire content as single chapter, prompt for title |
| Image has no extractable text | Describe visual content, ask user how to incorporate |
| URL returns 404 or paywall | Inform user, ask for alternative (paste content, different source) |
| Very long reference (>5000 words) | Summarize first, let user select which parts to weave |
| Reference doesn't fit any chapter | Offer to create new chapter, add to appendix, or skip |
| User rejects all proposals | Confirm, offer to archive reference for later |
| Duplicate of existing reference | Warn user, offer to add to existing citation or skip |
| Non-English content | Translate or summarize, confirm with user |
| Multiple distinct topics in one reference | Split into separate proposal items |
| Existing book/ project in bulk mode | Ask "Merge with existing?" or "Abort?" |
| Empty sections in bulk mode | Create placeholder files with `[Content to be added]` |

## Slugification Rules (Bulk Mode)

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

## Voice Matching Guidelines (Integration Mode)

Analyze existing chapters to detect:

| Aspect | Detection Method | Adaptation |
|--------|------------------|------------|
| Person | Count I/you/we/one usage | Match dominant pattern |
| Formality | Contractions, sentence structure | Mirror level |
| Sentence length | Average word count | Stay within ±20% |
| Technical depth | Jargon density | Match complexity |
| Examples | Presence of concrete illustrations | Include if pattern shows |
| Paragraph length | Average sentences per paragraph | Match rhythm |

## Relationship to Other Commands

- `/author:weave` - This command (context-aware: bulk scaffold or integration)
- `/author:chapter` - Write new content from scratch
- `/author:revise` - Polish woven content after the fact
