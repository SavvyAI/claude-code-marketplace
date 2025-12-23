# Pro Plugin

Professional development workflows with intelligent planning and automation.

## What This Plugin Provides

Installing this plugin gives Claude Code:

- **Slash Commands** - Workflow commands (`/pro:feature`, `/pro:pr`, etc.) that guide you through planning, development, and PR workflows
- **MCP Servers** - Pre-configured servers: Playwright, Context7, Supabase, Chrome DevTools, and Figma

## Commands

| Command | Description |
|---------|-------------|
| `/pro:feature` | Start a new feature with guided planning |
| `/pro:bug` | Report and fix a bug with structured capture |
| `/pro:continue` | Resume work using saved planning notes |
| `/pro:gaps` | Analyze requirements coverage and edge cases |
| `/pro:refactor` | Create a branch for systematic refactoring |
| `/pro:pr` | Archive planning docs and create a pull request |
| `/pro:pr.resolve` | Address PR review comments systematically |
| `/pro:pr.merged` | Clean up after a successful merge |
| `/pro:og` | Generate OG images and social sharing metadata |
| `/pro:handoff` | Generate comprehensive codebase handoff report |
| `/pro:wtf` | Quick situational report (alias for handoff) |
| `/pro:onboarding` | Interactive setup guide for new developers |
| `/pro:rules` | View bundled CLAUDE.md coding rules |
| `/pro:rules.install` | Install bundled CLAUDE.md via symlink |
| `/pro:supabase.local` | Setup and manage local Supabase with unique ports |
| `/pro:copy.questions` | Copy recent clarifying questions to clipboard |

## Workflow

```
# Feature development
/pro:feature "add CSV export"   # Plan and start
/pro:continue                   # Resume later
/pro:gaps                       # Verify completeness
/pro:pr                         # Create PR
/pro:pr.resolve                 # Address feedback
/pro:pr.merged                  # Clean up

# Bug fixes
/pro:bug "login fails silently" # Capture, investigate, fix
```

## Bundled MCP Servers

| Server | Purpose |
|--------|---------|
| **Playwright** | Browser automation for visual verification |
| **Context7** | Up-to-date documentation for any library |
| **Supabase** | Local database operations (requires setup) |
| **Chrome DevTools** | Browser debugging, performance analysis, and automation |
| **Figma** | Figma design file access and integration |

### Supabase Setup

Use `/pro:supabase.local` to initialize and manage local Supabase instances with unique ports per project.

The Supabase MCP requires `SUPABASE_SERVICE_ROLE_KEY` in your environment:

```bash
# Get your key from a running local Supabase instance
export SUPABASE_SERVICE_ROLE_KEY=$(supabase status -o json | jq -r '.SERVICE_ROLE_KEY')
```

---

Part of [ccplugins](../readme.md)
