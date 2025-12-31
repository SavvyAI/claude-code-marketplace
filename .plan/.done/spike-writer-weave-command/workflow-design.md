# /writer:weave Workflow Design

## Overview

Incorporate external reference material into a book project through a collaborative, iterative workflow.

## Input Types Supported

| Type | Detection | Extraction Method |
|------|-----------|-------------------|
| Pasted text | No file path, raw text | Direct use |
| Screenshot/Image | File extension (.png, .jpg, etc.) or inline image | OCR via Claude vision |
| PDF | File extension (.pdf) | Claude PDF reading |
| URL | Starts with http(s):// | WebFetch + content extraction |
| Markdown file | File extension (.md) | Direct read |
| Any text file | File extension | Direct read |

## Workflow Phases

### Phase 1: Intake

```
User: /writer:weave [optional: file path, URL, or pasted content]
```

If no argument provided, ask:
```
question: "What reference material would you like to weave?"
header: "Source"
options:
  - "Paste text or markdown" → freeform input
  - "Upload or provide file path" → file picker guidance
  - "Provide a URL" → freeform URL input
```

**Extraction:**
- For images: Use Claude's vision to extract text and describe visual elements
- For PDFs: Read and extract structured content
- For URLs: Fetch page, extract main content, strip nav/ads
- For text: Use as-is

**Output:**
```
[ writer:weave | intake ]
-------------------------
Extracted from: screenshot (YC guide to vibe coding)
Content type: Structured notes (4 sections, 22 bullet points)

Preview:
─────────────────────────────────────────
Planning process
• Create a comprehensive plan: Start by working with the AI...
• Review and refine: Delete unnecessary items...
[truncated for brevity]
─────────────────────────────────────────

Is this content extracted correctly? [Y/n]
```

### Phase 2: Source Verification (Optional)

```
question: "Should I try to find and verify the original source?"
header: "Verify"
options:
  - "Yes, find the source" → Web search for original
  - "Yes, verify claims" → Research specific claims
  - "No, trust this source" → Skip verification
```

If verification requested:
```
[ writer:weave | verifying ]
----------------------------
Searching for original source...

Found: "How to Vibe Code" - Y Combinator blog post
URL: https://www.ycombinator.com/blog/vibe-coding
Published: 2025-01-15
Author: YC Team

Verification notes:
• Content matches original source
• Additional context available (full article is longer)

Store this source for citation? [Y/n]
```

### Phase 3: Analysis

Read book structure:
```bash
cat book/book.json
ls book/chapters/
```

Analyze themes in reference material against book structure:

```
[ writer:weave | analysis ]
---------------------------
Reference themes identified:
1. AI-assisted planning workflows
2. Version control with AI tools
3. Testing strategies for AI-generated code
4. Debugging approaches with AI

Your book structure:
├── 01-introduction.md (Introduction to Vibe Coding)
├── 02-getting-started.md (Getting Started)
├── 03-planning.md (Planning Your Project)
├── 04-implementation.md (Implementation Patterns)
└── 05-debugging.md (Debugging and Troubleshooting)

Theme mapping:
• "Planning process" → Chapter 03 (strong fit)
• "Version control" → Chapter 04 (moderate fit)
• "Testing framework" → New section in Ch04 or new chapter
• "Bug fixing" → Chapter 05 (strong fit)
```

### Phase 4: Proposal

Present a concrete proposal for what to weave and where:

```
[ writer:weave | proposal ]
---------------------------

PROPOSAL: Weave YC Vibe Coding Guide

I recommend incorporating the following:

┌─────────────────────────────────────────────────────────────────┐
│ 1. "Planning process" → Chapter 03: Planning Your Project       │
│    ──────────────────────────────────────────────────────────   │
│    Transform: Expand 6 bullets into ~300 word section           │
│    Placement: New subsection "## AI-Assisted Planning"          │
│    Rationale: Direct thematic match, fills gap in current ch.   │
│                                                                  │
│    [ ] Include   [ ] Skip   [ ] Discuss                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ 2. "Version control strategies" → Chapter 04: Implementation    │
│    ──────────────────────────────────────────────────────────   │
│    Transform: Synthesize key principles into ~200 words         │
│    Placement: Add to existing "## Git Workflow" section         │
│    Rationale: Complements existing content on Git               │
│                                                                  │
│    [ ] Include   [ ] Skip   [ ] Discuss                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ 3. "Testing framework" → NEW SECTION                            │
│    ──────────────────────────────────────────────────────────   │
│    Transform: Create new ~400 word section on testing with AI   │
│    Placement: New "## Testing AI-Generated Code" in Chapter 04  │
│    Rationale: Missing coverage, important topic                 │
│                                                                  │
│    [ ] Include   [ ] Skip   [ ] Discuss                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ 4. "Effective bug fixing" → Chapter 05: Debugging               │
│    ──────────────────────────────────────────────────────────   │
│    Transform: Merge with existing debugging content (~150 words)│
│    Placement: Enhance existing "## Debugging Strategies"        │
│    Rationale: Overlaps with existing, adds AI-specific tips     │
│                                                                  │
│    [ ] Include   [ ] Skip   [ ] Discuss                         │
└─────────────────────────────────────────────────────────────────┘

Total estimated addition: ~1,050 words across 3 chapters

How would you like to proceed?
```

### Phase 5: Dialogue

User can:
- **Include** items as proposed
- **Skip** items they don't want
- **Discuss** items to explore further

