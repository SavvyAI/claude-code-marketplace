# Spike Findings: /writer:weave Command

## What Was Explored

Designed a collaborative workflow for incorporating external reference material into book chapters. The command needed to handle:

1. **Multiple input formats** - text, screenshots, PDFs, URLs
2. **Source verification** - finding original sources and validating claims
3. **Theme matching** - analyzing what fits where in the existing book structure
4. **Iterative dialogue** - proposal → discussion → draft → refinement loop
5. **Citation management** - footnotes, inline citations, bibliography
6. **Reference archival** - hybrid storage (important refs archived, minor ones just cited)

## Key Learnings

### 1. Import vs Weave: Clear Distinction

| `/writer:import` | `/writer:weave` |
|------------------|-----------------|
| One-time bulk operation | Ongoing iterative process |
| Structural (creates chapters) | Content (enhances chapters) |
| Minimal dialogue | Heavy dialogue |
| User provides chapter structure | Claude proposes placement |
| No transformation | Heavy transformation (synthesis) |

Import is about **bootstrapping structure**. Weave is about **incorporating inspiration and facts**.

### 2. Multi-Phase Workflow is Essential

The 8-phase workflow emerged from user requirements:
1. Intake → Extract content from any format
2. Verification (optional) → Research to validate
3. Analysis → Match themes to book structure
4. Proposal → Claude's recommendations
5. Dialogue → Back-and-forth refinement
6. Draft → Generate woven prose
7. Refinement → Iterate until approved
8. Commit → Write to files

User feedback: "All of the above" for first move (extract, verify, match) - users want comprehensive intake.

### 3. Voice Matching is Critical

User doesn't want "verbatim what it saw in the reference document." The command must:
- Detect existing chapter voice (person, formality, complexity)
- Transform reference material into prose that matches
- Add value through expansion, not just insertion

### 4. Preview Format: Summary + Full Draft

User question revealed preference for:
- Brief summary of what's being added and where
- Full draft text (not diff)
- Surrounding context to see how it flows

This is better than side-by-side diffs for prose because:
- Prose needs to be read in flow, not compared
- Most woven content is "new" not "changed"
- Refinement works on the draft, not a diff

### 5. Flexible Citation System

Users want both citation styles available per-source:
- Footnotes (`[^1]`) - common in trade books
- Inline parenthetical `(Author, Year)` - common in academic

Store preference in `book/book.json` but allow override per reference.

### 6. Hybrid Reference Storage

Not all references need full archival:
- **Archive** - Important sources the author may revisit
- **Just cite** - Minor references that only need attribution

Storage structure: `book/references/` with both:
- Individual `.md` files for archived content
- `references.json` index for all references

## Decisions Made

1. **Command name**: `/writer:weave` (verb that captures the collaborative, integrative nature)
2. **Allowed tools**: Added `WebSearch` and `WebFetch` for source verification
3. **Citation storage**: In `book/back-matter/bibliography.md` (standard location)
4. **Reference archival**: Optional, user chooses per reference
5. **Voice detection**: Analyze target chapter before drafting

## Decisions Deferred

1. **Automatic weave suggestions** - Could Claude proactively suggest weaving when it sees relevant content in conversation? (Future enhancement)
2. **Cross-reference detection** - When weaving, detect if content relates to other chapters and suggest cross-references? (Future enhancement)
3. **Version tracking** - Track what was woven and when for audit trail? (Covered by git history for now)

## Recommendations for Next Steps

### Promote to Feature

This spike produced a complete command specification. Recommend promoting to `/pro:feature` for implementation.

**Implementation order:**
1. Basic weave flow (text input only)
2. Image/screenshot support (OCR via Claude vision)
3. URL support (WebFetch integration)
4. PDF support (already native to Claude)
5. Source verification (WebSearch integration)
6. Reference archival system
7. Voice matching enhancement

### Consider Enhancements

1. **Weave queue** - Store references for later weaving:
   ```
   /writer:weave --later screenshot.png  # Queue for later
   /writer:weave --pending               # Show queued items
   ```

2. **Bulk weave** - Weave multiple references in one session:
   ```
   /writer:weave *.png  # Process multiple screenshots
   ```

3. **Weave history** - Track what was woven from where:
   ```json
   // In book/book.json
   "weaveHistory": [
     {
       "reference": "ref-001",
       "chapters": ["03-planning.md"],
       "wordsAdded": 287,
       "timestamp": "2025-12-30T..."
     }
   ]
   ```

## Files Created

| File | Purpose |
|------|---------|
| `.plan/spike-writer-weave-command/workflow-design.md` | Detailed workflow specification |
| `writer/commands/weave.md` | Command definition |
| Updated `writer/CLAUDE.md` | Added command to table |

## Spike Status

**Uncertainty reduced**: Yes - clear workflow, data structures, and edge cases defined.

**Recommend**: Promote to feature branch for implementation.
