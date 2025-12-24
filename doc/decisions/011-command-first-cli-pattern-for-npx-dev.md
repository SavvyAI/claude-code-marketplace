# 011. Command-First CLI Pattern for npx dev

Date: 2024-12-24

## Status

Accepted

## Context

The original `npx dev` CLI had an inconsistent command structure:

```bash
npx dev web stop      # Server-first: <server> <action>
npx dev logs web      # Command-first: <command> <server>
npx dev stop          # Ambiguous: is "stop" a server or command?
```

This inconsistency made the CLI confusing and harder to document. Users couldn't predict whether to put the server name or command first.

## Decision

Adopt a consistent **command-first** pattern where the command always comes first and the optional server name follows:

```bash
npx dev start [name]    # Start server (first if no name)
npx dev stop [name]     # Stop server (all if no name)
npx dev restart <name>  # Restart specific server
npx dev status          # Show running servers
npx dev logs [name]     # Follow logs
npx dev doctor          # Diagnose environment
npx dev init            # Initialize from package.json
```

Shorthand is preserved for convenience:
```bash
npx dev          # Same as: npx dev start
npx dev web      # Same as: npx dev start web
```

## Consequences

**Positive:**
- Consistent, predictable CLI pattern
- Easier to document and remember
- Follows conventions of similar tools (git, npm, docker)
- Clear distinction between commands and server names

**Negative:**
- Breaking change for existing users of server-first syntax
- Shorthand `npx dev web` could conflict if a server is named like a command

## Alternatives Considered

1. **Server-first everywhere** (`npx dev web start`) - Rejected as it conflicts with global commands like `status`
2. **Subcommand groups** (`npx dev server web start`) - Rejected as too verbose
3. **Keep mixed pattern** - Rejected due to user confusion

## Related

- Planning: `.plan/.done/feat-dev-setup-command/`
- ADR: [010. Bundled Bin Assets for Setup Commands](010-bundled-bin-assets-for-setup-commands.md)
