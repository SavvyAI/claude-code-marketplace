# Build in Public - Implementation Plan

## Summary

This feature adds a "build in public" capability to the Pro Plugin that automatically surfaces notable development moments and drafts shareable content for X and LinkedIn.

## What Was Implemented

### 1. Skill: `build-in-public`

**Location:** `pro/skills/build-in-public/SKILL.md`

A model-invoked skill that Claude uses automatically during development work. Key behaviors:

- Detects notable events (feature shipped, bug solved, milestone reached, etc.)
- Generates platform-specific drafts (X: 280 chars, LinkedIn: 1-3 paragraphs)
- Surfaces inline with approve/edit/defer/skip options
- Deduplicates via event IDs to avoid re-surfacing

### 2. Command: `/pro:bip`

**Location:** `pro/commands/bip.md`

A management command for reviewing the content queue:

- Dashboard view of pending and posted content
- Review flow for deferred items
- Configuration management
- Posted content history

### 3. File Structure Templates

**Location:** `pro/commands/_templates/build-in-public/`

Templates for initializing the `.plan/build-in-public/` directory:

- `config.json` - User preferences
- `events.json` - Event tracking
- `README.md` - Documentation

### 4. Architecture Decision Record

**Location:** `doc/decisions/021-build-in-public-skill-architecture.md`

Documents the design decisions:

- Skill vs command approach
- Storage location choice
- Deduplication strategy
- Threshold configuration

## File Changes

| File | Action |
|------|--------|
| `pro/skills/build-in-public/SKILL.md` | Created |
| `pro/commands/bip.md` | Created |
| `pro/commands/_templates/build-in-public/config.json` | Created |
| `pro/commands/_templates/build-in-public/events.json` | Created |
| `pro/commands/_templates/build-in-public/README.md` | Created |
| `doc/decisions/021-build-in-public-skill-architecture.md` | Created |
| `pro/.claude-plugin/plugin.json` | Updated (version bump) |
| `pro/readme.md` | Updated (new skill + command) |
| `.plan/backlog.json` | Updated (feature + v2 item) |

## Backlog Items

| ID | Title | Status |
|----|-------|--------|
| #18 | Build in Public - auto-surface shareable content | in-progress |
| #19 | Build in Public - voice/tone calibration | open (v2) |

## Configuration Options

```json
{
  "threshold": "medium",   // high | medium | low
  "platforms": ["x", "linkedin"],
  "autoSuggest": true
}
```

## Event Types

| Event | Trigger |
|-------|---------|
| `feature-shipped` | PR merged, feature branch completed |
| `bug-solved` | Fix committed after debugging |
| `refactor-complete` | Refactoring work finished |
| `milestone-reached` | Backlog milestone cleared |
| `design-decision` | ADR created, architectural choice |
| `learning` | Non-obvious discovery |
| `integration` | External service integrated |

## Next Steps

1. Test the skill by completing a feature
2. Verify the `/pro:bip` command works with pending items
3. Iterate on draft quality based on real usage
4. Consider v2 enhancements (voice calibration, auto-posting)

## Definition of Done

- [x] Skill implemented
- [x] Command implemented
- [x] Templates created
- [x] ADR documented
- [x] README updated
- [x] Version bumped
- [x] Backlog items created
