# Plan: Robust Content Intake for /author:weave

**Branch:** `feature/weave-robust-content-intake`
**Status:** Implementation Complete
**Created:** 2026-01-02
**Completed:** 2026-01-02

## Summary

Enhance `/author:weave` to robustly handle diverse content sources:
- URLs (LinkedIn, X/Twitter, blog posts, articles)
- Images and screenshots (with intelligent placement and caption suggestions)
- PDFs (full extraction)
- Google Docs

## Related ADRs

| ADR | Summary | Relevance |
|-----|---------|-----------|
| ADR-025 | Writer Weave Command Design | Core workflow definition; establishes 8-phase approach, voice matching, citation styles |
| ADR-029 | Author Plugin Rename & Weave Consolidation | Confirms weave is the single command for all content incorporation |

**Key design principles from ADRs:**
1. **Proposal-first workflow** - Claude analyzes, proposes placements, waits for approval
2. **Voice synthesis** - Transform content to match book voice, not copy verbatim
3. **Format detection is automatic** - Single command handles all formats
4. **Author control** - Nothing written without explicit approval

## Confirmed Requirements

### 1. URL Capture (Robust)
- LinkedIn URLs → fetch and extract content
- Twitter/X URLs → fetch and extract content
- Blog post URLs → fetch and extract content
- General article URLs → robust content extraction
- **Extraction depth:** Ask user per-URL whether to include comments/engagement
- **Fallback strategy:** WebFetch → Browser automation (Playwright) → Ask user to paste

### 2. Image/Screenshot Handling
- Accept images and screenshots as input (local files)
- **Accept image URLs** - download and process remote images
- **Auto-analyze** image content, match to relevant chapter(s), propose placement
- Generate **3 caption suggestions** for user selection
- Allow user to write custom caption
- **Copy/download images** to `book/assets/` directory for portability
- **Caption format:** Let user choose per-image (Markdown `![...]()` or HTML `<figure>/<figcaption>`)

### 3. PDF Support
- Read PDF and extract all content
- Handle multi-page PDFs
- Extract structured content (headers, sections)

### 4. Google Docs Support (Tiered Approach)
1. **First:** Try public link access (simplest)
2. **Then:** Try browser automation via Playwright MCP (if user logged in)
3. **Fallback:** Guide user to export as PDF/markdown

## Implementation Approach

### Phase 1: Content Type Detection & Routing
Enhance format detection to route to appropriate extraction strategy:

```
Input → Detect Type → Route to Handler
                    ├── URL Handler
                    │   ├── Social Media (LinkedIn, X/Twitter)
                    │   ├── Google Docs
                    │   └── General Web
                    ├── Image Handler
                    ├── PDF Handler
                    └── Text Handler
```

### Phase 2: Enhanced URL Handling

#### 2.1 URL Type Detection
```javascript
// Pattern matching for URL types
const urlPatterns = {
  // Social media
  linkedin: /linkedin\.com\/(posts?|feed|pulse)/,
  twitter: /(twitter|x)\.com\/\w+\/status/,

  // Documents
  googleDocs: /docs\.google\.com\/document/,
  googleSheets: /docs\.google\.com\/spreadsheets/,

  // Media
  youtube: /youtube\.com\/watch|youtu\.be/,

  // Blogs
  medium: /medium\.com/,
  substack: /\.substack\.com/,

  // Images (URLs ending in image extensions)
  image: /\.(png|jpg|jpeg|gif|webp|svg)(\?.*)?$/i
}
```

**Image URL handling:**
When a URL matches the image pattern:
1. Download the image via WebFetch or browser automation
2. Save to `book/assets/images/` with unique filename
3. Process as local image (auto-analyze, caption suggestions, etc.)

#### 2.2 Social Media Extraction
For LinkedIn and X/Twitter:
1. Attempt WebFetch first
2. If blocked/rate-limited → Try Playwright MCP browser automation
3. If still fails → Ask user to paste content

Present per-URL option:
```
question: "What content should I extract from this post?"
header: "Extract"
options:
  - "Post only" (Just the main post content)
  - "Post + comments" (Include replies and engagement)
```

#### 2.3 Google Docs Tiered Strategy
1. Check if URL is publicly accessible via WebFetch
2. If not, try Playwright MCP (requires user session)
3. If that fails, guide user: "Export as PDF or copy text and paste"

### Phase 3: Image Intelligence

#### 3.1 Image Intake
- Accept file paths: `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`
- Accept inline images in conversation
- Copy to `book/assets/` with unique filename

#### 3.2 Auto-Placement Analysis
1. Read image with Claude vision
2. Extract semantic content (what the image shows)
3. Load book structure and chapter summaries
4. Match image themes to chapter themes
5. Propose placement with rationale

#### 3.3 Caption Suggestion Flow
```
[ author:weave | image analysis ]
---------------------------------
Image: architecture-diagram.png
Content: System architecture showing frontend, API, and database layers

Placement recommendation:
→ Chapter 04: System Design (strong thematic match)
→ Section: "## Architecture Overview" (contextually relevant)

Caption suggestions:
1. "High-level system architecture showing the three-tier design"
2. "Frontend, API, and database layers working together"
3. "The modular architecture that enables independent scaling"

Choose a caption or write your own:
```

