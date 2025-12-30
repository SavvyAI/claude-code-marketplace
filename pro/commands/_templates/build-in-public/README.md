# Build in Public

This directory contains your "build in public" content queue.

## Structure

```
build-in-public/
├── config.json     # Your preferences
├── events.json     # Tracked events (for deduplication)
├── pending/        # Deferred content proposals
│   └── YYYY-MM-DD-{slug}.md
└── posted/         # Approved content (your archive)
    └── YYYY-MM-DD-{slug}.md
```

## Configuration

Edit `config.json` to customize behavior:

```json
{
  "threshold": "medium",
  "platforms": ["x", "linkedin"],
  "autoSuggest": true
}
```

**Options:**
- `threshold`: `high`, `medium`, or `low` - controls how often content is suggested
- `platforms`: array of target platforms (`x`, `linkedin`)
- `autoSuggest`: whether to surface suggestions inline during work

**Thresholds:**
- `high` - Only major milestones (shipped features, hard bugs, ADRs)
- `medium` - Include learnings and smaller wins (default)
- `low` - Surface frequently, you curate

## How It Works

1. The `build-in-public` skill runs automatically during development
2. When notable moments occur, it proposes shareable content
3. You can approve, edit, defer, or skip
4. Deferred items are saved here for later review
5. Run `/pro:bip` to manage your queue

## Draft Format

Each draft is a markdown file with frontmatter:

```markdown
---
eventId: feat/auth|feature-shipped|a1b2c3
platforms: [x, linkedin]
surfacedAt: 2025-12-29T10:00:00Z
status: pending
---

# X Version

[Your 280-char post]

---

# LinkedIn Version

[Longer version]
```

## What Gets Tracked

The skill surfaces content for:
- Features shipped
- Bugs solved
- Refactors completed
- Milestones reached
- Design decisions made
- Learnings discovered
- Integrations completed

## Privacy

All content stays in your repo. Nothing is posted automatically.
You copy and paste to X/LinkedIn when ready.
