# Chore: Rename Writer Plugin to Author

## Summary

Rename the Writer plugin to Author and consolidate the `import` command into `weave`.

## Rationale

1. **Naming**: "Author" better reflects the user persona (the person writing) vs "Writer" (the tool)
2. **Command consolidation**: The `import` command became redundant once `weave` was implemented
   - Both commands handle bringing content into a book
   - `weave` can detect context (empty vs existing book) and adapt
   - One smart command is simpler than two specialized commands

## Changes

### Directory Rename
- `writer/` → `author/`

### Plugin Metadata
- `plugin.json`: `"name": "writer"` → `"name": "author"`
- `marketplace.json`: Update plugins array

### Command Changes
- Delete `import.md` (absorbed into weave)
- Enhance `weave.md` with bulk mode detection:
  - Empty/minimal book → bulk scaffold mode (auto-structure, minimal dialogue)
  - Existing book → integration mode (full dialogue, placement proposals)

### Reference Updates
All `/writer:*` references become `/author:*`:
- Commands: init, chapter, revise, compile, status, targets, targets.edit, weave
- Documentation: CLAUDE.md, readme.md
- ADRs: Add amendment notes to 023, 024, 025

### New ADR
Create ADR-029 documenting:
- The rename from writer to author
- The consolidation of import into weave
- The context-aware bulk mode design

## Files to Modify

### Core Plugin Files
- [ ] `writer/.claude-plugin/plugin.json` → `author/.claude-plugin/plugin.json`
- [ ] `writer/CLAUDE.md` → `author/CLAUDE.md`
- [ ] `writer/readme.md` → `author/readme.md`
- [ ] `writer/commands/*.md` → `author/commands/*.md`

### Marketplace
- [ ] `.claude-plugin/marketplace.json`

### ADRs
- [ ] `doc/decisions/023-writer-plugin-multi-plugin-architecture.md` (amend)
- [ ] `doc/decisions/024-writer-import-command-for-existing-content.md` (amend)
- [ ] `doc/decisions/025-writer-weave-command-for-reference-integration.md` (amend)
- [ ] `doc/decisions/029-author-plugin-rename-and-weave-consolidation.md` (new)

### Backlog Updates
- [ ] Update item 42 (milestones) to reference author instead of writer

## What NOT to Change

- `.plan/.done/` directories (immutable historical reference)
- Resolved backlog items (historical context)

## Bulk Mode Design

When `weave` detects an empty or minimal book:

```
if book/ doesn't exist OR book/chapters/ is empty:
    → Bulk scaffold mode
    → Auto-detect H1 structure
    → Skip verification (importing own draft)
    → Minimal dialogue: "Found N chapters, proceed?"
else:
    → Integration mode (existing behavior)
    → Full dialogue, placement proposals, verification option
```

## Related ADRs

- [ADR-029: Author Plugin Rename and Weave Consolidation](../../doc/decisions/029-author-plugin-rename-and-weave-consolidation.md)
