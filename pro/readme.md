# Pro Plugin

Professional development workflows with intelligent planning and automation.

## What This Plugin Provides

Installing this plugin gives Claude Code:

- **Slash Commands** - Workflow commands (`/pro:feature`, `/pro:pr`, etc.) that guide you through planning, development, and PR workflows
- **MCP Servers** - Pre-configured servers: Playwright, Context7, Supabase, Chrome DevTools, Figma, and shadcn-ui
- **Skills** - Bundled agent skills that enhance Claude's capabilities

## Commands

| Command | Description |
|---------|-------------|
| `/pro:feature` | Start a new feature with guided planning |
| `/pro:bug` | Report and fix a bug with structured capture |
| `/pro:spike` | Time-boxed exploratory work with optional documentation |
| `/pro:chore` | Maintenance work (infra, docs, tests, deps, CI/config) |
| `/pro:refactor` | Create a branch for systematic refactoring |
| `/pro:spec.import` | Ingest and persist a PRD/spec, auto-parse to backlog |
| `/pro:spec` | View imported specifications (read-only) |
| `/pro:audit` | Analyze requirements, tests, security, and more |
| `/pro:backlog` | Pick items from backlog to work on |
| `/pro:backlog.add` | Add an item to the backlog manually |
| `/pro:backlog.resume` | Resume in-progress OR start recommended next item |
| `/pro:roadmap` | Dashboard view of project status |
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
| `/pro:dev.setup` | Setup npx dev server management with auto port allocation |
| `/pro:copy.questions` | Copy recent clarifying questions to clipboard |
| `/pro:git.main` | Standardize default branch to `main` with explicit confirmation |

## Workflow

```
# Feature development
/pro:feature "add CSV export"   # Plan and start
/pro:backlog.resume             # Resume later
/pro:audit                      # Verify completeness
/pro:pr                         # Create PR
/pro:pr.resolve                 # Address feedback
/pro:pr.merged                  # Clean up

# Bug fixes
/pro:bug "login fails silently" # Capture, investigate, fix

# Exploratory work
/pro:spike "evaluate auth libs" # Time-boxed exploration

# Maintenance work
/pro:chore "update deps"        # Infra, docs, tests, deps, CI

# Spec ingestion (lossless PRD/spec handling)
/pro:spec.import <paste spec>   # Persist spec, auto-parse to backlog
/pro:spec                       # View imported specs
/pro:spec spec-001              # View specific spec details

# Backlog management
/pro:roadmap                    # See project status
/pro:backlog                    # Pick items (or resume in-progress)
/pro:backlog.add "add retry"    # Add item manually
/pro:backlog.resume             # Resume in-progress work

# Git utilities
/pro:git.main                   # Standardize default branch to 'main'
```

## Bundled MCP Servers

| Server | Purpose |
|--------|---------|
| **Playwright** | Browser automation for visual verification |
| **Context7** | Up-to-date documentation for any library |
| **Supabase** | Local database operations (requires setup) |
| **Chrome DevTools** | Browser debugging, performance analysis, and automation |
| **Figma** | Figma design file access and integration |
| **shadcn-ui** | Access shadcn/ui v4 components, blocks, and implementations |

### Supabase Setup

Use `/pro:supabase.local` to initialize and manage local Supabase instances with unique ports per project.

The Supabase MCP requires `SUPABASE_SERVICE_ROLE_KEY` in your environment:

```bash
# Get your key from a running local Supabase instance
export SUPABASE_SERVICE_ROLE_KEY=$(supabase status -o json | jq -r '.SERVICE_ROLE_KEY')
```

### shadcn-ui Setup

The shadcn-ui MCP works out of the box but benefits from a GitHub token for higher rate limits (5000 vs 60 requests/hour):

```bash
export GITHUB_TOKEN=ghp_your_token_here
```

The server provides access to shadcn/ui v4 components across React, Vue, Svelte, and React Native frameworks.

## Bundled Skills

| Skill | Description |
|-------|-------------|
| **frontend-design** | Create distinctive, production-grade frontend interfaces with high design quality. Automatically used when building web components, pages, dashboards, or styling any web UI. |

Skills are automatically available when the plugin is installed. Claude uses them when relevant to your task.

> The `frontend-design` skill is sourced from [Anthropic's skills repository](https://github.com/anthropics/skills) (Apache 2.0).

---

Part of [ccplugins](../readme.md)
