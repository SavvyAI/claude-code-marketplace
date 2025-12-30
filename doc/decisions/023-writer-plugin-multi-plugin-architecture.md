# 023. Writer Plugin Multi-Plugin Architecture

Date: 2025-12-30

## Status

Accepted

## Context

The ccplugins repository initially housed the "Pro" plugin for Claude Code. A new requirement emerged to add a "Writer" plugin for long-form authoring and publishing. This raised questions about how to structure multiple plugins within a single repository and whether plugins should share infrastructure or remain isolated.

Key considerations:
1. Should plugins share common code/infrastructure?
2. How should the directory structure accommodate multiple plugins?
3. Should plugins have independent versioning?
4. How do backlog items relate to specific plugins?

## Decision

Adopt a **multi-plugin marketplace architecture** where:

1. **Each plugin is a sibling directory** at the repository root (`pro/`, `writer/`)
2. **Plugins are fully independent** - no shared code, no cross-plugin dependencies
3. **Each plugin has its own complete structure**:
   - `.claude-plugin/plugin.json` - Plugin manifest
   - `CLAUDE.md` - Plugin instructions
   - `commands/` - Command definitions
   - `readme.md` - Plugin documentation
4. **Repository-level planning** (`.plan/`) tracks work across all plugins
5. **Spec imports** tag items with plugin context for filtering

## Consequences

### Positive

- **Clear boundaries** - Each plugin can evolve independently
- **Simple mental model** - "One directory = one plugin"
- **No coupling** - Changes to Pro don't affect Writer
- **Easy plugin creation** - Copy structure, modify content
- **Independent release cycles** - Plugins can version separately

### Negative

- **Potential duplication** - Similar patterns may exist in both plugins
- **No shared utilities** - Each plugin implements its own helpers
- **Backlog complexity** - Need to filter by plugin context

### Neutral

- Marketplace concept is implicit (directory structure) rather than explicit (no marketplace manifest)
- Plugin discovery relies on Claude Code's native plugin scanning

## Alternatives Considered

### Monolithic Plugin with Namespaced Commands

```
/pro:init, /pro:chapter, /writer:init, /writer:chapter
```

All in one plugin with command prefixes.

**Rejected because:**
- Single massive CLAUDE.md becomes unwieldy
- Harder to reason about scope
- No clear separation of concerns

### Shared Infrastructure Layer

```
shared/
  utils.md
  templates/
pro/
writer/
```

Common code shared between plugins.

**Rejected because:**
- Adds coupling and complexity
- Plugins have different needs
- YAGNI - no clear shared requirements yet

## Related

- Planning: `.plan/.done/mvp-writer-plugin/`
- Spec: `.plan/specs/spec-001-writer-plugin.md`
