# 034. Playwriter Alternative Browser MCP

Date: 2026-01-03

## Status

Accepted

## Context

The Pro plugin bundles Playwright MCP (`@playwright/mcp`) for browser automation. Users requested an alternative that:

1. Works within their existing browser session (preserving extensions, logins)
2. Uses less context window space
3. Allows user-AI collaboration on the same page

[playwriter](https://github.com/remorses/playwriter) is a Chrome extension-based MCP that addresses these needs but requires manual extension installation and tab activation.

## Decision

Support both Playwright and playwriter as alternatives, with environment variable switching:

- Default behavior: Standard `@playwright/mcp` (launches standalone Chrome)
- `USE_PLAYWRITER=1`: Switch to playwriter (Chrome extension-based)

Implementation uses a wrapper script pattern because Claude Code's MCP configuration does not support conditional server registration based on environment variables.

### Wrapper Script

```bash
#!/bin/bash
if [ "$USE_PLAYWRITER" = "1" ]; then
  export PLAYWRITER_AUTO_ENABLE=1
  exec npx playwriter@latest
else
  exec npx -y @playwright/mcp@latest
fi
```

### MCP Configuration

```json
{
  "playwright": {
    "command": "${CLAUDE_PLUGIN_ROOT}/bin/playwright-mcp-wrapper.sh",
    "args": []
  }
}
```

## Consequences

**Positive:**
- Users can choose browser automation approach based on their workflow
- Default behavior unchanged (no breaking change)
- Context window savings when using playwriter (~90% reduction per claims)
- Enables workflows not possible with standalone Playwright (e.g., using logged-in sessions)

**Negative:**
- playwriter requires Chrome extension installation (one-time setup)
- Users must manually activate tabs by clicking extension icon
- Wrapper script adds minor complexity to MCP configuration

## Alternatives Considered

1. **Complete replacement** - Rejected; some users prefer standalone browser approach
2. **Both servers always registered** - Rejected; wastes resources starting unused server
3. **Separate config files** - Rejected; more complex, requires user to swap files manually

## Related

- ADR 002: Support HTTP Transport MCP Servers (transport patterns)
- Planning: `.plan/feature-add-playwriter-mcp-option/`
