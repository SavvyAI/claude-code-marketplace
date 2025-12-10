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

## Known Issues

### 1. Stale Plugin References Require Manual Cleanup
**Issue:** When a plugin is renamed, Claude Code does not automatically clean up references to the old plugin name from user configuration files.

**Impact:** Users who had the old plugin installed will see errors like `Plugin {old-name} not found in marketplace`.

**Workaround:** Users must manually:
1. Edit `~/.claude/settings.json` to remove old plugin entries from `enabledPlugins`
2. Edit `~/.claude/plugins/installed_plugins.json` and `installed_plugins_v2.json` to remove old plugin entries
3. Clear the plugin cache: `rm -rf ~/.claude/plugins/cache/{marketplace-name}/`

**Future Consideration:** This should ideally be handled by Claude Code itself. Consider filing a feature request with Anthropic.

### 2. Version Bumps Required for Plugin Updates
**Issue:** Claude Code uses plugin version numbers to determine if cached plugins need to be refreshed. Any change to plugin contents (including new MCP servers, updated commands, etc.) requires a version bump to propagate to users.

**Impact:** Without a version bump, users will continue using stale cached versions even if the marketplace has been updated.

**Best Practice:** Always bump the version in `plugin.json` when making any changes to plugin contents.

## Resolution Status

- [x] Fixed: MCP servers now properly registered after version bump to 1.1.0
- [x] Fixed: Stale "product-planning" references cleaned up from user config
- [x] Verified: `/mcp` shows playwright MCP server
- [x] Verified: `/plugin` shows no errors
