# Feature: Add shadcn-ui MCP Server

## Branch
`feat/add-shadcn-ui-mcp-server`

## Summary
Add the shadcn-ui MCP server to the plugin's bundled MCP servers, enabling Claude to access shadcn/ui v4 components, blocks, and implementations for AI-powered UI development.

## Source
- Repository: https://github.com/Jpisnice/shadcn-ui-mcp-server
- Package: `@jpisnice/shadcn-ui-mcp-server`
- License: MIT

## Configuration Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Framework | React (default) | Most common usage; no flag needed |
| GitHub Token | Yes, with env var | Enables 5000 vs 60 requests/hour |
| Server Name | `shadcn-ui` | Clear, matches npm package pattern |

## Proposed Configuration

```json
"shadcn-ui": {
  "command": "npx",
  "args": ["-y", "@jpisnice/shadcn-ui-mcp-server@latest"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
  }
}
```

## Implementation Steps

1. [x] Confirm requirements and scope
2. [x] Ask clarifying questions
3. [x] Create feature branch
4. [x] Create planning notes
5. [x] Add shadcn-ui MCP server to `.mcp.json`
6. [x] Update plugin documentation (`readme.md`)
7. [x] Bump plugin version in `plugin.json`
8. [x] Verify configuration works
9. [x] Run coderabbit review

## Files to Modify

| File | Change |
|------|--------|
| `pro/.mcp.json` | Add shadcn-ui server configuration |
| `pro/readme.md` | Add to bundled MCP servers table |
| `pro/.claude-plugin/plugin.json` | Bump version to 1.12.0 |

## What This Enables

When installed, Claude will have access to:
- shadcn/ui v4 component source code
- Component demos and implementations
- Block patterns and layouts
- Multi-framework support (React, Vue, Svelte, React Native)
- Smart caching with GitHub API integration

## Definition of Done

- [x] Configuration added to `.mcp.json`
- [x] Documentation updated in `readme.md`
- [x] Plugin version bumped
- [x] No errors or warnings
- [x] Verified by user
