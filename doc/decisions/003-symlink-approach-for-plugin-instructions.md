# 003. Symlink Approach for Plugin Instructions

Date: 2024-12-20

## Status

Accepted

## Context

Claude Code plugins cannot natively bundle CLAUDE.md instruction files. The CLAUDE.md system only loads files from:
- User level: `~/.claude/CLAUDE.md`
- Project level: `.claude/CLAUDE.md`
- Enterprise level (managed by organizations)

We wanted to version-control global instructions within the pro plugin for consistency across machines and easy updates.

## Decision

Use a symlink-based distribution approach:

1. **Bundle the CLAUDE.md file in the plugin** (`pro/CLAUDE.md`)
2. **Provide two commands:**
   - `/pro:rules` - Shows file location and provides ready-to-run symlink commands
   - `/pro:rules.install` - Interactively creates symlinks with backup handling
3. **User creates symlink** from `~/.claude/CLAUDE.md` or `.claude/CLAUDE.md` pointing to the plugin's bundled file

## Consequences

### Positive
- Instructions are version-controlled in the plugin repository
- Updates to the plugin automatically apply (via symlink)
- Transparent - users understand exactly what's happening
- Works with Claude Code's existing CLAUDE.md loading mechanism
- Supports both global and project-level installation

### Negative
- Requires manual installation step (symlink creation)
- Symlinks may not work on all platforms (though macOS/Linux are primary targets)
- If user has existing CLAUDE.md, they must backup/replace it

## Alternatives Considered

1. **MCP Resource**: Could serve instructions dynamically, but requires manual invocation and doesn't integrate with CLAUDE.md loading
2. **Output Styles**: Modifies system prompt but requires separate installation and selection
3. **Embed in each command**: Would require duplicating instructions across all commands
4. **Feature request to Anthropic**: Long-term solution but not available now

## Related

- Planning: `.plan/.done/feat-bundle-claude-md-rules/`
