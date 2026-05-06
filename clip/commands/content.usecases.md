---
description: "Extract use-cases/opportunities from a URL → Copy to clipboard"
allowed-tools: ["Bash", "WebFetch", "AskUserQuestion"]
---

# /clip:content.usecases

Extract practical use-cases and opportunities from a URL and copy them to the clipboard.

## Usage

`/clip:content.usecases <url>`

## Steps

1. Fetch and extract the primary content for the URL.
2. Produce Markdown with:
   - A short framing paragraph
   - A bulleted list of concrete use-cases (actionable, specific)
   - If relevant, a "Who benefits" line per use-case
3. Copy the Markdown to the clipboard using `pbcopy`.

## Output

Respond with a short confirmation only.
