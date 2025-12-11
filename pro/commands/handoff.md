---
description: "Need to onboard developers? → Analyzes codebase structure, health, and operations → Generates comprehensive handoff documentation"
allowed-tools: ["Bash", "Read", "Glob", "Grep"]
---

# Codebase Handoff Report Generator

Generate a comprehensive codebase handoff report suitable for developer onboarding, team transitions, or project audits. This report should provide a complete picture of the project's current state, health, and operational knowledge.

## Instructions

Thoroughly explore the codebase and generate a structured markdown report covering ALL of the following sections. Use actual data from the codebase - do not make assumptions. If information is unavailable, explicitly note it as "Not found" or "Not configured".

---

## Report Sections

### 1. Project Overview
- **Project name and description** (from README, package.json, or similar)
- **Version** (current version number)
- **License**
- **Repository URL** (if available)
- **Primary language(s) and framework(s)**
- **Project type** (web app, mobile app, API, CLI, library, monorepo, etc.)
- **Mission/purpose statement** (1-2 sentences summarizing what this does)

### 2. Tech Stack

#### Frontend (if applicable)
- Framework and version
- UI library/component system
- State management
- Styling approach
- Build tooling

#### Backend (if applicable)
- Runtime and version
- Framework and version
- Database(s) and ORM/query layer
- Caching layer
- Message queues/background jobs

#### Infrastructure
- Hosting/deployment platform
- CI/CD system
- Container/orchestration (Docker, K8s, etc.)
- CDN/edge services

#### External Services & Integrations
List all third-party services with their purpose:
- Authentication provider
- Payment processor
- Email service
- Analytics/monitoring
- AI/ML services
- Other APIs

### 3. Architecture

#### Directory Structure
Provide a high-level tree of the main directories with brief descriptions of each.

#### Key Architectural Patterns
- Design patterns used (MVC, Repository, Factory, etc.)
- Data flow patterns
- API design style (REST, GraphQL, RPC)
- Error handling strategy
- Logging/observability approach

#### Database Schema Summary
- List main tables/collections with their purpose
- Key relationships
- Note any ORMs or type generation

### 4. Working Features
List all implemented and functional features in a table format:
| Feature | Description | Location/Entry Point |
|---------|-------------|---------------------|

### 5. Roadmap & Planned Features
List features that are planned but not yet implemented:
| Priority | Feature | Description | Notes/Blockers |
|----------|---------|-------------|----------------|

### 6. Known Issues & Technical Debt

#### Active Bugs
| Issue | Severity | Description | Workaround |
|-------|----------|-------------|------------|

#### Technical Debt
| Area | Description | Impact | Suggested Resolution |
|------|-------------|--------|---------------------|

#### Code Smells
- TODO/FIXME/HACK comment count (run: `grep -r "TODO\|FIXME\|HACK" --include="*.{ts,tsx,js,jsx,py,go,rs}" | wc -l`)
- Commented-out code blocks
- Any disabled tests (search for `.skip`, `xit`, `xdescribe`, `@pytest.mark.skip`)

### 7. Code Health Metrics

#### Dependency Health
- Total dependencies count
- Outdated packages (run `npm outdated` or equivalent)
- Security vulnerabilities (run `npm audit` or equivalent)
- Last dependency update date

#### Test Coverage
- Unit test coverage percentage (if configured)
- E2E test coverage
- Test framework(s) used
- How to run tests

#### Static Analysis
- Current linting errors/warnings count
- Type errors count (if TypeScript/typed language)
- Code formatting tool and config

#### Codebase Statistics
- Total lines of code (use `cloc` or similar if available)
- Number of source files
- Largest files (potential refactor candidates)

### 8. Development Environment Setup

#### Prerequisites
List all required software with minimum versions:
- Runtime (Node, Python, Go, etc.)
- Package manager
- Database (local)
- Docker (if needed)
- Other tools

#### Environment Variables
List ALL required environment variables (without values):
| Variable | Required | Description | Where to obtain |
|----------|----------|-------------|-----------------|

#### First-Run Setup
Step-by-step commands to go from clone to running:
```bash
# List exact commands
```

#### Common Gotchas
List any tribal knowledge, quirks, or things that commonly trip up new developers.

### 9. Key Commands Reference

```bash
# Development
<command> - <description>

# Testing
<command> - <description>

# Database
<command> - <description>

# Building/Deployment
<command> - <description>

# Other useful commands
<command> - <description>
```

### 10. API Reference Summary (if applicable)

List main API endpoints grouped by domain:
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|

### 11. Documentation Inventory

| Document | Location | Description | Last Updated |
|----------|----------|-------------|--------------|

Note any documentation gaps or stale docs.

### 12. Deployment & Operations

#### Environments

| Environment | URL | Branch | Notes |
|-------------|-----|--------|-------|

#### Deployment Process

- How deployments are triggered
- Deployment frequency
- Rollback procedure

#### Monitoring & Alerting

- Error tracking service and dashboard URL
- Log aggregation
- Uptime monitoring
- Key metrics tracked

#### Incident Response

- Runbooks exist? (Y/N, location)
- On-call rotation
- Escalation path

### 13. Security Posture

- Authentication mechanism
- Authorization model (RBAC, ABAC, etc.)
- Secrets management approach
- Input validation patterns
- Known security TODOs or concerns
- Last security audit date (if any)

### 14. Git & Version Control

#### Branch Strategy

- Main/default branch name
- Branch naming conventions
- PR/merge requirements

#### Recent Activity

- Last 5-10 commits summary
- Active branches count
- Stale branches (>30 days with no activity)

#### Contributors

- Recent active contributors
- Code ownership patterns (CODEOWNERS file?)

### 15. Codebase Archaeology

#### Hotspots (Most Changed Files)

Run: `git log --pretty=format: --name-only | sort | uniq -c | sort -rn | head -20`

These files change frequently and may benefit from refactoring or extra attention.

#### Stable Foundations (Oldest Unchanged)

Files that haven't changed in 6+ months - either very stable or potentially abandoned.

#### Abandoned Code Indicators

- Unused exports
- Dead routes/endpoints
- Orphaned components

---

## Output Format

Generate the report as a single markdown document with clear section headers. Use tables where specified. Include actual command outputs where requested (truncate if very long).

For metrics that require running commands, run them and include the actual results.

If any section is not applicable to this codebase type, note "N/A - [reason]" rather than omitting it.

End the report with:
- Report generated: [timestamp]
- Git commit: [current HEAD commit hash]
- Generator: Claude Code /pro:handoff

---

## Design Principles

This report is designed to be:
1. **Comprehensive** - covers code, ops, security, and tribal knowledge
2. **Actionable** - includes specific commands to run for metrics
3. **Structured** - consistent table formats for easy scanning
4. **Honest** - explicitly notes missing information rather than hiding gaps
