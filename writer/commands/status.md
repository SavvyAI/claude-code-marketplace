---
description: "Book progress? → Shows milestone dashboard → Inferred from content"
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
---

## Context

Display a read-only dashboard showing book progress against targets and inferred milestone status.

## Purpose

Help authors understand where they are in the book lifecycle without explicit tracking.

**Given** an initialized book project
**When** `/writer:status` is invoked
**Then** a dashboard shows progress metrics and milestone status

## Your Task

### Step 1: Verify Book Project Exists

```bash
ls book/book.json 2>/dev/null
```

If no `book.json`:
- Display: "No book project found. Use `/writer:init` to create one."
- Exit

### Step 2: Load Book Manifest

Read `book/book.json` and extract:
- `title`
- `author`
- `bookType` (default: "general" if not set)
- `targets` (use defaults if not set)
- `chapters` array
- `frontMatter` array
- `backMatter` array

### Step 3: Calculate Progress Metrics

**Chapter Count:**
- Count files in `book/chapters/` matching `*.md`
- Compare to `targets.chapters.min` and `targets.chapters.max`

**Word Counts:**
- For each chapter, count words (exclude markdown syntax)
- Calculate average words per chapter
- Calculate total words
- Compare to targets

**Progress Percentage:**
- Use midpoint of target range as 100%
- Cap at 100% if exceeded

### Step 4: Infer Milestone Status

Apply these inference rules sequentially:

#### 4.1 thesis-locked
Check if ANY of these exist:
- `book/front-matter/thesis.md` with > 100 words
- `book.json` has `thesis` field with content
- Any front-matter file contains H2 "## Thesis" with content

#### 4.2 frame-locked
Check if ALL of these are true:
- `book.json` has `bookType` field
- Front matter includes preface OR introduction with > 500 words

#### 4.3 outline-locked
Check if ALL of these are true:
- Chapter count >= `targets.chapters.min`
- All chapter files have a first H1 heading (title)
- No chapter contains placeholder markers: `[TBD]`, `[TODO]`, `[PLACEHOLDER]`, `<!-- TODO`

#### 4.4 how-to-read-locked
Check if ANY of these exist:
- `book/front-matter/how-to-read.md` exists with content
- Any front-matter file contains H2 "## How to Read"
- `book.json` has `readingGuide` field

#### 4.5 sample-chapters-exist
Check if:
- At least 2 chapters have word count >= 80% of `targets.wordsPerChapter.min`

#### 4.6 pitch-ready
Check if ALL of these are true:
- thesis-locked = true
- outline-locked = true
- sample-chapters-exist = true

#### 4.7 manuscript-complete
Check if ALL of these are true:
- Chapter count is within target range (min <= count <= max)
- All chapters have word count >= `targets.wordsPerChapter.min`
- No placeholder content detected

#### 4.8 production-ready
Check if ALL of these are true:
- manuscript-complete = true
- `book/dist/` contains at least one output directory with files
- `book/front-matter/title.md` exists
- Front matter is complete (title page exists)

### Step 5: Determine Next Milestone

Find the first milestone that is NOT reached:
1. If not thesis-locked → suggest adding thesis
2. If not frame-locked → suggest completing preface/introduction
3. If not outline-locked → suggest completing chapter structure
4. If not how-to-read-locked → suggest adding reading guide
5. If not sample-chapters-exist → suggest drafting 2+ chapters to target depth
6. If not pitch-ready → identify which prerequisite is missing
7. If not manuscript-complete → suggest completing remaining chapters
8. If not production-ready → suggest running `/writer:compile`
9. If all reached → "Your book is production-ready!"

### Step 6: Display Dashboard

