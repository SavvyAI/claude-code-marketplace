## Context

Revision operations for improving manuscript content.

## Purpose

Refine content at section, chapter, or manuscript scope. Supports clarity and tone revision modes.

**US-004:** Given existing Markdown content, when `/author:revise` with clarity mode is invoked, then meaning is preserved while improving readability.

**US-005:** Given a full manuscript, when tone alignment mode is selected, then stylistic consistency is improved.

## Arguments

- `<scope>` - Optional: chapter number, "manuscript", or omit for interactive
- `--clarity` - Focus on readability improvements
- `--tone` - Focus on stylistic consistency

## Examples

```
/author:revise 01 --clarity          # Revise chapter 01 for clarity
/author:revise manuscript --tone     # Align tone across manuscript
/author:revise                       # Interactive mode
```

## Your Task

### Step 1: Verify Project Exists

```bash
test -f book/book.json && echo "exists" || echo "missing"
```

If missing:
- Display: "No book project found. Run `/author:init` first."
- Exit

### Step 2: Determine Scope and Mode

Use `AskUserQuestion` if not provided via arguments:

```
question: "What scope should I revise?"
header: "Scope"
options:
  - "Current chapter" (single chapter)
  - "Selected chapters" (multiple)
  - "Entire manuscript" (all chapters)
```

```
question: "What type of revision?"
header: "Mode"
options:
  - "Clarity (Recommended)" (improve readability while preserving meaning)
  - "Tone alignment" (ensure consistent voice/style)
  - "Both" (clarity then tone)
```

### Step 3: Load Content

Based on scope:
- **Single chapter:** Read the chapter file
- **Multiple chapters:** Read selected chapter files
- **Manuscript:** Read all chapters in order

### Step 4: Clarity Revision

When revising for clarity:

**Principles:**
1. Preserve original meaning exactly
2. Simplify complex sentences
3. Remove unnecessary words
4. Improve paragraph flow
5. Clarify ambiguous references
6. Maintain author's voice

**Process:**
1. Analyze content for clarity issues:
   - Long sentences (>30 words)
   - Passive voice overuse
   - Jargon without context
   - Unclear pronoun references
   - Dense paragraphs (>150 words)

2. Apply targeted improvements
3. Show before/after for significant changes
4. Ask for confirmation before saving

**Output:**
```
[ writer:revise ]
------------------
Scope: Chapter 01 - Introduction
Mode: Clarity

Improvements made:
- 3 long sentences simplified
- 2 passive constructions made active
- 1 unclear reference clarified

Word count: 1,234 → 1,198 (-36 words, -2.9%)
Readability: Grade 12 → Grade 10

Preview of changes? [Y/n]
```

### Step 5: Tone Alignment

When aligning tone:

**Process:**
1. Analyze existing tone characteristics:
   - Formal vs informal
   - Technical vs accessible
   - Personal vs impersonal
   - Active vs passive tendency

2. Identify inconsistencies across chapters
3. Display tone profile:

```
[ writer:revise ]
------------------
Mode: Tone Analysis

Detected manuscript tone:
- Formality: Semi-formal (3/5)
- Technical depth: Moderate (2/5)
- Voice: Personal, first-person
- Typical sentence length: 18 words

Inconsistencies found:
- Chapter 03: More formal than average
- Chapter 07: Shifts to impersonal voice
- Chapter 12: Technical depth spikes

Apply tone normalization? [Y/n]
```

4. Apply normalization while preserving content meaning
5. Show summary of changes per chapter

### Step 6: Save Changes

After confirmation:

1. Write updated content to chapter files
2. Update `book/book.json` with:
   - `lastModified` timestamp
   - `wordCount` (updated)
3. Display completion summary

### Step 7: Revision History (Optional)

Create revision record in `book/book.json`:

```json
{
  "revisions": [
    {
      "timestamp": "2025-12-30T12:00:00Z",
      "scope": "chapter:01",
      "mode": "clarity",
      "wordCountBefore": 1234,
      "wordCountAfter": 1198
    }
  ]
}
```

## Revision Guidelines

### Clarity Mode Rules

| Issue | Action | Example |
|-------|--------|---------|
| Sentence >30 words | Split or simplify | "The quick brown fox, which had been running through the forest for hours because it was being chased by hunters, jumped over the lazy dog." → "The quick brown fox jumped over the lazy dog. It had been running for hours, fleeing hunters through the forest." |
| Passive voice | Convert to active | "The book was written by the author." → "The author wrote the book." |
| Redundancy | Remove | "completely finished" → "finished" |
| Jargon | Define or simplify | Add parenthetical explanation on first use |

### Tone Alignment Rules

| Aspect | Target | Adjustment |
|--------|--------|------------|
| Person | Match manuscript majority | Convert between I/we/one |
| Formality | Match detected level | Adjust contractions, word choice |
| Sentence structure | Normalize variation | Ensure consistent complexity |

## Edge Cases

- **No changes needed:** Inform user content already meets standards
- **Heavy revisions needed:** Warn user, suggest iterative approach
- **Technical content:** Be cautious with domain-specific terminology
- **Dialogue/quotes:** Preserve exactly (don't revise quoted speech)
