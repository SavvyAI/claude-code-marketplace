# Build in Public - Requirements

## Confirmed Scope (v1)

### What It Is
A Pro Plugin skill that automatically surfaces notable development moments and drafts shareable content for X and LinkedIn, without interrupting developer flow.

### Trigger Model
- **Skill-based auto-invocation**: Claude detects notable moments during normal development and surfaces proposals
- **No explicit invocation required**: The skill runs passively as part of development work
- **Command for management**: `/pro:bip` command to review pending/deferred items (reserved for later if needed)

### Surfacing UX
- **Inline suggestion with defer option**: After completing a notable action, Claude says something like "This might be worth sharing..." and shows a draft inline
- **Defer to queue**: User can say "defer" or "save for later" to add to pending queue without acting now
- **Approve/Edit/Ignore**: User can approve as-is, edit inline, or ignore entirely

### Confidence Threshold
- **Configurable** with sensible default (medium bar)
- Configuration stored in `.plan/build-in-public/config.json`
- High bar: Only major milestones (shipped features, hard bugs, design decisions)
- Medium bar (default): Include learnings, patterns, smaller wins
- Low bar: Surface frequently, user curates

### Posting
- **Draft only** (v1): Generate ready-to-post content in markdown files
- User manually copies to X/LinkedIn
- Posting integration deferred to future version

### Storage Location
- **`.plan/build-in-public/`**: Nested under existing .plan/ directory

### Deduplication
- **Track event IDs**: Prevent re-surfacing the same notable moment
- Event ID format: `{branch}|{event-type}|{context-hash}`
- Stored in `events.json`

### Deferred Items
- **Save to pending queue**: Deferred items saved to `pending/` directory
- Persist until explicitly acted on (approved, edited, or dismissed)

### Voice/Tone
- **Sensible default for v1**: "Build in public" authentic tone
- **Calibration deferred to v2**: Backlog item to add `/pro:bip.setup` for voice personalization

---

## File Structure

```
.plan/
  build-in-public/
    config.json           # User preferences (threshold, platforms, etc.)
    events.json           # Tracked event IDs (deduplication)
    pending/              # Deferred content proposals
      YYYY-MM-DD-{slug}.md
    posted/               # Approved/posted content archive
      YYYY-MM-DD-{slug}.md
    assets/               # Screenshots, images (future)
```

### config.json Schema

```json
{
  "threshold": "medium",
  "platforms": ["x", "linkedin"],
  "autoSuggest": true
}
```

### events.json Schema

```json
{
  "events": [
    {
      "eventId": "feat/build-in-public|feature-shipped|abc123",
      "surfacedAt": "2025-12-29T10:00:00Z",
      "status": "deferred|posted|ignored",
      "draftPath": "pending/2025-12-29-build-in-public-shipped.md"
    }
  ]
}
```

### Draft Markdown Format

```markdown
---
eventId: feat/build-in-public|feature-shipped|abc123
platforms: [x, linkedin]
surfacedAt: 2025-12-29T10:00:00Z
status: pending
---

# [X Version]

Just shipped Build in Public for Claude Code.

It watches your dev work and proposes posts when something interesting happens.

No context switching. Content is a byproduct of building.

---

# [LinkedIn Version]

Shipped a new feature today: Build in Public for Claude Code.

The idea is simple: instead of stopping work to think about content, the agent observes meaningful moments and proposes posts worth sharing.

Building in public shouldn't feel like a separate job.
```

---

## Notable Event Types

The skill should detect:

| Event Type | Example Trigger |
|------------|-----------------|
| `feature-shipped` | PR merged, feature branch completed |
| `bug-solved` | Fix committed after debugging session |
| `refactor-complete` | Refactoring work finished |
| `milestone-reached` | Backlog milestone cleared |
| `design-decision` | ADR created or significant architectural choice |
| `learning` | Non-obvious discovery during work |
| `integration` | Successfully integrated external service/API |

---

## Out of Scope (v1)

- Auto-posting to X/LinkedIn
- Voice/tone calibration
- Image generation
- Analytics feedback loop
- Algorithm-aware timing
- External sync (Notion, Airtable)

---

## Success Criteria

1. Developer shares more consistently without trying
2. Content feels authentic and grounded in real work
3. Flow is preserved, not interrupted
4. User trusts the system's judgment over time
