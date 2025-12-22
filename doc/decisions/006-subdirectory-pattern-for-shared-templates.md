# 006. Subdirectory Pattern for Shared Templates

Date: 2025-12-22

## Status

Accepted

## Context

We needed to add `/pro:wtf` as an alias for `/pro:handoff` with a unique description while sharing the same report template. Claude Code plugins auto-discover commands from `*.md` files in the `commands/` directory, which means:

1. Any `.md` file becomes a command
2. There's no native markdown include/import syntax
3. Symlinks share the entire file including YAML frontmatter (preventing unique descriptions)

We needed a way to share content between commands without exposing the shared content as a command itself.

## Decision

Use a subdirectory pattern (`commands/_templates/`) to store shared template files:

```
pro/commands/
├── handoff.md              # Command with unique frontmatter
├── wtf.md                  # Alias with unique frontmatter
└── _templates/
    └── handoff-report.md   # Shared template (not a command)
```

Commands reference the template with instructions to read it: "Read the report template from `_templates/handoff-report.md`".

## Consequences

**Positive:**
- Shared templates are not exposed as commands (subdirectories not scanned)
- Each command can have unique frontmatter (description, allowed-tools)
- Single source of truth for report template content
- Follows common conventions (underscore prefix = internal/private)
- No external tooling or preprocessing required

**Negative:**
- Commands must include instructions to read the template (not automatic)
- Template changes require no code changes to commands, but the separation adds indirection
- Pattern requires discipline to maintain (could drift if not careful)

## Alternatives Considered

1. **Symlinks** - Would share entire file including frontmatter, preventing unique descriptions
2. **Duplicate content** - Would require syncing changes across multiple files
3. **Markdown preprocessor** - Would add build complexity; not supported by Claude Code
4. **External include mechanism** - Would require tooling changes outside this plugin

## Related

- Planning: `.plan/.done/feat-wtf-alias-and-report-output/`
- ADR 003: Symlink approach for CLAUDE.md rules (different use case - instructions vs templates)