```
╔══════════════════════════════════════════════════════════════╗
║  BOOK STATUS: "<title>"                                       ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  PROGRESS                                                     ║
║  ─────────────────────────────────────────────────────────── ║
║  Chapters:        <N> of <min>-<max>     <bar>  <pct>%       ║
║  Words/Chapter:   avg <N>                <status>            ║
║  Total Words:     <N>                    <bar>  <pct>%       ║
║                                                               ║
║  MILESTONES                                                   ║
║  ─────────────────────────────────────────────────────────── ║
║  <✓|○> Thesis locked           <annotation if relevant>      ║
║  <✓|○> Frame locked                                          ║
║  <✓|○> Outline locked                                        ║
║  <✓|○> How-to-read section                                   ║
║  <✓|○> Sample chapters exist                                 ║
║  <✓|○> Pitch-ready                                           ║
║  <✓|○> Manuscript complete                                   ║
║  <✓|○> Production-ready                                      ║
║                                                               ║
║  NEXT: <guidance for next milestone>                         ║
║        <why it matters>                                       ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

**Progress bar format:**
- Use block characters: `████████░░` (filled vs empty)
- 10 characters total
- Round to nearest 10%

**Status annotations:**
- `✓ in range` - value is within target range
- `↓ below` - value is below target min
- `↑ above` - value is above target max

### Step 7: Provide Contextual Guidance

Based on current milestone status, provide relevant warnings:

**If pitch-ready but not thesis-locked:**
> "Consider solidifying your thesis before pitching. Publishers want clarity on the book's promise."

**If manuscript-complete but how-to-read is missing:**
> "A 'How to Read' section helps readers (and publishers) understand the book's structure."

**If sample-chapters-exist but outline not locked:**
> "Your sample chapters are strong. Consider stabilizing the overall chapter structure."

## Default Targets

If `targets` not set in `book.json`, use these defaults based on `bookType`:

| Book Type | Chapters | Words/Chapter | Total Words |
|-----------|----------|---------------|-------------|
| business | 8-12 | 4,000-6,000 | 40,000-60,000 |
| technical | 15-25 | 3,000-5,000 | 60,000-100,000 |
| field-guide | 5-10 | 3,000-5,000 | 20,000-40,000 |
| memoir | 12-20 | 4,000-6,000 | 60,000-80,000 |
| academic | 8-12 | 6,000-10,000 | 80,000-100,000 |
| general | 10-15 | 4,000-6,000 | 50,000-75,000 |

## Word Counting Rules

When counting words in chapters:
1. Strip YAML front matter (between `---` markers)
2. Strip fenced code blocks (between ``` markers)
3. Strip HTML comments (`<!-- ... -->`)
4. Strip markdown syntax (headers, emphasis, list markers, blockquotes)
5. For links, count only the link text (not the URL)
6. For images, count only the alt text
7. Tokenize on whitespace and count tokens

**Progress Percentage Formula:**
```
midpoint = (target.min + target.max) / 2
progress = min(actual / midpoint, 1.0) * 100
```

Example: Target 40,000-60,000 words, current 45,000 words
- Midpoint = 50,000
- Progress = min(45000/50000, 1.0) = 90%

## Placeholder Detection

Placeholder markers are detected case-insensitively:
- `[TBD]`, `[TODO]`, `[PLACEHOLDER]`, `[STUB]`

**Ignored contexts:**
- Inside fenced code blocks
- Inside inline code spans
- Inside HTML comments

Example: `[TODO]` in normal text → detected as placeholder
Example: `` `[TODO]` `` in inline code → ignored

## Front Matter Detection

A file qualifies as preface/introduction if:
1. **Filename match** (case-insensitive): `preface.md`, `introduction.md`, `preface-*.md`, `*-preface.md`
2. **OR first H1 heading** contains "Preface" or "Introduction" (case-insensitive)

Search locations: `book/front-matter/`

Word count threshold (500 words) is counted after stripping front matter and markdown syntax.

## Edge Cases

- **No targets set:** Use defaults based on `bookType` (or "general" if not set)
- **Empty chapters:** Chapters with 0 words count as placeholders
- **Mixed content:** Front matter files are not counted in chapter metrics
- **Compiled outputs:** Only check existence, not validity
- **Source of truth:** Disk files are authoritative; `book.json` chapter list is informational
- **Missing chapters directory:** Treat as 0 chapters
- **Unreadable files:** Log warning and skip (treat as 0 words)
