# Writer Plugin: Milestones & Progress Tracking

## Summary

Add milestone-based progress tracking to the Writer plugin that:
- Reflects real author decision points through **inferred milestones**
- Provides visibility into book lifecycle state via **read-only dashboards**
- Supports **configurable targets** with ranges (chapter count, word counts)
- Integrates with `/writer:init` via **book type selection**

## Design Principles

| Principle | Implication |
|-----------|-------------|
| **Milestones are inferred, not declared** | Status is computed from content, not explicit marking |
| **Author agency over automation** | No auto-locking, no magic. Author decides interpretation |
| **State is book identity** | Lives conceptually with book metadata |
| **Guidance without artifacts** | Warnings and context, not generated documents |
| **Ranges over absolutes** | Targets support min/max rather than fixed numbers |

## Command Surface

| Command | Purpose |
|---------|---------|
| `/writer:init` | Initialize project, select book type, set initial targets |
| `/writer:status` | Inferred milestone dashboard (read-only) |
| `/writer:targets` | View targets (alias for `.view`) |
| `/writer:targets.view` | Display targets vs. current progress |
| `/writer:targets.edit` | Modify targets interactively |

## Data Model

### Targets (stored in `book.json`)

```json
{
  "bookType": "business",
  "targets": {
    "chapters": { "min": 8, "max": 12 },
    "wordsPerChapter": { "min": 4000, "max": 6000 },
    "totalWords": { "min": 40000, "max": 60000 }
  }
}
```

### Book Type Defaults

| Book Type | Chapters | Words/Chapter | Total Words |
|-----------|----------|---------------|-------------|
| Business/Leadership | 8-12 | 4,000-6,000 | 40,000-60,000 |
| Technical Manual | 15-25 | 3,000-5,000 | 60,000-100,000 |
| Field Guide | 5-10 | 3,000-5,000 | 20,000-40,000 |
| Memoir | 12-20 | 4,000-6,000 | 60,000-80,000 |
| Academic | 8-12 | 6,000-10,000 | 80,000-100,000 |

## Milestone Definitions

Milestones are **inferred from content**, not explicitly marked. Each milestone has detection criteria:

### 1. thesis-locked
**Central argument and scope are settled**

Inference signals:
- `book/front-matter/thesis.md` exists with content > 100 words, OR
- `book.json` contains a `thesis` field with content, OR
- First chapter contains a clear thesis statement (H2 "Thesis" or similar)

### 2. frame-locked
**Book identity, tone, and posture are established**

Inference signals:
- `book.json` contains `bookType` field
- Front matter includes preface or introduction with > 500 words
- Consistent voice across 2+ chapters (analyzed via tone fingerprinting)

### 3. outline-locked
**Chapter structure and ordering are stable**

Inference signals:
- Number of chapters >= target min
- All chapters have titles (first H1 heading)
- No placeholder chapters (detect "[TBD]", "[TODO]", empty files)

### 4. how-to-read-locked
**Reader expectations are explicitly set**

Inference signals:
- Front matter contains "How to Read" section, OR
- Preface/introduction explains reading approach, OR
- `book.json` contains `readingGuide` field

### 5. sample-chapters-exist
**2-3 representative chapters are fully drafted**

Inference signals:
- At least 2 chapters with word count >= 80% of target min
- Chapters have substantive content (not just headings)

### 6. pitch-ready
**Sufficient for publisher outreach**

Inference signals:
- thesis-locked = true
- outline-locked = true
- sample-chapters-exist = true
- Front/back matter structure exists

### 7. manuscript-complete
**All chapters drafted**

Inference signals:
- Number of chapters within target range
- All chapters have word count >= target min
- No placeholder content detected

### 8. production-ready
**Ready for print/digital distribution**

Inference signals:
- manuscript-complete = true
- Compiled outputs exist in `book/dist/`
- Front matter complete (title, copyright, TOC)
- Back matter complete (if applicable)

## Implementation Steps

### Phase 1: Schema & Storage

1. Update `book.json` schema to include:
   - `bookType` field
   - `targets` object with ranges

2. Document schema changes in CLAUDE.md

### Phase 2: Init Enhancement

1. Add book type question to `/writer:init`
2. Infer defaults from book type
3. Allow user to accept or customize
4. Store in `book.json`

### Phase 3: Targets Commands

1. Create `/writer:targets.view` command
   - Read `book.json` targets
   - Analyze current content (chapter count, word counts)
   - Display progress vs. targets

2. Create `/writer:targets.edit` command
   - Interactive modification of targets
   - Option to re-select book type

3. Create `/writer:targets` alias

### Phase 4: Status Command

1. Create `/writer:status` command
   - Read targets and content
   - Apply milestone inference rules
   - Display dashboard with:
     - Current progress metrics
     - Milestone status (reached / not reached)
     - Next milestone and why it matters

### Phase 5: Integration

1. Other commands can invoke status for contextual warnings
2. Document skill architecture for cross-command access

## Example Outputs

### `/writer:status`

```
╔══════════════════════════════════════════════════════════════╗
║  BOOK STATUS: "The Field Manual for AI Practitioners"        ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  PROGRESS                                                     ║
║  ─────────────────────────────────────────────────────────── ║
║  Chapters:        6 of 8-10     ████████░░  75%              ║
║  Words/Chapter:   avg 4,200     (in range ✓)                 ║
║  Total Words:     25,200        ██████░░░░  63%              ║
║                                                               ║
║  MILESTONES                                                   ║
║  ─────────────────────────────────────────────────────────── ║
║  ✓ Thesis locked                                              ║
║  ✓ Frame locked                                               ║
║  ✓ Outline locked                                             ║
║  ○ How-to-read section        ← not detected                  ║
║  ✓ Sample chapters exist       (3 chapters at target depth)   ║
║  ○ Pitch-ready                 ← missing how-to-read          ║
║  ○ Manuscript complete                                        ║
║  ○ Production-ready                                           ║
║                                                               ║
║  NEXT: Add a "How to Read This Book" section to front matter ║
║        This helps publishers understand reader experience.    ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

### `/writer:targets.view`

```
╔══════════════════════════════════════════════════════════════╗
║  TARGETS: Field Guide                                         ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  Target              Range         Current       Status       ║
║  ─────────────────────────────────────────────────────────── ║
║  Chapters            5-10          6             ✓ in range   ║
║  Words/Chapter       3,000-5,000   avg 4,200     ✓ in range   ║
║  Total Words         20,000-40,000 25,200        ✓ in range   ║
║                                                               ║
║  Use /writer:targets.edit to modify                           ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

## Files to Create/Modify

| File | Action | Description |
|------|--------|-------------|
| `writer/commands/status.md` | Create | Status dashboard command |
| `writer/commands/targets.md` | Create | Targets view command |
| `writer/commands/targets.edit.md` | Create | Targets edit command |
| `writer/commands/init.md` | Modify | Add book type selection |
| `writer/CLAUDE.md` | Modify | Document new commands and schema |
| `doc/decisions/028-writer-milestone-tracking.md` | Create | ADR for design decisions |

## Open Questions

None - design is confirmed.

## Related ADRs

- ADR-023: Writer Plugin Multi-Plugin Architecture
- ADR-024: Writer Import Command
- ADR-025: Writer Weave Command
- ADR-018: MVP Cut Line with MoSCoW (pattern reference)
