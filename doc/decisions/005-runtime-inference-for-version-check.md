# 005. Runtime Inference for Version Check

Date: 2025-12-22

## Status

Accepted

## Context

Version numbers in plugin manifests were sometimes not updated before PRs. We needed a way to remind developers to bump versions during the PR workflow.

The initial implementation hardcoded a detection table mapping 12+ ecosystems (Node.js, Rust, Python, Ruby, etc.) to their version file locations and extraction methods. This approach had maintenance overhead and would require updates for new ecosystems.

## Decision

Use runtime inference instead of a hardcoded detection table. The `/pro:pr` command now:

1. Provides hints about common version file locations (package.json, Cargo.toml, pyproject.toml, etc.)
2. Lets the AI infer which file contains the version based on what exists in the project
3. Lets the AI determine how to extract and update the version based on the file format

## Consequences

**Positive:**
- Simpler prompt (44 lines vs 72 lines)
- Handles any ecosystem without prompt updates
- AI can adapt to edge cases and non-standard setups
- No maintenance burden for the detection table

**Negative:**
- Relies on AI knowledge of ecosystems (minor risk - well-known patterns)
- Slightly less deterministic than explicit rules

## Alternatives Considered

1. **Hardcoded detection table** - Mapped each ecosystem to its version file and extraction command. Rejected because it required ongoing maintenance and couldn't handle new/unusual setups.

2. **Ecosystem CLI tools** - Use `npm version`, `cargo pkgid`, etc. Rejected because it requires tools to be installed, which isn't always the case.

3. **Separate /pro:version command** - Dedicated command for version management. Deferred until a real need emerges; integrating into `/pro:pr` is sufficient.

## Related

- Planning: `.plan/.done/feat-pr-version-check/`
