# 074. Clip Plugin Command Shims for Slash Command Discoverability

Date: 2026-05-06

## Status

Accepted

## Context

The `clip` plugin was implemented as a skill-only plugin (only `skills/` declared in `clip/.claude-plugin/plugin.json`).

In Claude Code, user-invocable slash commands are discovered from `commands/*.md`. As a result, `clip` appeared as installed, but its `/clip:*` entries did not show up in the command list.

We want `/clip:content` and related commands to be discoverable and runnable directly by users.

## Decision

Add a `commands/` directory to the `clip` plugin and register it in `clip/.claude-plugin/plugin.json` via `"commands": "./commands/"`.

Implement one command spec per intended `/clip:*` command (e.g. `clip/commands/content.md`, `clip/commands/content.summary.md`, etc.), keeping them intentionally thin: fetch/extract content, normalize output, and copy to clipboard.

## Consequences

### Positive

- `clip` commands become visible in the slash-command list, matching user expectations.
- The plugin remains portable and self-contained (no external project wiring).

### Negative

- Duplication risk: command specs and skill docs can drift if both describe the same behavior.
- The command specs are necessarily less detailed than the skills, to keep maintenance low.

## Alternatives Considered

### 1. Keep skill-only and rely on model invocation

Rejected because this does not satisfy the requirement that users can explicitly run `/clip:*` commands.

### 2. Teach users to invoke skills indirectly

Rejected because it is less discoverable and conflicts with the desired UX (slash-command list as source of truth).

## Related

- ADR-071: `doc/decisions/071-clip-plugin-content-capture-primitive.md`
- Planning: `.plan/fix-clip-plugin-not-showing-in-command-list/`
