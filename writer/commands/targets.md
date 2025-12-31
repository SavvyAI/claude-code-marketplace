---
description: "View targets? → Shows current vs. actual → Progress at a glance"
allowed-tools:
  - Bash
  - Read
  - Glob
---

## Context

Display current book targets compared to actual progress.

This is an alias for `/writer:targets.view`.

## Purpose

Help authors see their goals and current progress at a glance.

**Given** an initialized book project
**When** `/writer:targets` is invoked
**Then** targets and current metrics are displayed

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
- `bookType` (default: "general" if not set)
- `targets` (use defaults if not set)

### Step 3: Calculate Current Metrics

**Chapters:**
- Count files in `book/chapters/` matching `*.md`

**Words per Chapter:**
- Calculate word count for each chapter
- Compute average

**Total Words:**
- Sum all chapter word counts

### Step 4: Determine Status for Each Target

For each target, compare current value to range:
- `✓ in range` - min <= current <= max
- `↓ below` - current < min
- `↑ above` - current > max

### Step 5: Display Targets Table

```
╔══════════════════════════════════════════════════════════════╗
║  TARGETS: <Book Type>                                         ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Target              Range           Current       Status     ║
║  ─────────────────────────────────────────────────────────── ║
║  Chapters            <min>-<max>     <N>           <status>  ║
║  Words/Chapter       <min>-<max>     avg <N>       <status>  ║
║  Total Words         <min>-<max>     <N>           <status>  ║
║                                                               ║
║  Use /writer:targets.edit to modify                           ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

## Default Targets by Book Type

| Book Type | Chapters | Words/Chapter | Total Words |
|-----------|----------|---------------|-------------|
| business | 8-12 | 4,000-6,000 | 40,000-60,000 |
| technical | 15-25 | 3,000-5,000 | 60,000-100,000 |
| field-guide | 5-10 | 3,000-5,000 | 20,000-40,000 |
| memoir | 12-20 | 4,000-6,000 | 60,000-80,000 |
| academic | 8-12 | 6,000-10,000 | 80,000-100,000 |
| general | 10-15 | 4,000-6,000 | 50,000-75,000 |

## Edge Cases

- **No targets in manifest:** Use defaults based on `bookType`
- **No bookType in manifest:** Use "general" defaults
- **Empty chapters:** Count as 0 words
