# Feature: Bundle Playwright MCP with Pro Plugin

## Summary

Extend the `pro` plugin to bundle the Playwright MCP server, enabling automatic browser-based verification capabilities for projects that install this plugin.

## Requirements

1. **Bundle Playwright MCP** - Add `.mcp.json` to the pro plugin directory
2. **Minimal hints** - Add contextual guidance in applicable commands
3. **Full testing workflow scope** - Enable visual verification + console logs + network inspection

## Implementation

### MCP Configuration

Created `pro/.mcp.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

### Commands Updated

Added "Browser Verification" section to 5 commands:
- `gaps.md` - verification/completeness
- `feature.md` - initial exploration
- `pr.md` - final verification
- `refactor.md` - UI component verification
- `continue.md` - resume verification work

### Commands Skipped

- `pr.merged.md` - Post-merge cleanup, no verification needed
- `pr.resolve.md` - PR comment resolution, code-focused
- `og.md` - Image generation, not browser testing

## Files Changed

| File | Change |
|------|--------|
| `pro/.mcp.json` | Created - MCP server configuration |
| `pro/commands/gaps.md` | Added Browser Verification section |
| `pro/commands/feature.md` | Added Browser Verification section |
| `pro/commands/pr.md` | Added Browser Verification section |
| `pro/commands/refactor.md` | Added Browser Verification section |
| `pro/commands/continue.md` | Added Browser Verification section |

## Known Considerations

1. **User must have npx available** - Standard for Node.js projects
2. **First run downloads Playwright MCP** - One-time latency on first use
3. **Browser installation** - Users may need to run `npx playwright install` for browsers

## Known Issues for Future Work

None identified. All CodeRabbit feedback was addressed in this PR.
