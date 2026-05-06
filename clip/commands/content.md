---
description: "Extract URL content → Normalize to clean Markdown → Copy to clipboard"
allowed-tools: ["Bash", "WebFetch", "AskUserQuestion"]
---

# /clip:content

Extract content from a URL with formatting, links, and structure intact, then copy to clipboard.

## Usage

`/clip:content <url>`

## Steps

1. Fetch and extract the primary content for the URL (article/thread/discussion).
2. Normalize into clean Markdown:
   - Preserve heading hierarchy (H1/H2/H3)
   - Preserve lists, blockquotes, tables, and code blocks
   - Convert links to `[text](url)`
   - Include byline/date when available
3. Copy the final Markdown to the clipboard using `pbcopy`.

## Output

Respond with a short confirmation only (do not paste the full content back into chat).
