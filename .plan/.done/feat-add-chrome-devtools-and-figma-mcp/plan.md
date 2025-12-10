# Plan: Add Chrome DevTools and Figma MCP Servers

## Goal

Add two new MCP servers to enhance the Pro plugin's capabilities:
1. **Chrome DevTools MCP** - Browser debugging, performance analysis, and automation
2. **Figma MCP Server** - Figma design file access and integration

## Rationale

### Chrome DevTools MCP

Provides 26 tools for comprehensive browser interaction:
- **Input Automation**: click, drag, fill, fill_form, handle_dialog, hover, press_key, upload_file
- **Navigation**: navigate_page, new_page, select_page, close_page, list_pages, wait_for
- **Debugging**: take_screenshot, take_snapshot, evaluate_script, get_console_message, list_console_messages
- **Performance**: performance_start_trace, performance_stop_trace, performance_analyze_insight
- **Network**: list_network_requests, get_network_request
- **Emulation**: emulate, resize_page

Complements existing Playwright MCP with deeper DevTools integration for performance profiling and debugging.

### Figma MCP Server

Enables AI-assisted design workflows:
- Access Figma design files directly
- Extract design specifications
- Bridge design-to-development workflows

First HTTP-based MCP server in the plugin, using Figma's hosted remote server.

## Configuration

### Chrome DevTools (stdio transport)

```json
"chrome-devtools": {
  "command": "npx",
  "args": ["-y", "chrome-devtools-mcp@latest"]
}
```

### Figma (HTTP transport)

```json
"figma": {
  "type": "http",
  "url": "https://mcp.figma.com/mcp"
}
```

## Requirements

- **Chrome DevTools**: Node.js v20.19+, Chrome browser installed
- **Figma**: Figma account (OAuth handled automatically on first use)

## Changes

| File | Change |
|------|--------|
| `pro/.mcp.json` | Add both MCP server configurations |
| `pro/readme.md` | Document new servers |
| `pro/.claude-plugin/plugin.json` | Bump version 1.2.0 → 1.3.0 |

## Related ADRs

- [002. Support HTTP Transport MCP Servers](../../doc/decisions/002-support-http-transport-mcp-servers.md)
