# 021. Build in Public Skill Architecture

Date: 2025-12-29

## Status

Accepted

## Context

Developers who want to "build in public" face consistent problems:

1. **Context switching kills flow** - Good moments happen while coding, not when sitting down to "do content"
2. **Content tools live outside the repo** - Airtable, Notion, schedulers don't understand code context
3. **People forget what was worth sharing** - By the time the day is over, the best moments are gone

We wanted to create a developer-native capability that turns visibility into a side effect of execution, not a separate chore.

Key design questions:
1. How should content be triggered - explicit command or automatic detection?
2. Where should state be stored?
3. How to balance signal vs noise?
4. How to handle content that isn't immediately posted?

## Decision

### Skill-Based Architecture

Build in Public is implemented as a **skill** (not a command) that Claude auto-invokes during normal development work.

**Why skill over command:**
- Skills are model-invoked; Claude decides when to use them based on context
- Fits the "zero friction" goal - no explicit invocation required
- Aligns with ADR-014 (Skills Directory) pattern

**Trigger model:**
- Claude detects "notable moments" during development
- Surfaces content proposal inline with defer option
- User can approve, edit, defer, or ignore

### Notable Event Types

| Event Type | Trigger |
|------------|---------|
| `feature-shipped` | PR merged, feature branch completed |
| `bug-solved` | Fix committed after debugging |
| `refactor-complete` | Refactoring work finished |
| `milestone-reached` | Backlog milestone cleared |
| `design-decision` | ADR created, architectural choice |
| `learning` | Non-obvious discovery |
| `integration` | External service integrated |

### Storage Location

All state stored under `.plan/build-in-public/`, consistent with ADR-015 (files over dashboards, repo-first).

```
.plan/
  build-in-public/
    config.json           # User preferences
    events.json           # Event IDs (deduplication)
    pending/              # Deferred proposals
      YYYY-MM-DD-{slug}.md
    posted/               # Approved content archive
      YYYY-MM-DD-{slug}.md
```

**Why `.plan/` subdirectory:**
- Keeps planning artifacts together
- Already gitignored patterns exist for runtime files
- Consistent with backlog.json, specs, etc.

### Deduplication via Event IDs

Each event gets a unique ID to prevent re-surfacing:
- Format: `{branch}|{event-type}|{context-hash}`
- Stored in `events.json`
- Checked before surfacing new proposals

### Configurable Threshold

User can configure signal sensitivity in `config.json`:

```json
{
  "threshold": "medium",   // high | medium | low
  "platforms": ["x", "linkedin"],
  "autoSuggest": true
}
```

- **high**: Only major milestones
- **medium** (default): Include learnings and smaller wins
- **low**: Surface frequently, user curates

### Draft-Only Output (v1)

v1 generates ready-to-post markdown; user manually copies to platform.

**Deferred to v2+:**
- Auto-posting to X/LinkedIn
- Voice/tone calibration
- Image generation
- Algorithm-aware timing

### Pending Queue

Deferred items are saved to `pending/` directory and persist until explicitly acted on.

**User actions:**
- Approve as-is
- Edit inline
- Defer to queue
- Ignore (not tracked)

### Optional Management Command

Reserved for future: `/pro:bip` command to review pending queue and manage posted history. Not required for v1 - the skill handles inline surfacing.

## Consequences

### Positive

- **Zero-friction content**: Proposals surface automatically during work
- **Flow preserved**: Inline suggestions with easy defer option
- **Repo-first**: All state version-controlled, no external dependencies
- **Signal over noise**: Configurable threshold prevents fatigue
- **Deduplication**: Won't re-surface the same moment

### Negative

- **Skill complexity**: Must teach Claude when moments are "notable"
- **Potential noise**: Even with threshold, may surface unwanted proposals
- **Manual posting**: v1 requires copy-paste to platforms

### Neutral

- No migration needed - new feature
- Follows existing patterns (skills, .plan/ storage)

## Alternatives Considered

### 1. Command-only approach

Rejected because:
- Requires explicit invocation, defeating the "zero friction" goal
- User must remember to run it
- Misses moments in the flow

### 2. External storage (Notion, Airtable)

Rejected because:
- Creates vendor lock-in
- Requires setup/credentials
- Doesn't fit repo-first philosophy

### 3. Auto-posting in v1

Rejected because:
- Requires OAuth setup for X/LinkedIn
- Higher stakes for mistakes
- User trust must be earned first

## Related

- ADR-014: Skills Directory for Bundled Agent Skills
- ADR-015: Audit, Backlog, and Roadmap Command Architecture
- ADR-017: Branch Naming Invariant (this is non-work-initiating)
- Backlog item #18: Build in Public feature
