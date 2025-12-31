# 028. Writer Milestone Tracking Design

Date: 2025-12-31

## Status

Accepted

## Context

The Writer plugin excels at local execution (drafting, structuring, compiling), but lacked a way to track macro-level progress through a book's lifecycle. This created two problems:

1. Progress feels amorphous even when real work is happening
2. There is no explicit signal for when the project is ready for external leverage (pitching to publishers, seeking an advance, initiating agent conversations)

Books are not linear task lists. They move through distinct phases of thinking, authority explanation, and leverage. The plugin should reflect that reality.

Key design questions:
1. Should milestones be explicitly declared or inferred from content?
2. Should there be a "lock" mechanism for milestones?
3. How should targets (chapter count, word counts) be configured?
4. Should the plugin generate pitch artifacts automatically?

## Decision

### 1. Milestones Are Inferred, Not Declared

Milestone status is computed from content analysis, not explicit author marking. The plugin examines files, word counts, and structure to determine which milestones have been reached.

**Rationale:**
- Reduces ceremony and manual tracking burden
- Status reflects reality, not aspirations
- Author can focus on writing, not updating status fields

### 2. No Locking Mechanism

There is no "lock" action for milestones. Status is read-only and computed on demand.

**Rationale:**
- "Lock" implies irreversibility, which doesn't match book authoring reality
- Authors may change thesis, restructure outlines, etc.
- Locking adds friction without clear benefit
- The goal is awareness, not enforcement

### 3. Configurable Targets with Ranges

Book targets (chapter count, word counts) are configurable and support ranges (min-max) rather than fixed numbers.

**Schema:**
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

**Rationale:**
- Ranges better match how authors think about goals
- Different book types have different norms
- Defaults can be inferred from book type selection

### 4. Book Type Selection During Init

`/writer:init` asks "What type of book are you writing?" and infers sensible defaults for that type. Authors can accept or customize.

**Book Types:**
- Business/Leadership (40-60k words, 8-12 chapters)
- Technical Manual (60-100k words, 15-25 chapters)
- Field Guide (20-40k words, 5-10 chapters)
- Memoir (60-80k words, 12-20 chapters)
- Academic (80-100k words, 8-12 chapters)
- General (50-75k words, 10-15 chapters)

### 5. No Automatic Artifact Generation

The "pitch-ready" milestone is state only. No pitch decks, proposals, or other documents are auto-generated.

**Rationale:**
- Preserves author agency
- Avoids "automation theater"
- Authors should create pitch materials intentionally

### 6. Command Structure

New commands:
- `/writer:status` - Read-only dashboard showing progress and milestone status
- `/writer:targets` - Alias for `/writer:targets.view`
- `/writer:targets.view` - Display targets vs. current metrics
- `/writer:targets.edit` - Modify targets interactively

## Consequences

### Positive

- **Clarity without ceremony** - Authors see where they are without manual tracking
- **Domain-appropriate defaults** - Book type selection provides sensible starting points
- **Flexibility** - Targets can be customized; ranges accommodate variation
- **Leverage awareness** - Authors know when they're pitch-ready without premature signaling
- **No workflow disruption** - Existing commands continue to work; status is additive

### Negative

- **Inference may not match author intent** - Computed status could differ from author's self-assessment
- **Schema addition** - New fields in `book.json` (though backward-compatible)
- **No persistence of milestone history** - Can't track when milestones were reached

### Mitigations

- Inference rules are documented and transparent
- Authors can always check actual content vs. status
- Future enhancement could add milestone timestamps if needed

## Milestone Inference Rules

| Milestone | Detection Criteria |
|-----------|-------------------|
| thesis-locked | `thesis.md` exists with >100 words, OR `thesis` field in manifest |
| frame-locked | `bookType` set AND preface/intro >500 words |
| outline-locked | Chapter count >= target min, all have titles, no placeholders |
| how-to-read-locked | "How to Read" section exists in front matter |
| sample-chapters-exist | 2+ chapters at >=80% of target word count |
| pitch-ready | thesis-locked + outline-locked + sample-chapters-exist |
| manuscript-complete | All chapters in range, all at target depth, no placeholders |
| production-ready | manuscript-complete AND compiled outputs exist |

## Alternatives Considered

### Explicit Declaration Model

Authors would mark milestones as complete: `/writer:milestone lock thesis`

**Rejected because:**
- Adds friction to workflow
- Status can become stale or aspirational
- Original spec requested this but user feedback during design indicated preference for inference

### Task-Based Tracking

Track milestones as tasks to complete.

**Rejected because:**
- Books aren't linear task lists
- Milestones represent mode switches, not todo items
- Would require task management overhead

### Automatic Pitch Artifact Generation

Generate proposal documents when pitch-ready is detected.

**Rejected because:**
- Automation theater
- Authors should own pitch strategy
- Premature generation could encourage premature pitching

## Related

- ADR-023: Writer Plugin Multi-Plugin Architecture
- ADR-024: Writer Import Command
- ADR-025: Writer Weave Command
- Planning: `.plan/feature-writer-milestones-progress-tracking/`
