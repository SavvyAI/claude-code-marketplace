# 024. Writer Import Command for Existing Content

Date: 2025-12-30

## Status

Accepted

## Context

The Writer plugin's initial design focused on greenfield book projects (`/writer:init` creates an empty structure). Users with existing markdown drafts—such as a preface and chapter stubs—needed a tedious workflow: run `/writer:init`, then manually run `/writer:chapter` for each chapter.

A common user scenario is having an existing markdown file with H1 headings delineating chapters that needs to be imported into the Writer book structure.

## Decision

Implement a **dual-approach** for importing existing content:

1. **New `/writer:import` command** - Standalone command for bulk-importing markdown content into a book project. Supports:
   - Single markdown file with H1 chapter boundaries
   - Directory of markdown files
   - Pasted content

2. **Enhanced `/writer:init`** - Adds an early question "Do you have existing content to import?" that delegates to import logic if yes.

### Chapter Detection Heuristics

Content is classified based on H1 heading patterns:

| Pattern | Classification | Destination |
|---------|----------------|-------------|
| `# Preface`, `# Foreword` | front-matter | `book/front-matter/` |
| `# Chapter N: Title` | chapter | `book/chapters/NN-title.md` |
| `# Appendix`, `# Bibliography` | back-matter | `book/back-matter/` |
| Other H1 headings | chapter (default) | `book/chapters/NN-slug.md` |

## Consequences

### Positive

- **Reduced friction** - Users with existing content can bootstrap a book in one command
- **Consistent patterns** - Follows the Pro plugin's `/pro:spec.import` pattern for ingesting external content
- **Flexible input** - Supports multiple input formats (file, directory, paste)
- **Non-destructive** - Original content is preserved, just structured into book format

### Negative

- **Heuristic-based** - Chapter detection relies on H1 patterns which may not match all user content formats
- **Two entry points** - Users may be confused whether to use `/writer:init` or `/writer:import`

### Mitigations

- Import command shows preview of detected structure before writing files
- Documentation clearly explains when to use each command
- `/writer:init` explicitly offers the import option, guiding users to the right path

## Alternatives Considered

### Enhance `/writer:init` only (no separate import command)

Rejected because:
- Import into an existing book project wouldn't be possible
- Single command would become too complex with branching logic

### Require structured input format

Requiring a specific YAML/JSON manifest describing chapters was rejected because:
- Adds friction for the common case (markdown with H1 headings)
- Users would need to learn a new format

## Related

- Planning: `.plan/.done/spike-writer-import-existing-content/`
- Writer Plugin ADR: `doc/decisions/023-writer-plugin-multi-plugin-architecture.md`
