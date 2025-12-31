# 025. Writer Weave Command for Reference Integration

Date: 2025-12-30

## Status

Accepted

## Context

Authors often encounter reference material during the writing process—articles, screenshots, notes, PDFs—that should be incorporated into their book. The existing `/writer:import` command handles bulk structural import of existing content, but doesn't address the ongoing need to weave external references into an existing manuscript.

Key challenges:
1. Reference material comes in diverse formats (text, images, PDFs, URLs)
2. Authors want collaborative dialogue, not automated insertion
3. Source verification and citation management are critical for non-fiction
4. Content must be transformed to match the book's voice, not copied verbatim
5. Authors need control over where content lands and how it's presented

## Decision

Implement `/writer:weave` as an interactive, dialogue-driven command for incorporating reference material into book chapters.

### Core Design Principles

1. **Proposal-first workflow** - Claude analyzes the reference, proposes placements, and waits for author approval before any changes
2. **Voice synthesis** - Content is transformed to match existing chapter voice, not copied verbatim
3. **Optional verification** - Authors can opt into source verification and claim validation via web search
4. **Flexible citations** - Support both footnote (`[^1]`) and inline parenthetical (`Author, Year`) styles
5. **Hybrid archival** - Important references are stored in `book/references/`; minor ones are just cited

### Workflow Phases

1. **Intake** - Accept input from any format (text, image, PDF, URL, file)
2. **Verification** (optional) - Find original source, verify claims
3. **Analysis** - Match reference themes to existing book structure
4. **Proposal** - Present concrete recommendations for each theme
5. **Dialogue** - Interactive discussion until author decides
6. **Draft** - Generate woven content in author's voice
7. **Refinement** - Iterate until approved
8. **Commit** - Write to chapters, add citations, archive reference

### Data Structures

**Reference archival:**
```
book/references/
├── ref-001-source-title.md    # Full content with YAML frontmatter
├── ref-002-another-source.md
└── references.json            # Index of all references
```

**Citation preference stored in `book/book.json`:**
```json
{
  "citationStyle": "footnote"  // or "inline"
}
```

## Consequences

### Positive

- **Seamless research integration** - Authors can capture inspiration as they find it
- **Quality control** - Verification step catches unreliable sources before they enter the book
- **Voice consistency** - Woven content matches existing writing style
- **Full traceability** - All sources are cited and optionally archived
- **Author control** - Nothing is written without explicit approval

### Negative

- **Multi-step process** - More dialogue than a simple paste-and-insert
- **Relies on Claude's judgment** - Theme matching and voice detection are heuristic

### Mitigations

- Each phase has clear exit points if author wants to abort
- Author can always edit woven content after the fact with `/writer:revise`
- All proposals are explicit and require confirmation

## Alternatives Considered

### Simple Append Command

A simpler `/writer:append` that just adds content to a specified chapter.

**Rejected because:**
- No voice matching
- No source verification
- No help with placement decisions
- Doesn't address the collaborative aspect users requested

### Automatic Weaving (No Dialogue)

Analyze and insert content automatically based on best-guess placement.

**Rejected because:**
- Users explicitly requested control over placement
- "All willy nilly" insertion was specifically called out as undesirable
- No opportunity for author to expound or discuss topics

### Separate Commands for Each Format

`/writer:weave-url`, `/writer:weave-image`, etc.

**Rejected because:**
- Cognitive overhead of remembering multiple commands
- Format detection is straightforward and can be automatic
- Single command with format inference is more ergonomic

## Related

- ADR-023: Writer Plugin Multi-Plugin Architecture
- ADR-024: Writer Import Command for Existing Content
- Planning: `.plan/spike-writer-weave-command/`
