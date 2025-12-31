# 026. Subagent-Skill Dual Architecture for Proactive Features

Date: 2025-12-30

## Status

Accepted

## Context

The build-in-public feature was originally implemented as a skill only. Skills in Claude Code are "soft invoked" - the user must say something that triggers Claude to recognize and use the skill. This works well for capabilities like `frontend-design` where the user explicitly requests UI work.

However, build-in-public was designed for zero-friction operation: content should surface automatically after completing features, fixing bugs, or reaching milestones. The user should not need to remember to ask for content suggestions.

This revealed a semantic gap in our understanding:
- **Skills** = Expert knowledge that Claude applies when the user's intent matches
- **Subagents** = Background workers that run proactively based on trigger conditions

## Decision

For features requiring proactive/automatic behavior, we use a **dual architecture**:

1. **Subagent** (`pro/agents/{name}.md`) - The trigger mechanism
   - Contains "Use PROACTIVELY" in description to encourage automatic invocation
   - Defines WHEN to run (after features, bugs, PRs, milestones)
   - Lightweight prompt focused on the workflow
   - References the skill for detailed instructions

2. **Skill** (`pro/skills/{name}/SKILL.md`) - The capability definition
   - Contains detailed HOW-TO instructions
   - Defines output formats, file operations, configuration
   - Loaded by the subagent via the `skills:` frontmatter field

### Plugin Manifest

The plugin.json now references both:

```json
{
  "skills": "./skills/",
  "agents": "./agents/"
}
```

### File Structure

```
pro/
├── agents/
│   └── build-in-public.md    # Subagent: WHEN to run
├── skills/
│   └── build-in-public/
│       └── SKILL.md          # Skill: HOW to do it
└── commands/
    └── bip.md                # Command: Manual management
```

## Consequences

### Positive

- **True zero-friction**: Subagent runs automatically without user intervention
- **Separation of concerns**: When (subagent) vs How (skill) vs Manage (command)
- **Reusable pattern**: Other proactive features can follow this architecture
- **Skill inheritance**: Subagent loads skill via `skills:` field, avoiding duplication

### Negative

- **Two files to maintain**: Both subagent and skill need updates for changes
- **Complexity**: Three components (subagent, skill, command) for one feature
- **Documentation burden**: Must explain the distinction to users

### Neutral

- Follows Claude Code's official plugin specification for both agents and skills
- No migration needed for existing skill-only features that don't require proactive behavior

## Alternatives Considered

### 1. Skill-only approach (original implementation)

Rejected because skills are user-triggered, defeating the zero-friction goal.

### 2. Command integration (add to /pro:pr, /pro:feature, etc.)

Rejected because:
- Couples build-in-public to other commands
- Users who don't want build-in-public would still see it
- Harder to disable/configure independently

### 3. Subagent-only (no skill)

Rejected because:
- Would duplicate detailed instructions in subagent prompt
- Harder to share instructions between subagent and /pro:bip command
- Skills provide better organization for complex capabilities

## Related

- ADR-014: Skills Directory for Bundled Agent Skills
- ADR-021: Build in Public Skill Architecture
- Planning: `.plan/.done/fix-build-in-public-missing-subagent/`
- Backlog #38: Build-in-public missing subagent component
