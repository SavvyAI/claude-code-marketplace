# Pro Plugin

Professional development workflows with intelligent planning, branch management, and pull request automation.

## Installation

Pro is included in the [Claude Code Marketplace](../readme.md). Once the marketplace is installed, Pro commands are immediately available.

## Commands

| Command | Purpose | Source |
|---------|---------|--------|
| `/pro:feature` | Create feature branch with guided planning | [feature.md](./commands/feature.md) |
| `/pro:continue` | Resume work on existing plans | [continue.md](./commands/continue.md) |
| `/pro:gaps` | Run comprehensive gap analysis | [gaps.md](./commands/gaps.md) |
| `/pro:refactor` | Systematic code refactoring | [refactor.md](./commands/refactor.md) |
| `/pro:pr` | Create and push pull request | [pr.md](./commands/pr.md) |
| `/pro:pr.resolve` | Resolve all PR comments | [pr.resolve.md](./commands/pr.resolve.md) |
| `/pro:pr.merged` | Post-merge cleanup | [pr.merged.md](./commands/pr.merged.md) |

## Quick Start

Start a new feature with planning:

```bash
/pro:feature "add user profile settings page"
```

Complete feature workflow:

```bash
/pro:feature "add CSV export"   # Start with planning
/pro:continue                   # Resume work later
/pro:gaps                       # Verify completeness
/pro:pr                         # Create pull request
/pro:pr.resolve                 # Address review feedback
/pro:pr.merged                  # Clean up after merge
```

## How It Works

### Feature Development
`/pro:feature` enters planning mode to discuss requirements, then creates a feature branch and guides implementation with documentation stored in `.plan/{branch-name}/`.

### Pull Requests
`/pro:pr` archives planning docs to `.plan/.done/`, analyzes all commits, and creates a comprehensive PR using `gh` CLI.

### Quality Assurance
`/pro:gaps` analyzes requirements coverage, test quality, error handling, edge cases, and code consistency.

## Contributing

Contributions welcome! See command source files above for implementation details.

1. Open an issue describing the enhancement
2. Submit a PR with your changes
3. Include examples and use cases

---

**Part of the [Claude Code Marketplace](../readme.md)**
