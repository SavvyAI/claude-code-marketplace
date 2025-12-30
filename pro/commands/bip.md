---
description: "Review pending content? → Shows deferred posts and posted history → Manage your build-in-public queue"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob"]
---

## Context

Manage your Build in Public content queue.

## Your Task

### 1. Check for Build in Public Directory

Look for `.plan/build-in-public/`. If it doesn't exist:

```
No Build in Public content yet.

The build-in-public skill automatically surfaces content proposals
when notable moments occur during development. Keep building!

To configure: create .plan/build-in-public/config.json with:
{
  "threshold": "medium",   // high | medium | low
  "platforms": ["x", "linkedin"],
  "autoSuggest": true
}
```

### 2. Display Dashboard

Show a summary of the content queue:

```
═══════════════════════════════════════════════════
  BUILD IN PUBLIC                      project-name
═══════════════════════════════════════════════════

📝 PENDING (3)
  1. [2025-12-29] Feature: Auth flow shipped
  2. [2025-12-28] Learning: Race condition debugging
  3. [2025-12-27] Integration: Stripe connected

✓ RECENTLY POSTED (5)
  └─ [2025-12-26] Bug: Payment retry logic
  └─ [2025-12-25] Feature: User onboarding
  └─ ... 3 more

⚙️ CONFIG
  threshold: medium
  platforms: x, linkedin

═══════════════════════════════════════════════════
```

### 3. Offer Actions

```
What would you like to do?

1. Review pending - Go through deferred items one by one
2. View posted - Browse your content history
3. Configure - Update preferences
```

### 4. Review Pending Flow

For each pending item, display:

```
───────────────────────────────────────────────────
📝 [1/3] Auth flow shipped
   Surfaced: 2025-12-29 | Branch: feat/auth
───────────────────────────────────────────────────

**X Version:**
> Built passwordless auth with magic links.
> The UX win: users sign in faster than typing a password.

**LinkedIn Version:**
> Shipped passwordless authentication today.
>
> Magic links sound simple, but the edge cases are tricky:
> - Link expiry timing
> - Multi-device sessions
> - Email deliverability
>
> The result: 40% faster sign-in flow.

───────────────────────────────────────────────────
[post] Copy to clipboard  [edit] Modify  [skip] Remove  [next] Continue
```

### 5. Handle User Actions

| Action | Behavior |
|--------|----------|
| `post` / `approve` | Move file from `pending/` to `posted/`, update frontmatter (`status: posted`, add `postedAt`), update `events.json`, display content for copy |
| `edit` | Let user modify, save updated version in place |
| `skip` / `remove` | Delete from `pending/`, update `events.json` status to `ignored` |
| `next` | Move to next item without changing current |
| `done` | Exit review |

**Note:** The `post` action moves the file (not copies) and updates the frontmatter. The file's `status` field is the source of truth.

### 6. View Posted Flow

Show recent posted content with dates and platforms:

```
✓ POSTED CONTENT

[2025-12-26] Bug: Payment retry logic
  Platforms: x, linkedin
  Preview: "Fixed a subtle bug in payment retries..."

[2025-12-25] Feature: User onboarding
  Platforms: x
  Preview: "Shipped the new onboarding flow..."
```

### 7. Configure Flow

Show current config and allow updates:

```
Current configuration:

  threshold: medium
  platforms: x, linkedin
  autoSuggest: true

What would you like to change?
1. threshold - How often to surface suggestions
2. platforms - Which platforms to draft for
3. autoSuggest - Whether to suggest inline during work
```

## File Operations

### Reading State

- `config.json` - User preferences
- `events.json` - Event history
- `pending/*.md` - Deferred content
- `posted/*.md` - Approved content

### Writing State

When moving from pending to posted:
1. Read the pending draft
2. Update status in frontmatter to `posted`
3. Add `postedAt` timestamp
4. Move file from `pending/` to `posted/`
5. Update `events.json` with new status

## Edge Cases

- **Empty queue**: "No pending content. Keep building!"
- **Config missing**: Use defaults, offer to create
- **Corrupted files**: Warn and skip, don't crash
