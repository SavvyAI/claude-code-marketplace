# Fix: Build-in-Public Missing Subagent

## Bug Summary

The build-in-public feature was designed to automatically surface shareable content during development work. However, only the **skill** component was implemented. Skills are "soft invoked" - the user still has to say something that triggers Claude to recognize and use them.

For true zero-friction background operation, a **subagent** is required. Subagents can run proactively without user intervention.

## Root Cause

Misunderstanding of the semantic difference between skills and subagents:

| Component | Invocation | Purpose |
|-----------|------------|---------|
| **Skill** | User says something, Claude recognizes intent | Provides detailed instructions for HOW to do something |
| **Subagent** | Runs proactively based on description keywords | Background worker that DOES something automatically |

The user explicitly requested both components. Only the skill was created.

## Fix Implementation

### 1. Create Subagent Definition

**File:** `pro/agents/build-in-public.md`

Key elements:
- `name: build-in-public`
- `description`: Contains "Use PROACTIVELY after completing features, fixing bugs..." to trigger automatic invocation
- `tools`: Read, Write, Edit, Glob, Grep, Bash
- `model`: haiku (fast, lightweight)
- `skills`: build-in-public (loads the detailed skill instructions)

### 2. Update Plugin Manifest

**File:** `pro/.claude-plugin/plugin.json`

Added: `"agents": "./agents/"`

This registers the agents directory with Claude Code's plugin system.

### 3. Version Bump

Bumped version from 1.20.1 to 1.21.0 (minor version for new feature component).

## Architecture

```
pro/
├── .claude-plugin/
│   └── plugin.json      # Now references agents
├── agents/              # NEW: Subagent definitions
│   └── build-in-public.md
├── skills/              # Skill definitions (existing)
│   └── build-in-public/
│       └── SKILL.md
└── commands/
    └── bip.md           # Management command (existing)
```

**How it works:**
1. Subagent runs proactively after feature/bug/PR work
2. Subagent loads the build-in-public skill for detailed instructions
3. Subagent checks for notable moments and surfaces content
4. User can approve/defer/skip inline

## Verification

To verify the fix:
1. Run `/agents` to confirm `build-in-public` appears in the list
2. Complete a feature or bug fix
3. Observe if content is automatically surfaced

## Related

- ADR-021: Build in Public Skill Architecture
- ADR-014: Skills Directory for Bundled Agent Skills
- Backlog item #18: Build in Public feature
- Backlog item #38: This bug fix
