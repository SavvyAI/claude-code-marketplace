# Plan: Rebrand to ccplugins & Expand MCP Servers

## Summary
Rename all references from `claude-code-marketplace` to `ccplugins`, improve README aesthetics, add Pro plugin installation instructions, and add Context7 + Supabase MCP servers.

## Requirements

1. **Rename references:** `claude-code-marketplace` → `ccplugins`
2. **Add installation docs:** How to install Pro plugin after cloning marketplace
3. **Improve READMEs:** Terse, scannable, focused on quick start
4. **Add MCP servers:**
   - Context7 (without API key for simplicity)
   - Supabase (NPX with local dev environment variables)

## Implementation Steps

### Phase 1: Update Root README
- [x] Change title from "Claude Code Marketplace" to "ccplugins"
- [x] Update git clone URL to `https://github.com/SavvyAI/ccplugins.git`
- [x] Add "Quick Start" section with clone + install commands
- [x] Keep table format for plugins list
- [x] Maintain contributing guidelines

### Phase 2: Update Pro Plugin README
- [x] Update footer link to new branding
- [x] Add "Bundled MCP Servers" section with table
- [x] Add Supabase setup instructions (env var requirement)

### Phase 3: Add MCP Servers
- [x] Add Context7 MCP (npx, no API key)
- [x] Add Supabase MCP (npx with env vars for local dev)
- [x] Update `.mcp.json` in pro plugin

### Phase 4: Version Bump
- [x] Bump plugin version to 1.2.0 for cache invalidation

## Configuration Details

### Context7 MCP
```json
{
  "context7": {
    "command": "npx",
    "args": ["-y", "@upstash/context7-mcp@latest"]
  }
}
```
- No API key needed (rate limited to 60 req/hr)
- Provides up-to-date documentation for any library

### Supabase MCP
```json
{
  "supabase": {
    "command": "npx",
    "args": ["-y", "@supabase/mcp-server-supabase@latest"],
    "env": {
      "SUPABASE_URL": "http://127.0.0.1:54321",
      "SUPABASE_SERVICE_ROLE_KEY": "${SUPABASE_SERVICE_ROLE_KEY}",
      "SUPABASE_ACCESS_TOKEN": "dummy"
    }
  }
}
```
- Requires `SUPABASE_SERVICE_ROLE_KEY` env var
- `SUPABASE_ACCESS_TOKEN=dummy` is required but unused for local

## User Decisions
- Context7: Without API key (simpler setup)
- Supabase: NPX for local dev (requires env var)
- GitHub URL: HTTPS format (`https://github.com/SavvyAI/ccplugins.git`)

## Validation
- [x] CodeRabbit review passed
- [x] All files updated consistently
- [x] Version bumped for cache invalidation

## Known Issues
None identified for this implementation.
