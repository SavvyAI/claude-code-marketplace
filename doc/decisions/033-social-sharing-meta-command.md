# 033. Social Sharing Meta-Command Architecture

Date: 2026-01-02

## Status

Accepted

## Context

The existing `/pro:og` command handles OG image generation but leaves gaps in metadata that cause sharing failures on platforms like LinkedIn. Users discovered this when `/pro:og` completed successfully but LinkedIn previews still broke due to missing `og:url`, `og:site_name`, and `og:locale` tags.

Additionally, social sharing setup requires:
- Favicon and touch icon generation
- Structured data (JSON-LD) for rich previews
- Platform-specific validation and cache-busting guidance

Users don't know what's missing until they share and see broken previews.

## Decision

Create `/pro:social` as a **meta-command** that orchestrates complete social sharing setup:

### Architecture: Single Command, Not Namespace

Unlike `/pro:audit` which has sub-commands (`audit.quality`, `audit.security`), `/pro:social` is a **single command** because:

1. The phases are tightly coupled - users want complete setup, not individual pieces
2. The audit phase informs all subsequent phases
3. Running phases independently would require repeated discovery

### Six-Phase Execution

1. **Audit** - Scan existing metadata, report gaps with severity
2. **OG Image** - Generate branded image (inline `/pro:og` logic for unattended execution)
3. **Favicons** - Generate from logo if missing
4. **Metadata** - Configure all platform-specific meta tags
5. **Structured Data** - Add JSON-LD based on detected project type
6. **Validation** - Provide testing links and cache-busting guidance

### Unattended Execution

Unlike `/pro:og` which uses interactive confirmation, `/pro:social` runs unattended where possible:

- Uses sensible defaults for OG image design
- Only prompts when critical information is missing (domain, site name)
- Skips phases when assets already exist and are acceptable

### Framework Support

Supports multiple frameworks with detection logic:

| Framework | Metadata Location |
|-----------|-------------------|
| Next.js App Router | `app/layout.tsx` metadata export |
| Next.js Pages Router | `pages/_document.tsx` |
| Vite | `index.html` head |
| Plain HTML | `index.html` head |

### Relationship to `/pro:og`

`/pro:og` remains as a focused, interactive image-generation tool. `/pro:social` inlines similar logic but:
- Skips design confirmation prompts
- Uses discovered branding automatically
- Is part of a larger workflow

## Consequences

### Positive

- **Complete solution** - Users get everything needed for social sharing in one command
- **Platform coverage** - LinkedIn, Twitter/X, Facebook, Slack, Discord, iMessage all work
- **Unattended execution** - Minimal prompts, maximum automation
- **Discovery-first** - Audit reveals gaps before making changes
- **Framework-aware** - Works with modern frameworks (Next.js) and plain HTML

### Negative

- **Large command file** - Six phases in one file is substantial
- **Overlap with `/pro:og`** - Some logic duplication for unattended execution
- **ImageMagick dependency** - Image generation requires external tool

### Neutral

- Non-work-initiating command (no branch creation per ADR-017)
- Follows existing command patterns in the plugin

## Alternatives Considered

### 1. Enhance `/pro:og` with all phases

**Rejected because:**
- Would bloat a focused image-generation tool
- Breaks single-responsibility principle
- Interactive confirmation model doesn't suit comprehensive setup

### 2. Namespace hierarchy (`social.audit`, `social.generate`, etc.)

**Rejected because:**
- Users want complete setup, not individual pieces
- Audit informs all other phases - can't run independently
- Adds complexity without clear benefit

### 3. Make `/pro:og` call `/pro:social`

**Rejected because:**
- Inverts the dependency (simple tool calling complex one)
- Users who just want an image shouldn't get full metadata setup

## Related

- ADR-020: Audit Command Namespace Hierarchy (pattern reference)
- ADR-017: Branch Naming Invariant (non-work-initiating classification)
- `/pro:og` command (focused image generation)
- Backlog #48: Comprehensive social sharing setup command
