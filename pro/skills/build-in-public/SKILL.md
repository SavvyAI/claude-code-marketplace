---
name: build-in-public
description: Automatically surface notable development moments and draft shareable content. Use when completing features, solving bugs, making design decisions, or reaching milestones. Proposes posts for X and LinkedIn without interrupting developer flow.
---

# Build in Public

Turn building into content, automatically.

## Core Purpose

This skill observes development work and proposes shareable content when notable moments occur. It surfaces posts inline during normal work, allowing developers to "build in public" without context switching.

**Key principle:** Content is a byproduct of execution, not a separate chore.

## When to Invoke This Skill

Invoke this skill when any of these notable events occur:

| Event | Event ID | Example |
|-------|----------|---------|
| **Feature shipped** | `feature-shipped` | PR merged, feature branch completed, functionality working |
| **Bug solved** | `bug-solved` | Fix committed after meaningful debugging session |
| **Refactor complete** | `refactor-complete` | Code improvement finished |
| **Milestone reached** | `milestone-reached` | Backlog milestone cleared, sprint goal met |
| **Design decision** | `design-decision` | ADR created, significant architectural choice made |
| **Learning** | `learning` | Non-obvious discovery during work |
| **Integration** | `integration` | External service or API successfully integrated |

**Note:** The event ID format is `{branch}|{event-type}|{context-hash}` (e.g., `feat/auth|feature-shipped|a1b2c3`).

**Signal filter:** Apply the configured threshold (default: medium). Only surface content that passes the bar.

## Surfacing Content

When a notable moment is detected:

1. **Check deduplication** - Read `.plan/build-in-public/events.json` and skip if event ID exists
2. **Generate draft** - Create platform-specific drafts (X and LinkedIn)
3. **Surface inline** - Present the proposal with clear options

### Inline Suggestion Format

```
---

This might be worth sharing.

**What happened:** [Brief description of the notable event]

**Draft for X:**
> [Concise post, under 280 characters, authentic tone]

**Draft for LinkedIn:**
> [Slightly longer version, 1-3 paragraphs, professional but human]

**Options:**
- "approve" - Save to posted/ and display for copy
- "edit" - Modify the draft before saving
- "defer" - Save to pending/ for later review
- "skip" - Ignore this suggestion

---
```

### Draft Writing Guidelines

**Tone:**
- Authentic, not performative
- Focus on learning, progress, or insight
- No hype, marketing speak, or false modesty
- Write as if sharing with a peer

**Structure:**
- Lead with the insight or outcome
- Keep X posts under 280 characters
- LinkedIn can be 1-3 short paragraphs
- End with something memorable, not a call-to-action

**Avoid:**
- "Just shipped..." (overused opener)
- "Excited to announce..." (corporate speak)
- Thread bait or engagement farming
- Vague claims without substance

**Good examples:**
- "Spent 3 hours debugging a race condition. The fix was one line. The lesson: log timestamps, not just events."
- "Finished migrating from REST to GraphQL. Biggest surprise: the hard part wasn't the schema, it was teaching the team to think in graphs."

## File Operations

### Configuration

Read user preferences from `.plan/build-in-public/config.json`:

```json
{
  "threshold": "medium",
  "platforms": ["x", "linkedin"],
  "autoSuggest": true
}
```

**Options:**
- `threshold`: `high`, `medium`, or `low` - controls sensitivity
- `platforms`: target platforms for drafts
- `autoSuggest`: when `true` (default), surface suggestions inline during work; when `false`, only write to pending queue silently

If file doesn't exist, use defaults and create on first write.

### Event Tracking

Track surfaced events in `.plan/build-in-public/events.json`:

```json
{
  "events": [
    {
      "eventId": "feat/auth|feature-shipped|a1b2c3",
      "surfacedAt": "2025-12-29T10:00:00Z",
      "status": "posted",
      "draftPath": "posted/2025-12-29-auth-feature.md"
    }
  ]
}
```

**Event ID format:** `{branch}|{event-type}|{context-hash}`

- `branch`: Current git branch
- `event-type`: One of the event IDs from the table above
- `context-hash`: Short hash (first 7 chars of SHA) derived from the specific context (commit hash, PR title, or notable message)

**Draft paths:** Relative to `.plan/build-in-public/`. Use format `YYYY-MM-DD-{event-type}-{slugified-context}.md`.

### Draft Storage

Save drafts to `.plan/build-in-public/{status}/`:

```markdown
---
eventId: feat/auth|feature-shipped|a1b2c3
platforms: [x, linkedin]
surfacedAt: 2025-12-29T10:00:00Z
status: pending
---

# X Version

[280-char post]

---

# LinkedIn Version

[Longer post]
```

**File lifecycle:**
1. Created in `pending/` when deferred or auto-captured
2. Moved to `posted/` when approved (file physically moved, `status` updated to `posted`, `postedAt` timestamp added)
3. Frontmatter is the source of truth for status

## Threshold Guidelines

### High Bar (fewer, stronger)
Only surface for:
- Major feature shipped (not minor fixes)
- Hard bugs solved (hours of debugging)
- Significant design decisions (ADRs)
- Clear milestones (release, MVP)

### Medium Bar (balanced - default)
Also include:
- Interesting learnings during work
- Useful patterns discovered
- Smaller but notable wins
- Integration completions

### Low Bar (capture more)
Also include:
- Early progress updates
- Questions that led to answers
- Tool or library discoveries
- Work-in-progress shares

## User Responses

Handle these user responses:

| Response | Action |
|----------|--------|
| "approve" / "post" / "yes" | Move to `posted/`, display for copy |
| "edit" / "change" | Ask for edits, then save |
| "defer" / "later" / "save" | Move to `pending/` |
| "skip" / "no" / "ignore" | Record as ignored, don't save draft |

## Directory Structure

Ensure this structure exists (create if needed):

```
.plan/
  build-in-public/
    config.json           # User preferences
    events.json           # Event IDs for deduplication
    pending/              # Deferred drafts
    posted/               # Approved drafts
```

## Behavioral Notes

1. **Don't interrupt deep work** - Wait for natural pauses (commit, PR, test pass)
2. **One suggestion at a time** - Never batch multiple proposals
3. **Respect "skip"** - If user skips, move on without pushback
4. **Session-aware** - Check events.json each session to avoid duplicates
5. **Create directories lazily** - Only create files when needed

## Integration Points

This skill works alongside:
- `/pro:feature`, `/pro:bug`, etc. - Detect when work completes
- `/pro:pr` - Natural moment to surface "feature shipped" content
- `/pro:audit` - Could surface "milestone reached" when clean audit

## What This Skill Does NOT Do

- Post to X or LinkedIn (user copies manually)
- Store credentials or API tokens
- Track analytics or engagement
- Suggest optimal posting times
- Generate images or media

These are intentionally deferred to future versions.
