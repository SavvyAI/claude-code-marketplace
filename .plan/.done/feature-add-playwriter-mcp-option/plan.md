# Plan: Add Playwriter MCP as Alternative to Playwright

## Summary

Add [playwriter](https://github.com/remorses/playwriter) as an optional alternative to the standard Playwright MCP. Users can switch between them via environment variable using a wrapper script approach.

## Requirements (Confirmed)

1. **Add playwriter alongside standard Playwright** - not a replacement
2. **Environment variable switch** - `USE_PLAYWRITER=1` activates playwriter
3. **Auto-enable conditional** - When playwriter is active, enable `PLAYWRITER_AUTO_ENABLE` for automatic tab creation
4. **Default behavior** - Standard @playwright/mcp remains the default

## Technical Findings

Claude Code MCP configuration **does not support conditional server registration**. Environment variables can be used for value substitution (`${VAR:-default}`) but not for conditional inclusion of servers.

### Solution: Wrapper Script Pattern

Create a wrapper script that:
1. Checks `USE_PLAYWRITER` environment variable
2. Runs the appropriate MCP server (playwriter or @playwright/mcp)
3. Passes through `PLAYWRITER_AUTO_ENABLE` when using playwriter

## Implementation Details

### 1. Create Wrapper Script

**File:** `pro/bin/playwright-mcp-wrapper.sh`

```bash
#!/bin/bash
if [ "$USE_PLAYWRITER" = "1" ]; then
  export PLAYWRITER_AUTO_ENABLE=1
  exec npx playwriter@latest
else
  exec npx -y @playwright/mcp@latest
fi
```

### 2. Update MCP Configuration

**File:** `pro/.mcp.json`

```json
{
  "playwright": {
    "command": "${CLAUDE_PLUGIN_ROOT}/bin/playwright-mcp-wrapper.sh",
    "args": []
  }
}
```

### 3. Documentation Updates

**File:** `pro/readme.md` - Added Playwright Setup section explaining:
- What playwriter is and how it differs
- How to switch: `export USE_PLAYWRITER=1`
- Chrome extension installation requirement
- Trade-offs between the two approaches

### 4. Create ADR

**File:** `doc/decisions/034-playwriter-alternative-browser-mcp.md`

## Files Created/Modified

| File | Action | Description |
|------|--------|-------------|
| `pro/bin/playwright-mcp-wrapper.sh` | Created | Wrapper script for conditional MCP selection |
| `pro/.mcp.json` | Modified | Updated playwright config to use wrapper |
| `pro/readme.md` | Modified | Added Playwright Setup documentation section |
| `doc/decisions/034-playwriter-alternative-browser-mcp.md` | Created | ADR for this feature |
| `pro/.claude-plugin/plugin.json` | Modified | Bumped version to 1.25.0 |

## Definition of Done

- [x] Wrapper script created and executable
- [x] `.mcp.json` updated to use wrapper
- [x] Default behavior uses standard @playwright/mcp
- [x] `USE_PLAYWRITER=1` switches to playwriter
- [x] README documents usage and switching
- [x] ADR documents the decision
- [x] Plugin version bumped
