---
description: "Need social sharing previews? → Gathers brand context through guided questions → Creates professional OG images and metadata"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
---

## Context

Create or update Open Graph (OG) image and social sharing metadata for: $ARGUMENTS

## Your Task

### Phase 1: Discovery

Scan the project to understand existing state:

1. **Branding assets** - Look for:
   - `**/branding.md`, `**/brand-guide.md`, `**/brand*.md`
   - Design tokens, CSS variables with brand colors
   - Existing logos (`logo.svg`, `logo.png`, `favicon.*`)

2. **Existing OG image** - Look for:
   - `public/social-sharing.png`, `public/og-image.png`, `public/og*.png`
   - References in HTML/config to OG images

3. **Meta tag location** - Identify where OG tags live:
   - `index.html` (Vite, vanilla)
   - `app/layout.tsx` or `next.config.js` (Next.js)
   - Framework-specific config files

4. **Available image tools** - Check for:
   - ImageMagick (`magick` or `convert`)
   - Node canvas libraries in `package.json`
   - Sharp or other image processing deps

Report findings to the user before proceeding.

### Phase 2: Clarification

Ask the user about anything not discovered automatically:

- **Brand name** - Exactly as it should appear (e.g., `oneresu.me`)
- **Brand colors** - Primary, secondary, gradient (hex values)
- **Headline text** - The main message (e.g., "Resumes That Actually Get Seen")
- **Visual element** - Product screenshot, logo, illustration, or none
- **Target platforms** - LinkedIn, Twitter/X, iMessage, Slack, Discord, etc.

Confirm the following specs (or ask if unclear):
- Dimensions: 1200 × 630px (standard OG)
- Format: PNG
- Safe zone: Center 1080 × 566px (some platforms crop edges)

### Phase 3: Design

Create a design specification:

1. **ASCII mockup** of the layout showing:
   - Background treatment (solid, gradient, image)
   - Text placement and hierarchy
   - Visual element positioning
   - Brand URL placement

2. **Color specification** with exact hex values

3. **Typography** recommendations (system fonts for ImageMagick compatibility)

Get user approval on the design before generating.

### Phase 4: Generate

Based on available tools:

**If ImageMagick available:**
- Generate the image using `magick` commands
- Use a multi-step pipeline: background → visual element → text overlays
- Save to the appropriate `public/` location

**If no image tools available:**
- Provide detailed specifications for manual creation
- Suggest free tools (Figma, Canva, etc.)
- Offer to create a Figma-compatible spec

### Phase 5: Metadata Update

Update the project's meta tags:

```html
<!-- Open Graph -->
<meta property="og:image" content="https://{domain}/social-sharing.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:title" content="{title}">
<meta property="og:description" content="{description}">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://{domain}/social-sharing.png">
<meta name="twitter:title" content="{title}">
<meta name="twitter:description" content="{description}">
```

Ensure URLs are absolute (not relative paths).

### Phase 6: Verification

Provide the user with:

1. **Testing checklist:**
   - [ ] LinkedIn Post Inspector: https://www.linkedin.com/post-inspector/
   - [ ] Twitter Card Validator: https://cards-dev.twitter.com/validator
   - [ ] Facebook Sharing Debugger: https://developers.facebook.com/tools/debug/
   - [ ] opengraph.xyz for general preview

2. **Cache-busting notes:**
   - LinkedIn: Use Post Inspector to force re-scrape
   - Twitter: Validator forces refresh
   - iMessage: May require device restart or waiting
   - Slack: Re-paste link or wait for cache expiry

3. **Local preview command** (if applicable):
   ```bash
   open public/social-sharing.png  # macOS
   ```

## Definition of Done

- [ ] OG image created at correct dimensions (1200 × 630px)
- [ ] Image uses brand colors and messaging
- [ ] Meta tags updated with absolute URLs
- [ ] User has verified image displays correctly
- [ ] Testing checklist provided
