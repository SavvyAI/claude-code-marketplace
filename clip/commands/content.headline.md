---
description: "Generate a cohesive headline from a URL → Copy to clipboard"
allowed-tools: ["Bash", "WebFetch", "AskUserQuestion"]
---

# /clip:content.headline

Generate a single cohesive headline for a URL, then copy it to the clipboard.

## Usage

`/clip:content.headline <url>`

## Steps

1. Fetch and extract the primary content for the URL.
2. Produce exactly one headline (no quotes, no prefixes).
3. Copy the headline to the clipboard using `pbcopy`.

## Output

Respond with a short confirmation only.
