# Plan: `/pro:social` - Comprehensive Social Sharing Setup

## Summary

Create a meta-command that orchestrates complete social sharing setup across all major platforms. It wraps `/pro:og` functionality and adds missing pieces that cause sharing failures on platforms like LinkedIn.

## Requirements (Confirmed)

1. `/pro:social` is the **wrapper** - `/pro:og` remains as focused image-generation tool
2. Runs **unattended** where possible - inline OG generation logic rather than prompting
3. **Full schema.org detection** based on project type for JSON-LD
4. Support **Next.js, Vite, and plain HTML**
5. **Generate favicon/touch icons** from existing logo if missing

## Relevant ADRs

- **ADR-020**: Namespace hierarchy pattern (`command.subcommand`)
- **ADR-017**: Non-work-initiating command (no branch creation)

## Architecture Decision

### Single Command vs Namespace

Given the phases are tightly coupled and should run together, `/pro:social` should be a **single command** rather than a namespace (`social.audit`, `social.generate`, etc.). Users want comprehensive setup, not individual pieces.

### Integration with `/pro:og`

The `/pro:og` logic will be **inlined** into Phase 2 of `/pro:social` to enable unattended execution. The command file will reference the same discovery and generation patterns but skip interactive confirmations when context is clear.

## Implementation Phases

### Phase 1: Audit (Automated)

Scan and report existing state without prompting:

```
Scanning social metadata...

OpenGraph:
  ✓ og:title
  ✓ og:description
  ✗ og:url (REQUIRED for LinkedIn)
  ✗ og:site_name
  ✗ og:locale
  ✓ og:image (1200x630)

Twitter/X:
  ✓ twitter:card
  ✗ twitter:creator
  ✓ twitter:image

Assets:
  ✓ OG image exists
  ✗ favicon.ico missing
  ✗ apple-touch-icon.png missing
  ✓ logo.svg found (can generate icons)

Structured Data:
  ✗ No JSON-LD found

Score: 6/15 tags present
```

#### Detection Locations by Framework

| Framework | Metadata Location |
|-----------|-------------------|
| Next.js (App Router) | `app/layout.tsx` → `metadata` export |
| Next.js (Pages Router) | `pages/_app.tsx` or `pages/_document.tsx` |
| Vite/React | `index.html` `<head>` |
| Plain HTML | `index.html` `<head>` |

### Phase 2: OG Image Generation (Conditional)

Skip if acceptable OG image exists. Otherwise, inline `/pro:og` discovery:

1. Find branding assets (colors, logos)
2. Detect existing tagline/description
3. Generate image with ImageMagick (or provide specs if unavailable)
4. Save to `public/og-image.png` or equivalent

**Key difference from `/pro:og`**: No design confirmation prompt. Use sensible defaults:
- Background: Primary brand color or gradient
- Text: Site name + tagline
- Layout: Centered, safe-zone compliant

### Phase 3: Favicon/Touch Icon Generation (Conditional)

If missing and logo exists:

```bash
# From SVG
magick logo.svg -resize 32x32 public/favicon.ico
magick logo.svg -resize 180x180 public/apple-touch-icon.png
magick logo.svg -resize 192x192 public/icon-192.png
magick logo.svg -resize 512x512 public/icon-512.png

# From PNG (if no SVG)
magick logo.png -resize 32x32 public/favicon.ico
# ... etc
```

Update HTML/metadata with icon references.

### Phase 4: Metadata Configuration

Add/update all required meta tags:

#### OpenGraph (Required for LinkedIn, Facebook, Slack, Discord)

```html
<meta property="og:title" content="{title}">
<meta property="og:description" content="{description}">
<meta property="og:image" content="https://{domain}/og-image.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="{alt text}">
<meta property="og:url" content="https://{domain}/">
<meta property="og:type" content="website">
<meta property="og:site_name" content="{site name}">
<meta property="og:locale" content="en_US">
```

#### Twitter/X

