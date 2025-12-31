---
description: "Change targets? → Interactive editing → Updates book.json"
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
---

## Context

Interactively modify book targets (chapter count, word counts).

## Purpose

Allow authors to adjust their goals as the book evolves.

**Given** an initialized book project
**When** `/writer:targets.edit` is invoked
**Then** targets are updated in `book.json`

## Your Task

### Step 1: Verify Book Project Exists

```bash
ls book/book.json 2>/dev/null
```

If no `book.json`:
- Display: "No book project found. Use `/writer:init` to create one."
- Exit

### Step 2: Load Current State

Read `book/book.json` and extract:
- `bookType` (default: "general" if not set)
- `targets` (use defaults based on bookType if not set)

**Default targets when not set (based on "general" book type):**
```json
{
  "chapters": { "min": 10, "max": 15 },
  "wordsPerChapter": { "min": 4000, "max": 6000 },
  "totalWords": { "min": 50000, "max": 75000 }
}
```

### Step 3: Show Current Targets

Display current targets before editing:

```
Current targets (<bookType>):
- Chapters: <min>-<max>
- Words/Chapter: <min>-<max>
- Total Words: <min>-<max>
```

### Step 4: Ask What to Edit

Use `AskUserQuestion`:

```
question: "What would you like to change?"
header: "Edit"
options:
  - "Change book type" (re-select book type to reset all targets)
  - "Edit chapter count" (modify chapter range)
  - "Edit word counts" (modify per-chapter and total word targets)
  - "Edit all targets" (modify everything)
multiSelect: false
```

### Step 5A: Change Book Type

If "Change book type" selected:

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

Map selection to `bookType`:
- "Business/Leadership" → "business"
- "Technical Manual" → "technical"
- "Field Guide" → "field-guide"
- "Memoir" → "memoir"
- "Academic" → "academic"
- "General" → "general"

Apply defaults for selected type.

### Step 5B: Edit Chapter Count

If "Edit chapter count" selected:

```
question: "What is your target chapter count range?"
header: "Chapters"
options:
  - "5-10 chapters" (short book)
  - "8-12 chapters" (standard)
  - "12-20 chapters" (longer book)
  - "15-25 chapters" (comprehensive)
multiSelect: false
```

Note: User can always select "Other" to provide a custom range in format `min-max` (e.g., "6-8").

### Step 5C: Edit Word Counts

If "Edit word counts" selected, ask two questions:

```
question: "What is your target words per chapter?"
header: "Per Chapter"
options:
  - "2,000-4,000" (shorter chapters)
  - "3,000-5,000" (standard)
  - "4,000-6,000" (longer chapters)
  - "6,000-10,000" (academic depth)
multiSelect: false
```

```
question: "What is your total word count target?"
header: "Total"
options:
  - "20,000-40,000" (short book)
  - "40,000-60,000" (standard)
  - "60,000-80,000" (longer book)
  - "80,000-100,000" (comprehensive)
multiSelect: false
```

Note: User can always select "Other" to provide a custom range in format `min-max` (e.g., "50000-70000").

### Step 5D: Edit All Targets

If "Edit all targets" selected:
- Run Step 5A (book type) first
- Then ask: "Do you want to customize the defaults?"
- If "No": Apply book type defaults immediately and continue to Step 6
- If "Yes": Run Steps 5B and 5C to customize

### Step 6: Update book.json

Update the manifest with new values:

```json
{
  "bookType": "<selected type>",
  "targets": {
    "chapters": { "min": <N>, "max": <N> },
    "wordsPerChapter": { "min": <N>, "max": <N> },
    "totalWords": { "min": <N>, "max": <N> }
  }
}
```

### Step 7: Display Confirmation

```
╔══════════════════════════════════════════════════════════════╗
║  TARGETS UPDATED                                              ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Book Type:        <type>                                     ║
║                                                               ║
║  Chapters:         <min>-<max>                                ║
║  Words/Chapter:    <min>-<max>                                ║
║  Total Words:      <min>-<max>                                ║
║                                                               ║
║  Use /writer:status to see progress against these targets    ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

## Edge Cases

- **Custom range format:** Accept formats like "8-12", "8 - 12", "8 to 12"
- **Invalid range:** If min > max, swap them
- **Preserving other fields:** Only update `bookType` and `targets`; preserve all other manifest fields
