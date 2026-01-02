# 032. Tiered Extraction Strategy and Image Intelligence for Weave Command

Date: 2026-01-02

## Status

Accepted

## Context

The `/author:weave` command needed robust handling of diverse content sources: social media URLs (LinkedIn, X/Twitter), Google Docs, image URLs, and PDFs. Each source type has different access patterns, authentication requirements, and failure modes.

Key challenges:
1. Social media platforms frequently block automated fetching (rate limits, login walls)
2. Google Docs may be private or require authentication
3. Image URLs need to be downloaded and stored locally for book portability
4. Authors need intelligent placement suggestions for images, not just raw insertion
5. Images need captions, and authors shouldn't have to write them from scratch

## Decision

### 1. Tiered Fallback Strategy for URL Extraction

Implement a three-tier fallback system for URL content extraction:

```
Tier 1: WebFetch (fast, no auth)
  ↓ if blocked/rate-limited
Tier 2: Browser Automation via Playwright MCP (uses user's session)
  ↓ if still blocked
Tier 3: Ask user to paste content
```

This applies to:
- **LinkedIn/X posts**: WebFetch → Playwright → User paste
- **Google Docs**: Public link → Playwright (user session) → Export guidance

### 2. Image Intelligence System

When processing images (local or from URLs):

1. **Auto-analysis** - Use Claude's vision to understand image content
2. **Auto-placement** - Match image themes to book chapter structure
3. **Caption suggestions** - Generate 3 contextually relevant captions
4. **Format selection** - Let user choose Markdown (`![...]()`) or HTML (`<figure>`)

### 3. Asset Management with Manifest

Store all images in `book/assets/images/` with a tracking manifest:

```json
{
  "assets": [{
    "id": "fig-001",
    "filename": "fig-001-diagram.png",
    "originalPath": "/original/path",
    "originalUrl": "https://...",
    "caption": "Selected caption",
    "format": "markdown|html",
    "usedIn": ["chapter-file.md"],
    "addedAt": "ISO-8601"
  }]
}
```

### 4. Per-URL Engagement Depth

For social media posts, ask whether to include comments/engagement:

```
question: "What content should I extract from this post?"
options:
  - "Post only"
  - "Post + comments"
```

## Consequences

### Positive

- **Robust access** - Multiple fallback options mean content is rarely inaccessible
- **Portable books** - All assets stored locally with manifest enables offline use
- **Reduced author friction** - Auto-generated captions and placement suggestions
- **Flexible output** - Authors choose their preferred image format

### Negative

- **Browser dependency** - Tier 2 requires Playwright MCP to be available
- **Increased complexity** - More code paths to maintain
- **User interaction** - Fallback to paste requires author effort

### Mitigations

- Playwright tools added to allowed-tools list for the command
- Clear error messages guide users when fallbacks activate
- Export guidance provided for Google Docs (File → Download)

## Alternatives Considered

### Single Extraction Method

Just use WebFetch for everything.

**Rejected because:**
- Social media platforms increasingly block automated access
- Would force users to always paste content manually

### Store Images by Reference Only

Don't copy images, just reference original URLs.

**Rejected because:**
- URLs can break over time
- Books should be portable and work offline
- No control over image availability

### No Caption Suggestions

Let users write all captions manually.

**Rejected because:**
- Adds friction to the weave workflow
- Claude can provide contextually relevant suggestions
- Users can still write custom captions via "Other"

## Related

- ADR-025: Writer Weave Command for Reference Integration (original weave design)
- ADR-029: Author Plugin Rename and Weave Consolidation
- Planning: `.plan/.done/feature-weave-robust-content-intake/`
