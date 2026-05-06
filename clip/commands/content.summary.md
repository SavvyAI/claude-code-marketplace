---
description: "Summarize a URL → Bullet key points + short abstract → Copy to clipboard"
allowed-tools: ["Bash", "WebFetch", "AskUserQuestion"]
---

# /clip:content.summary

Create a condensed summary for a URL and copy it to the clipboard.

## Usage

`/clip:content.summary <url>`

## Steps

1. Fetch and extract the primary content for the URL.
2. Produce Markdown with:
   - 1 short paragraph abstract (3-5 sentences)
   - 5-10 bullet key points
3. Copy the Markdown summary to the clipboard using `pbcopy`.

## Output

Respond with a short confirmation only.
