# ADR-029: Author Plugin Rename and Weave Consolidation

**Status:** Accepted
**Date:** 2025-12-31
**Amends:** ADR-023, ADR-024, ADR-025

## Context

The Writer plugin was originally designed with two separate commands for importing content:

1. **`/writer:import`** - One-shot bulk structural import (no dialogue)
   - Takes markdown with H1 headings
   - Splits into chapters automatically
   - Creates book structure

2. **`/writer:weave`** - Interactive integration of external references (full dialogue)
   - Takes any input format (text, URL, image, PDF)
   - Analyzes themes and proposes placements
   - Matches voice and adds citations

After implementing both commands, we observed significant overlap:

- Both commands ultimately incorporate content into a book
- An empty book with bulk content doesn't need dialogue; `weave` could detect this
- Having two commands creates cognitive overhead ("which one do I use?")
- The distinction between "importing your own draft" vs "weaving external content" is fuzzy

Additionally, "Writer" describes the tool, while "Author" describes the user persona. The latter better reflects who uses the plugin.

## Decision

### 1. Rename the plugin from `writer` to `author`

- Directory: `writer/` → `author/`
- Plugin name in `plugin.json`: `"name": "author"`
- All command references: `/writer:*` → `/author:*`
- Version bump to 2.0.0 (breaking change)

### 2. Consolidate `import` into `weave`

Delete `/author:import` and make `/author:weave` context-aware:

**Detection logic:**
```
if book/book.json missing OR book/chapters/ has 0-1 files:
    → Bulk Scaffold Mode
else:
    → Integration Mode
```

**Bulk Scaffold Mode** (formerly `import`):
- Auto-detect chapter structure from H1 headings
- Classify into front-matter, chapters, back-matter
- Minimal dialogue: "Found N chapters, proceed?"
- Skip verification (importing own draft)

**Integration Mode** (existing `weave` behavior):
- Full dialogue with placement proposals
- Voice matching and citation
- Optional source verification

### 3. Preserve historical artifacts

The `.plan/.done/` directories contain historical references (e.g., `spike-writer-weave-command/`). These remain unchanged as immutable historical records.

## Consequences

### Positive

- **Simpler mental model**: One command (`weave`) handles all content incorporation
- **Better naming**: "Author" reflects the user, not the tool
- **Reduced cognitive overhead**: No need to choose between import vs weave
- **Context-aware behavior**: The tool adapts to the situation automatically

### Negative

- **Breaking change**: Users referencing `/writer:*` commands need to update
- **Slightly more complex single command**: `weave` now has two modes

### Neutral

- ADRs 024 and 025 remain valid as historical context for why the commands were originally separate
- Future commands can still be added if distinct use cases emerge (e.g., `audit.citations`)

## Related ADRs

- **ADR-023** (Writer Plugin Multi-Plugin Architecture) - Establishes the plugin structure
- **ADR-024** (Writer Import Command) - Original design for bulk import (now absorbed)
- **ADR-025** (Writer Weave Command) - Original design for reference integration (enhanced)
- **ADR-028** (Writer Milestone Tracking) - Uses Author plugin terminology
