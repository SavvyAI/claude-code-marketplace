# 027. Documentation User-Centric Refactor

Date: 2025-12-31

## Status

Accepted

## Context

The ccplugins repository documentation had several issues:

1. **Installation required cloning** - Users had to `git clone` the repo even though they could add the marketplace directly via URL
2. **Contributor content mixed with user content** - The main README included contributing instructions that only developers need
3. **Writer plugin not listed** - Only the Pro plugin was shown in available plugins
4. **Install commands centralized** - Users had to figure out plugin names from the main README rather than each plugin's own docs
5. **Misleading terminology** - Writer plugin claimed "voice-first interaction" which is just Claude Code's default behavior
6. **Implementation-centric naming** - Compilation targets showed "SpecMD" and "LaTeX" instead of user goals (Web, PDF)
7. **Incomplete plugin.json** - Missing `commands`, `repository`, `license`, `keywords`, and `mcpServers` fields

## Decision

Refactor documentation to be user-centric:

1. **Main README**: Show only marketplace add command, list all plugins, link to each for specifics
2. **CONTRIBUTING.md**: Extract contributor-only content (clone instructions, plugin structure)
3. **Plugin READMEs**: Each plugin shows its own install command
4. **Remove misleading claims**: Delete "voice-first" since it's not a plugin feature
5. **User-centric naming**: Targets are Web/PDF/Markdown, formats are implementation details
6. **Complete plugin.json**: Add all standard metadata fields per official schema

## Consequences

### Positive

- Users can install with 2 commands (marketplace add + plugin install)
- No clone required for end users
- Each plugin is self-documenting
- Documentation accurately describes what each plugin provides
- Plugin discovery works via keywords
- MCP servers properly declared in manifest

### Negative

- Contributors must now read CONTRIBUTING.md separately
- Existing links to main README contributing section will 404

## Alternatives Considered

1. **Keep clone-based installation** - Rejected; unnecessary friction for users
2. **Keep everything in one README** - Rejected; conflates user and contributor audiences
3. **Keep "voice-first" terminology** - Rejected; misleading about plugin capabilities

## Related

- Commits: d3c8445, 8bdab44, 2276b78, f41c3fa, 743fcc1, 4867090, 7c3ac59, b0cf735
- PR #23: Cherry-picked README improvements with attribution
