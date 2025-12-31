---
description: "Configure your voice? → Calibrate tone for build-in-public content → Personalized drafts that sound like you"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "WebFetch"]
---

## Context

Calibrate the voice and tone for your build-in-public content drafts.

## Your Task

### 1. Check for Existing Config

Read `.plan/build-in-public/config.json` if it exists. Show current voice settings if configured.

### 2. Offer Calibration Options

```
═══════════════════════════════════════════════════
  BUILD IN PUBLIC - VOICE SETUP
═══════════════════════════════════════════════════

How would you like to calibrate your voice?

1. Provide examples   - Paste 2-3 posts you've written that represent your style
2. Select a preset    - Choose from predefined voice styles
3. Import from URL    - Analyze your existing X/LinkedIn posts (provide profile URL)

Current config: [none | preset: casual-technical | custom from examples]
```

### 3. Option 1: Learn from Examples

Ask user to paste 2-3 example posts they've written. Analyze for:

- **Tone**: casual, professional, technical, conversational
- **Length preference**: concise vs. detailed
- **Punctuation style**: emoji usage, exclamation points, ellipses
- **Structure**: questions, lists, single statements
- **Vocabulary**: jargon level, acronyms, plain language

Store analysis in config:

```json
{
  "threshold": "medium",
  "platforms": ["x", "linkedin"],
  "autoSuggest": true,
  "voice": {
    "source": "examples",
    "tone": "casual-technical",
    "length": "concise",
    "emoji": "minimal",
    "traits": [
      "leads with insight",
      "uses technical terms without explanation",
      "ends with reflection, not CTA"
    ],
    "examples": [
      "example post 1...",
      "example post 2..."
    ]
  }
}
```

### 4. Option 2: Preset Styles

Offer these presets:

| Preset | Description |
|--------|-------------|
| `casual-technical` | Relaxed but knowledgeable. Uses jargon naturally. No corporate speak. |
| `professional` | Polished but human. Appropriate for LinkedIn. Avoids slang. |
| `minimal` | Extremely concise. One insight, few words. No fluff. |
| `storyteller` | Narrative arc. Problem → journey → insight. Slightly longer. |
| `teacher` | Educational tone. Explains concepts. Helpful without condescension. |

Store selected preset:

```json
{
  "voice": {
    "source": "preset",
    "preset": "casual-technical"
  }
}
```

### 5. Option 3: Import from URL

If user provides X or LinkedIn profile URL:

1. Use WebFetch to retrieve recent posts (if publicly accessible)
2. Analyze voice patterns from retrieved content
3. Generate voice config as in Option 1

Note: This may have limited success due to platform restrictions. Fall back to manual examples if fetch fails.

### 6. Confirm and Save

Show the generated voice profile:

```
═══════════════════════════════════════════════════
  YOUR VOICE PROFILE
═══════════════════════════════════════════════════

Tone:       casual-technical
Length:     concise (under 200 chars for X)
Emoji:      minimal (occasional, not decorative)
Style:      leads with insight, technical terms OK, reflective endings

Example of how drafts will sound:
> "Spent 2 hours debugging a race condition. Fix was one line.
>  Lesson: log timestamps, not just events."

Save this profile? [yes/no/edit]
```

### 7. Update Skill Reference

After saving config, remind user:

```
Voice profile saved to .plan/build-in-public/config.json

The build-in-public agent will now use this voice when drafting content.
Run /pro:bip.setup anytime to recalibrate.
```

## Edge Cases

- **No .plan/ directory**: Create it
- **Fetch fails for URL**: Suggest manual examples instead
- **User wants to reset**: Offer option to clear voice config and start fresh
- **Mixed platform tones**: For v1, use same voice for both X and LinkedIn. Platform-specific voices can be added later.
