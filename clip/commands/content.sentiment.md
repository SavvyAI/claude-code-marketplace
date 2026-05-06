---
description: "Analyze tone/sentiment of a URL → Copy to clipboard"
allowed-tools: ["Bash", "WebFetch", "AskUserQuestion"]
---

# /clip:content.sentiment

Analyze the tone and sentiment of a URL and copy the analysis to the clipboard.

## Usage

`/clip:content.sentiment <url>`

## Steps

1. Fetch and extract the primary content for the URL.
2. Produce Markdown with:
   - Overall sentiment (1 label)
   - Tone descriptors (3-6 adjectives)
   - Evidence: 3-5 short quotes (or paraphrased snippets if quoting is not allowed)
3. Copy the Markdown to the clipboard using `pbcopy`.

## Output

Respond with a short confirmation only.
