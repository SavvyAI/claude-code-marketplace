# 002. Support HTTP Transport MCP Servers

Date: 2025-12-10

## Status

Accepted

## Context

The Pro plugin bundles MCP servers to extend Claude Code's capabilities. All existing servers (Playwright, Context7, Supabase) use stdio transport, launching local processes via `npx`.

Figma provides their MCP server as a hosted HTTP endpoint (`https://mcp.figma.com/mcp`) rather than an npm package. To integrate Figma's design tools, we needed to support HTTP transport in our `.mcp.json` configuration.

## Decision

Add support for HTTP transport MCP servers alongside existing stdio servers. HTTP servers use `type` and `url` properties instead of `command` and `args`:

```json
{
  "figma": {
    "type": "http",
    "url": "https://mcp.figma.com/mcp"
  }
}
```

## Consequences

**Positive:**
- Enables integration with hosted MCP services (Figma, future remote servers)
- No local dependencies required for HTTP servers
- Authentication handled by provider (Figma OAuth)

**Negative:**
- Requires network connectivity for HTTP servers
- Dependent on third-party service availability
- Mixed configuration patterns (stdio vs HTTP) in same file

## Alternatives Considered

1. **Wait for Figma npm package** - Rejected; Figma only offers the hosted endpoint
2. **Separate config files for HTTP servers** - Rejected; adds complexity, single `.mcp.json` is simpler

## Related

- Planning: `.plan/.done/feat-add-chrome-devtools-and-figma-mcp/`