```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="{title}">
<meta name="twitter:description" content="{description}">
<meta name="twitter:image" content="https://{domain}/og-image.png">
<meta name="twitter:creator" content="@{handle}">
```

#### Framework-Specific Implementation

**Next.js (App Router):**
```typescript
export const metadata: Metadata = {
  metadataBase: new URL('https://example.com'),
  title: 'Site Title',
  description: 'Description',
  openGraph: {
    title: 'Site Title',
    description: 'Description',
    url: 'https://example.com',
    siteName: 'Site Name',
    locale: 'en_US',
    type: 'website',
    images: [{
      url: '/og-image.png',
      width: 1200,
      height: 630,
      alt: 'Alt text',
    }],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Site Title',
    description: 'Description',
    creator: '@handle',
    images: ['/og-image.png'],
  },
  icons: {
    icon: '/favicon.ico',
    apple: '/apple-touch-icon.png',
  },
};
```

**Vite/Plain HTML:**
Direct `<meta>` tag insertion in `<head>`.

### Phase 5: Structured Data (JSON-LD)

Detect project type and add appropriate schema:

#### Detection Heuristics

| Signal | Schema Type |
|--------|-------------|
| `package.json` with app-like deps | SoftwareApplication |
| E-commerce indicators (cart, checkout) | Product + Organization |
| Blog structure (posts/, articles/) | Blog + Organization |
| Portfolio/agency | Organization + WebSite |
| Default | Organization + WebSite |

#### Base Schema (Always)

```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "{site name}",
  "url": "https://{domain}/",
  "description": "{description}"
}
```

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "{org name}",
  "url": "https://{domain}/",
  "logo": "https://{domain}/logo.png"
}
```

#### Conditional Schemas

**SoftwareApplication** (for web apps):
```json
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "{app name}",
  "applicationCategory": "WebApplication",
  "operatingSystem": "Web Browser"
}
```

### Phase 6: Validation & Guidance

Output testing resources:

```
Social sharing setup complete!

Test your previews:
  - LinkedIn: https://www.linkedin.com/post-inspector/
  - Twitter/X: https://cards-dev.twitter.com/validator
  - Facebook: https://developers.facebook.com/tools/debug/
  - General: https://opengraph.xyz

Cache-busting:
  - LinkedIn: Paste URL in Post Inspector, click "Inspect"
  - Twitter: Validator auto-refreshes
  - Facebook: Click "Scrape Again"
  - Slack: Wait ~30min or re-paste URL
  - iMessage: May require device restart

Local preview:
  open public/og-image.png
```

## File Changes

| File | Change |
|------|--------|
| `pro/commands/social.md` | New command file |
| `doc/decisions/033-social-sharing-meta-command.md` | ADR documenting design |

## Implementation Steps

1. [ ] Create `pro/commands/social.md` with all 6 phases
2. [ ] Implement framework detection logic (Next.js App/Pages, Vite, HTML)
3. [ ] Implement metadata location detection per framework
4. [ ] Implement OG image generation (inline from og.md patterns)
5. [ ] Implement favicon/touch icon generation
6. [ ] Implement JSON-LD schema detection and generation
7. [ ] Add validation output and cache-busting guidance
8. [ ] Write ADR-033
9. [ ] Test with Next.js project
10. [ ] Test with Vite project
11. [ ] Test with plain HTML project

## Edge Cases

1. **No logo found**: Warn user, skip icon generation, provide guidance
2. **No ImageMagick**: Provide manual specs, suggest online tools
3. **Existing conflicting metadata**: Report conflicts, ask user preference
4. **No production URL known**: Prompt for domain, store in config
5. **Monorepo with multiple apps**: Detect and ask which app to configure

## Success Criteria

- [ ] Audit accurately detects all existing metadata
- [ ] OG image generated without prompts (when logo/colors available)
- [ ] Favicons generated from logo
- [ ] All platform-specific meta tags configured
- [ ] JSON-LD added based on detected project type
- [ ] Works with Next.js, Vite, and plain HTML
- [ ] Validation links and cache-busting guidance provided
