# 010. Bundled Bin Assets for Setup Commands

Date: 2024-12-24

## Status

Accepted

## Context

The `/pro:dev.setup` command needs to install `npx dev` server management infrastructure into target projects. This requires copying TypeScript CLI scripts (`dev.ts`, `notify.ts`) and templates (`README.template.md`) to the user's project.

We needed to decide where to store these assets within the plugin structure and how to reference them during the setup process.

## Decision

Store bundled executable assets in `pro/commands/_bins/{command-name}/` directory structure:

```
pro/commands/
├── _bins/
│   └── dev/
│       ├── dev.ts              # Main CLI script
│       ├── notify.ts           # Notification helper
│       └── README.template.md  # Documentation template
└── dev.setup.md               # The slash command
```

The underscore prefix (`_bins`) signals these are supporting assets rather than commands. The command-specific subdirectory (`dev/`) allows multiple setup commands to bundle their own assets without conflicts.

## Consequences

**Positive:**
- Clear separation between command definitions (`.md`) and bundled assets
- Underscore convention matches existing `_templates` pattern
- Command-specific subdirectories enable future setup commands (e.g., `_bins/docker/`, `_bins/ci/`)
- Assets are version-controlled with the plugin

**Negative:**
- Increases plugin size with bundled scripts
- Assets must be manually kept in sync if upstream changes
- The setup command must use Read/Write tools rather than direct copy

## Alternatives Considered

1. **Store in plugin root `assets/` directory** - Rejected as it separates assets from their associated commands
2. **Inline scripts in the .md file** - Rejected due to size and maintainability
3. **Fetch from external URL** - Rejected for offline reliability and version pinning

## Related

- Planning: `.plan/.done/feat-dev-setup-command/`