For "Discuss":
```
User: Let's discuss the testing framework section

Claude: The reference mentions 5 key testing principles:

1. "Prioritize high-level tests" - Focus on e2e over unit tests
2. "Simulate user behavior" - Test like a real user would
3. "Catch regressions" - LLMs often make unintended changes
4. "Test before proceeding" - Gate progression on passing tests
5. "Use tests as guardrails" - Start with test cases

Your book currently has no dedicated testing section. I see two options:

A) Create a new chapter "Testing Vibe Code" (more comprehensive)
B) Add a meaty section to Chapter 04 (keeps book concise)

Which approach resonates with your vision for the book?

[User responds, dialogue continues until decision is made]
```

### Phase 6: Draft

For each approved item, generate woven content:

```
[ writer:weave | drafting ]
---------------------------

Drafting: "AI-Assisted Planning" for Chapter 03

SUMMARY:
• Adding new subsection after "## Defining Your Project Scope"
• 287 words (6 bullet points → prose)
• Incorporates citation to YC source
• Written in your book's voice (detected: conversational, second-person)

DRAFT:
─────────────────────────────────────────
## AI-Assisted Planning

Before you write a single line of code, invest time in planning with
your AI assistant. This isn't the waterfall-style documentation of old—
it's a collaborative conversation that produces a living plan.

Start by asking the AI to help you create a comprehensive implementation
plan as a markdown file. This becomes your north star. But here's the key:
don't accept the first draft. Review it critically. Delete items that feel
unnecessary. Mark complex features as "won't do" for now. Keep a separate
section for "later" ideas so you don't lose them but also don't get
distracted by them.

The magic is in working incrementally. Rather than trying to build
everything at once, work section by section. After each section is
successfully implemented, have the AI mark it complete. This gives you
momentum and a clear sense of progress.

And please, commit regularly. Each working section should be committed to
Git before moving to the next. This isn't just good hygiene—it's your
safety net. When the AI inevitably goes on a "vision quest" (their words,
not mine), you can reset to your last good state without losing hours of
work.[^1]

[^1]: Y Combinator, "How to Vibe Code," 2025.
─────────────────────────────────────────

CONTEXT (surrounding content):
[Previous section ending...]
...and that's how you define your project scope.

[YOUR NEW SECTION WOULD GO HERE]

[Next section beginning...]
## Breaking Down the Work
Once you have your plan...

─────────────────────────────────────────

Approve this draft? [Y/n/edit]
```

### Phase 7: Refinement

If user wants changes:
```
User: Can you make it less casual? I want it more professional.

Claude: [Re-drafts with more formal tone]

User: The footnote feels awkward. Can we use inline citation?

Claude: [Changes to inline format: "...according to Y Combinator (2025)"]
```

Loop continues until user approves.

### Phase 8: Commit

Once all items approved:

```
[ writer:weave | committing ]
-----------------------------

Writing changes:

✓ book/chapters/03-planning.md
  Added: "## AI-Assisted Planning" (287 words)

✓ book/chapters/04-implementation.md
  Updated: "## Git Workflow" (+156 words)
  Added: "## Testing AI-Generated Code" (412 words)

✓ book/chapters/05-debugging.md
  Updated: "## Debugging Strategies" (+134 words)

✓ book/references/ref-001-yc-vibe-coding.md
  Archived reference with metadata

✓ book/back-matter/bibliography.md
  Added citation entry

✓ book/book.json
  Updated word counts and lastModified

Total additions: 989 words across 3 chapters

Commit these changes? [Y/n]
```

## Data Structures

### Reference Storage (book/references/)

For important references (user opts to archive):

```
book/references/
├── ref-001-yc-vibe-coding.md
└── references.json
```

**ref-001-yc-vibe-coding.md:**
```markdown
---
id: ref-001
title: "How to Vibe Code"
author: Y Combinator
url: https://www.ycombinator.com/blog/vibe-coding
accessed: 2025-12-30
type: article
archived: true
---

# How to Vibe Code

[Full extracted content here]
```

**references.json:**
```json
{
  "references": [
    {
      "id": "ref-001",
      "title": "How to Vibe Code",
      "author": "Y Combinator",
      "url": "https://www.ycombinator.com/blog/vibe-coding",
      "accessed": "2025-12-30",
      "type": "article",
      "archived": true,
      "usedIn": ["03-planning.md", "04-implementation.md", "05-debugging.md"]
    }
  ]
}
```

### Citation Formats

**Footnote style (default for books):**
```markdown
...your safety net.[^1]

[^1]: Y Combinator, "How to Vibe Code," 2025. https://www.ycombinator.com/blog/vibe-coding
```

**Inline parenthetical:**
```markdown
...your safety net (Y Combinator, 2025).
```

**Bibliography entry (book/back-matter/bibliography.md):**
```markdown
## Bibliography

Y Combinator. "How to Vibe Code." Y Combinator Blog, 2025.
https://www.ycombinator.com/blog/vibe-coding
```

## Edge Cases

| Scenario | Handling |
|----------|----------|
| No book project exists | Error: "Run /writer:init first" |
| Reference doesn't match any chapter | Offer to create new chapter or skip |
| Image with no text | Describe visual elements, ask how to use |
| URL is paywalled | Inform user, ask for pasted content instead |
| Very long reference | Summarize first, offer to expand sections |
| Duplicate reference | Warn, offer to skip or add to existing citation |
| User rejects all proposals | Confirm, offer to keep reference for later |
| Source can't be verified | Proceed without verification, note uncertainty |

## Voice Matching

Before drafting, analyze existing chapter content to detect:
- Person (first, second, third)
- Formality level
- Sentence complexity
- Use of examples
- Technical depth

Apply detected voice to woven content.

## Integration with Other Commands

- `/writer:import` - One-time bulk import, no discussion
- `/writer:weave` - Iterative incorporation with dialogue
- `/writer:revise` - Post-weave refinement if needed
- `/writer:chapter` - Can be used to expand woven sections later
