# Fix: MCP Server Installation and Stale Plugin References

## Problem Statement

Two issues were reported after installing the updated plugin:

1. **Error**: `Plugin product-planning not found in marketplace claude-code-marketplace`
2. **MCP servers not registered**: `/mcp` shows no MCP servers configured despite the plugin having `.mcp.json`

## Root Cause Analysis

### Issue 1: Stale "product-planning" Reference

**Findings:**
- `~/.claude/settings.json` has `"product-planning@claude-code-marketplace": true` in `enabledPlugins`
- `~/.claude/plugins/installed_plugins.json` and `installed_plugins_v2.json` have entries for `product-planning@claude-code-marketplace`
- The marketplace only registers a plugin named `"pro"` (not `"product-planning"`)
- User confirmed: the plugin was **renamed** from "product-planning" to "pro"

**Root Cause:** Claude Code's plugin system doesn't automatically clean up references when a plugin is renamed. The old "product-planning" entries persist and cause errors.

**Fix Approach:** This is a user-side cleanup issue. The user needs to:
1. Remove stale entries from `~/.claude/settings.json`
2. Remove stale entries from `~/.claude/plugins/installed_plugins.json` and `installed_plugins_v2.json`
3. Alternatively, uninstall and reinstall the marketplace plugins

### Issue 2: MCP Servers Not Registered

**Findings:**
- The source repo has `.mcp.json` at `pro/.mcp.json` with correct configuration
- The installed marketplace copy at `~/.claude/plugins/marketplaces/claude-code-marketplace/pro/.mcp.json` has the file
- **BUT** the plugin cache at `~/.claude/plugins/cache/claude-code-marketplace/pro/1.0.0/` is **missing** `.mcp.json`
- The cache has an old version (before MCP was added) but same version number `1.0.0`

**Root Cause:** The plugin version wasn't bumped when `.mcp.json` was added. Claude Code uses version numbers to determine if the cache needs to be refreshed. Since the version stayed at `1.0.0`, the cache wasn't updated.

**Fix Approach:** Bump the plugin version to `1.1.0` to force cache invalidation and proper re-installation.

## Implementation Plan

1. **Clean up stale references (user action)**
   - Remove "product-planning" from `~/.claude/settings.json` enabledPlugins
   - Remove "product-planning" entries from installed_plugins.json files

2. **Bump plugin version (code change)**
   - Update `pro/.claude-plugin/plugin.json` version from `1.0.0` to `1.1.0`

3. **Verify fix**
   - User reinstalls/updates the plugin
   - Restart Claude Code
   - Check `/mcp` shows playwright server

## Files to Modify

- `pro/.claude-plugin/plugin.json` - bump version to 1.1.0

## User Instructions (Post-Fix)

```bash
# Clean up stale plugin references (one-time)
# Edit ~/.claude/settings.json - remove "product-planning@claude-code-marketplace" from enabledPlugins

# Clear plugin cache for this marketplace
rm -rf ~/.claude/plugins/cache/claude-code-marketplace/

# Reinstall/update the plugin
# Run /plugin in Claude Code and reinstall pro@claude-code-marketplace

# Restart Claude Code completely

# Verify MCP servers
# Run /mcp in Claude Code
```