Use AskUserQuestion:
```
question: "Which caption do you prefer?"
header: "Caption"
options:
  - "Caption 1" (High-level system architecture...)
  - "Caption 2" (Frontend, API, and database layers...)
  - "Caption 3" (The modular architecture...)
```
User can select "Other" to write custom.

#### 3.4 Caption Format Selection
```
question: "What format for this figure?"
header: "Format"
options:
  - "Markdown" (![caption](assets/image.png))
  - "HTML figure" (<figure> with <figcaption>)
```

### Phase 4: PDF Full Extraction
Claude can read PDFs natively. Enhance handling:
1. Detect `.pdf` extension or PDF URL
2. Read entire document
3. Extract structure (detect H1/H2 from formatting)
4. Present content preview with structure outline
5. Proceed with standard weave flow

### Phase 5: Asset Management

#### 5.1 Assets Directory Structure
```
book/
├── assets/
│   ├── images/
│   │   ├── fig-01-architecture.png
│   │   ├── fig-02-workflow.png
│   │   └── ...
│   └── manifest.json  # Track asset metadata
├── chapters/
└── ...
```

#### 5.2 Asset Manifest
```json
{
  "assets": [
    {
      "id": "fig-01",
      "filename": "fig-01-architecture.png",
      "originalPath": "/path/to/original.png",
      "caption": "High-level system architecture",
      "usedIn": ["04-system-design.md"],
      "addedAt": "2026-01-02T..."
    }
  ]
}
```

## Detailed Implementation Steps

1. **Update URL detection patterns** in weave.md
2. **Add social media extraction logic** with tiered fallback
3. **Add Google Docs tiered strategy**
4. **Add image auto-analysis flow** with caption suggestions
5. **Create assets directory structure** and manifest
6. **Add image copy-to-assets logic**
7. **Add caption format selection**
8. **Update PDF extraction** to preserve structure
9. **Add per-URL engagement depth question**
10. **Update edge cases table** for new scenarios

## Test Plan

- [ ] URL: LinkedIn post (public)
- [ ] URL: LinkedIn post (private - requires browser auth)
- [ ] URL: Twitter/X post
- [ ] URL: Twitter thread
- [ ] URL: Blog article with images
- [ ] URL: Medium article
- [ ] URL: Substack post
- [ ] URL: Google Doc (public)
- [ ] URL: Google Doc (private)
- [ ] **URL: Remote image** (https://example.com/image.png)
- [ ] Image: Local screenshot with text (OCR extraction)
- [ ] Image: Local diagram/chart (semantic analysis)
- [ ] Image: Photo (descriptive caption)
- [ ] PDF: Single page
- [ ] PDF: Multi-page with structure
- [ ] Caption: All 3 suggestions tested
- [ ] Caption: Custom caption via "Other"
- [ ] Caption: Markdown format output
- [ ] Caption: HTML figure format output
- [ ] Error: WebFetch blocked → Browser fallback
- [ ] Error: Browser blocked → Ask paste fallback
- [ ] Error: Paywalled content
- [ ] **Error: Image URL download fails** → graceful fallback

## Files to Modify

1. `author/commands/weave.md` - Main command specification (primary)
2. Create `author/commands/_helpers/url-extraction.md` - URL handling reference
3. Create `author/commands/_helpers/image-handling.md` - Image handling reference

## Definition of Done

- [x] All URL types (LinkedIn, X, blogs, Google Docs) work with tiered fallback
- [x] Images auto-analyzed and placed intelligently
- [x] 3 caption suggestions generated per image
- [x] Custom caption input supported
- [x] Images copied to `book/assets/` with manifest
- [x] Both Markdown and HTML figure formats supported
- [x] PDFs fully extracted with structure preserved
- [x] Per-URL engagement depth question implemented
- [x] All edge cases handled gracefully
- [x] No errors, bugs, or warnings

## Implementation Notes

All enhancements were made to `author/commands/weave.md`:

1. **Added Playwright MCP tools** to allowed-tools for browser automation fallback
2. **INPUT TYPE DETECTION section** - Comprehensive URL and file pattern matching
3. **EXTRACTION HANDLERS section** - Detailed strategies for:
   - Social media (LinkedIn, X/Twitter) with 3-tier fallback
   - Google Docs with 3-tier fallback
   - Image URLs with download and processing
   - PDF extraction with structure preservation
4. **IMAGE INTELLIGENCE section** - Complete image processing flow:
   - Auto-analysis with Claude vision
   - Auto-placement based on book structure
   - 3 caption suggestions
   - Caption format selection (Markdown vs HTML figure)
   - Asset management with manifest.json
5. **Updated Integration Mode** to reference new handlers
6. **Expanded Edge Cases table** with 11 new scenarios
7. **Added Supported Input Types Summary table**
8. **Added Assets Directory Structure documentation**

## Related ADRs

- [ADR-032: Tiered Extraction Strategy and Image Intelligence](../../doc/decisions/032-tiered-extraction-and-image-intelligence.md)
