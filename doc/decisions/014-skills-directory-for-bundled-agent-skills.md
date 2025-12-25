# 014. Skills Directory for Bundled Agent Skills

Date: 2024-12-24

## Status

Accepted

## Context

Claude Code supports "Plugin Skills" - agent skills that are automatically available when a plugin is installed. We wanted to bundle Anthropic's open-source `frontend-design` skill so users get production-grade frontend design guidance without additional setup.

We needed to decide:
1. Where to store plugin skills
2. How to register them with the plugin system
3. How to handle third-party skill attribution

## Decision

We will use a `skills/` directory at the plugin root to store bundled agent skills, following Claude Code's official plugin skills pattern:

```
pro/
├── .claude-plugin/
│   └── plugin.json      # References skills via "skills": "./skills/"
├── skills/              # Plugin skills directory
│   └── {skill-name}/
│       ├── SKILL.md     # Required: Skill definition with YAML frontmatter
│       └── LICENSE.txt  # Optional: License for third-party skills
└── commands/            # Existing slash commands
```

Each skill follows the standard SKILL.md format:
```yaml
---
name: skill-name
description: What it does and when to use it
---
# Skill content...
```

For third-party skills, we include:
- Original LICENSE.txt file
- Attribution comment in SKILL.md linking to source repository

## Consequences

**Positive:**
- Follows Claude Code's official plugin skills specification
- Skills are automatically discovered and available when plugin is installed
- Clear separation between skills (model-invoked) and commands (user-invoked)
- Third-party skills can be bundled with proper attribution

**Negative:**
- Adds another directory to maintain alongside `commands/`
- Must keep bundled third-party skills in sync with upstream changes

## Alternatives Considered

1. **Embed skills in CLAUDE.md**: Rejected because skills have specific format requirements (YAML frontmatter) and would bloat the rules file.

2. **Create slash commands for skills**: Rejected because skills are model-invoked (Claude decides when to use them) while commands are user-invoked.

3. **Store in `commands/_skills/`**: Rejected because Claude Code expects skills in a dedicated `skills/` directory referenced by plugin.json.

## Related

- Planning: `.plan/.done/feat-frontend-design-skill/`
- Claude Code Skills Docs: https://code.claude.com/docs/en/skills
- Source skill: https://github.com/anthropics/skills/tree/main/skills/frontend-design
