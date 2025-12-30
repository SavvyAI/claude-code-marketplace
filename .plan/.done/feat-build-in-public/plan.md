# Build in Public - Implementation Plan

## Summary

Implement a "build in public" capability that automatically surfaces notable development moments and drafts shareable content for X and LinkedIn.

## Confirmed Requirements

1. **Skill-based auto-invocation** - Claude detects notable moments during work
2. **Inline suggestions with defer** - Surface proposals with approve/edit/defer/skip options
3. **Configurable threshold** - high/medium/low sensitivity
4. **Draft-only v1** - User manually copies to platforms
5. **Storage at `.plan/build-in-public/`** - Repo-first, version-controlled
6. **Fingerprint deduplication** - Avoid re-surfacing same events
7. **Pending queue** - Deferred items persist for later review

## Implementation Steps

### Phase 1: Design & Documentation
- [x] Create requirements document
- [x] Add backlog entry (ID #18)
- [x] Create ADR-021 (skill architecture)

### Phase 2: Skill Implementation
- [x] Create `pro/skills/build-in-public/SKILL.md`
- [x] Define event types and detection triggers
- [x] Specify draft generation guidelines
- [x] Document file operations

### Phase 3: Command Implementation
- [x] Create `/pro:bip` command for queue management
- [x] Define dashboard view
- [x] Implement review flow
- [x] Handle user actions (post/edit/skip/next/done)

### Phase 4: Templates
- [x] Create `_templates/build-in-public/` directory
- [x] Add `config.json` template
- [x] Add `events.json` template
- [x] Add `README.md` documentation

### Phase 5: Integration
- [x] Update `plugin.json` version (1.18.0 → 1.19.0)
- [x] Update `pro/readme.md` with new skill and command
- [x] Add voice calibration to backlog (ID #19, v2)

## Files Changed

| File | Change |
|------|--------|
| `pro/skills/build-in-public/SKILL.md` | New skill |
| `pro/commands/bip.md` | New command |
| `pro/commands/_templates/build-in-public/*` | New templates |
| `doc/decisions/021-build-in-public-skill-architecture.md` | New ADR |
| `pro/.claude-plugin/plugin.json` | Version bump |
| `pro/readme.md` | Documentation update |
| `.plan/backlog.json` | New items #18, #19 |

## Definition of Done

- [x] Skill implemented with event detection and draft generation
- [x] Command implemented for queue management
- [x] Templates created for file structure
- [x] ADR documented
- [x] README updated
- [x] Version bumped
- [x] Backlog updated (feature in-progress, v2 items tracked)
