# Feature: Bundle Anthropic Frontend-Design Skill

## Summary

Include the Anthropic `frontend-design` skill from their open-source [skills repository](https://github.com/anthropics/skills) so that users of the ccplugins plugin automatically have access to production-grade frontend design guidance.

## Requirements

1. **Integration**: Use the official Claude Code plugin skills pattern (`skills/` directory at plugin root)
2. **Activation**: Always active when plugin is installed (automatic discovery)
3. **License**: Include original LICENSE.txt with proper attribution
4. **No companion command**: Skill operates passively through bundled rules

## Design Decisions

### Directory Structure

Following the official Claude Code plugin skills pattern documented at [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills):

```
pro/
├── .claude-plugin/
│   └── plugin.json           # Add "skills": "./skills/" reference
├── commands/                  # Existing commands
├── skills/                    # NEW: Plugin skills directory
│   └── frontend-design/      # Anthropic's skill
│       ├── SKILL.md          # Skill definition (converted format)
│       └── LICENSE.txt       # Original Anthropic license
└── CLAUDE.md                  # Existing bundled rules
```

### SKILL.md Format

Convert from Anthropic's format to Claude Code's required format:

```yaml
---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use when building web components, pages, dashboards, React components, HTML/CSS layouts, or styling any web UI.
---

# Frontend Design

[Full content from Anthropic's SKILL.md]
```

### Attribution

Add attribution comment in SKILL.md header:
```markdown
<!--
  Source: https://github.com/anthropics/skills/tree/main/skills/frontend-design
  Author: Anthropic
  License: See LICENSE.txt
-->
```

## Implementation Steps

1. **Create skills directory structure**
   - Create `/pro/skills/frontend-design/`

2. **Add SKILL.md**
   - Convert Anthropic's content to required YAML frontmatter format
   - Add source attribution comment

3. **Add LICENSE.txt**
   - Fetch original license from Anthropic repo

4. **Update plugin.json**
   - Add `"skills": "./skills/"` field

5. **Update plugin readme**
   - Document the bundled skill

6. **Verify**
   - Ensure skill is discoverable
   - Test that Claude can use it for frontend tasks

## Files to Create/Modify

| File | Action | Description |
|------|--------|-------------|
| `pro/skills/frontend-design/SKILL.md` | Create | Skill definition with Anthropic content |
| `pro/skills/frontend-design/LICENSE.txt` | Create | Original Anthropic license |
| `pro/.claude-plugin/plugin.json` | Modify | Add skills directory reference |
| `pro/readme.md` | Modify | Document bundled skill |

## Success Criteria

- [x] `skills/frontend-design/SKILL.md` exists with proper frontmatter
- [x] `skills/frontend-design/LICENSE.txt` includes Anthropic license
- [x] `plugin.json` references skills directory
- [x] Plugin readme documents the bundled skill
- [x] No errors or warnings

## Related ADRs

- [014. Skills Directory for Bundled Agent Skills](../../doc/decisions/014-skills-directory-for-bundled-agent-skills.md)
