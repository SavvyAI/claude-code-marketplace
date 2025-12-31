---
description: "Reference material to weave? → Analyze, verify, propose placement → Collaborative dialogue until approved"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "WebSearch", "WebFetch", "AskUserQuestion"]
---

## Context

Weave reference material: $ARGUMENTS

## Purpose

Incorporate external reference material into a book project through collaborative, iterative dialogue. Supports pasted text, images/screenshots, PDFs, URLs, and file paths.

**Given** reference material (any format)
**When** `/writer:weave` is invoked
**Then** material is analyzed, verified (optionally), and woven into appropriate chapters with citations

## Arguments

- `<input>` - Optional: file path, URL, or pasted content

## Examples

```
/writer:weave                              # Interactive mode
/writer:weave screenshot.png               # Weave from screenshot
/writer:weave https://example.com/article  # Weave from URL
/writer:weave notes.md                     # Weave from file
/writer:weave "The key insight is..."      # Weave pasted content
```

## Your Task

### Step 1: Verify Book Project Exists

```bash
test -f book/book.json && echo "exists" || echo "missing"
```

If missing:
- Display: "No book project found. Run `/writer:init` first."
- Exit

### Step 2: Intake - Collect Reference Material

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

### Step 3: Extract Content

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
[ writer:weave | intake ]
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

### Step 4: Source Verification (Optional)

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
[ writer:weave | source ]
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

### Step 5: Load Book Structure

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

### Step 6: Analyze Themes and Match to Structure

Identify distinct themes/topics in the reference material.

For each theme, determine:
1. Does it match an existing chapter? (strong/moderate/weak fit)
2. Does it fill a gap in existing content?
3. Would it warrant a new section or chapter?

Present analysis:
```
[ writer:weave | analysis ]
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

### Step 7: Present Proposal

For each theme/section of the reference material, present a concrete proposal:

```
[ writer:weave | proposal ]
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

### Step 8: Dialogue Phase

**For "Let's discuss":**

Enter conversational mode. The user may:
- Ask for more detail about the reference content
- Request alternative placement options
- Ask Claude to expound on a topic
- Suggest a different transformation approach
- Ask about how it relates to existing content

Respond naturally to questions. Use `WebSearch` if the user wants more information on a topic.

Continue dialogue until user makes a decision (include, skip, or modified include).

### Step 9: Draft Woven Content

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
[ writer:weave | draft ]
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

### Step 10: Refinement Loop

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

### Step 11: Store Reference (Conditional)

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

### Step 12: Commit Changes

Display summary of all changes:
```
[ writer:weave | committing ]
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

### Step 13: Display Completion

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
║  - Review changes: /writer:chapter [N]                          ║
║  - Revise for tone: /writer:revise [N] --tone                   ║
║  - Compile book: /writer:compile                                ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

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
| Image has no extractable text | Describe visual content, ask user how to incorporate |
| URL returns 404 or paywall | Inform user, ask for alternative (paste content, different source) |
| Very long reference (>5000 words) | Summarize first, let user select which parts to weave |
| Reference doesn't fit any chapter | Offer to create new chapter, add to appendix, or skip |
| User rejects all proposals | Confirm, offer to archive reference for later |
| Duplicate of existing reference | Warn user, offer to add to existing citation or skip |
| Non-English content | Translate or summarize, confirm with user |
| Multiple distinct topics in one reference | Split into separate proposal items |

## Voice Matching Guidelines

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

- `/writer:import` - One-time bulk structural import (no dialogue)
- `/writer:weave` - Iterative incorporation with full dialogue
- `/writer:chapter` - Write new content from scratch
- `/writer:revise` - Polish woven content after the fact
