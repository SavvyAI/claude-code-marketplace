# Pro Plugin

Professional development workflows with intelligent planning and automation.

## Commands

| Command | Description |
|---------|-------------|
| `/pro:feature` | Start a new feature with guided planning |
| `/pro:continue` | Resume work using saved planning notes |
| `/pro:gaps` | Analyze requirements coverage and edge cases |
| `/pro:refactor` | Create a branch for systematic refactoring |
| `/pro:pr` | Archive planning docs and create a pull request |
| `/pro:pr.resolve` | Address PR review comments systematically |
| `/pro:pr.merged` | Clean up after a successful merge |
| `/pro:og` | Generate OG images and social sharing metadata |

## Workflow

```
/pro:feature "add CSV export"   # Plan and start
/pro:continue                   # Resume later
/pro:gaps                       # Verify completeness
/pro:pr                         # Create PR
/pro:pr.resolve                 # Address feedback
/pro:pr.merged                  # Clean up
```

## Bundled MCP Servers

| Server | Purpose |
|--------|---------|
| **Playwright** | Browser automation for visual verification |
| **Context7** | Up-to-date documentation for any library |
| **Supabase** | Local database operations (requires setup) |

### Supabase Setup

The Supabase MCP requires `SUPABASE_SERVICE_ROLE_KEY` in your environment:

```bash
# Get your key from a running local Supabase instance
export SUPABASE_SERVICE_ROLE_KEY=$(supabase status -o json | jq -r '.SERVICE_ROLE_KEY')
```

---

Part of [ccplugins](../readme.md)
