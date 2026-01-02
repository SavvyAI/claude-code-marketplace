# Product Validation Pipeline

## Feature Summary

Three-command pipeline for early-stage idea validation:

1. **`/pro:product.brief`** - Distill unstructured idea material into a structured product brief
2. **`/pro:product.validate`** - Run brutal, no-BS market validation against the brief
3. **`/pro:product.pitch`** - Generate pitch deck outline from validated product

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Storage location | `.plan/product/` | Consistent with existing `.plan/` pattern |
| Tone | Brutally honest, not cruel | Professional but direct - like a harsh co-founder who wants you to succeed |
| Git requirement | None | Works in any directory, even pre-repo. Idea validation happens before commitment |
| Research sources | Claude WebSearch + API extension hooks | Multi-source for comprehensive coverage |
| Report history | Versioned (timestamped) | Keep all validation runs for comparison |
| External APIs | Extension hooks in v1 | Design for Perplexity/Gemini/etc. from start |

## Command 1: `/pro:product.brief`

### Purpose
Transform unstructured idea material (voice transcriptions, notes, rambling) into a structured product brief artifact.

### Input Types
- Voice transcription (2-3 minute rambling)
- Pages of unstructured notes
- Single sentence idea
- Stream of consciousness dump
- Argument: direct text or file path

### Output Structure
```markdown
# Product Brief

## Problem Statement
What specific problem are we solving? Who has this problem?

## Proposed Solution
What are we building? How does it solve the problem?

## Target Customer
Who specifically will pay for this? Primary and secondary segments.

## Value Proposition
Why will they choose us over alternatives? What's the unique angle?

## Why Now?
What's changed that makes this viable/necessary now? Market timing.

## Business Model Hypothesis
How does money flow? Initial pricing/monetization theory.

## Key Assumptions
What must be true for this to work? List the riskiest assumptions.

## Open Questions
What don't we know yet? What needs validation?
```

### Storage
- **File:** `.plan/product/brief.md`
- **Creates directory if not exists:** `mkdir -p .plan/product`

### Workflow
1. Accept input (argument, file path, or ask user to paste)
2. Parse and extract key elements
3. Ask clarifying questions if critical info missing
4. Generate structured brief
5. Write to `.plan/product/brief.md`
6. Display summary

---

## Command 2: `/pro:product.validate`

### Purpose
Run comprehensive, harsh market validation against a product brief. Acts like a brutal technical co-founder who will destroy weak ideas but confirm strong ones.

### Input Resolution
1. If argument provided: use it (file path or inline content)
2. If no argument: look for `.plan/product/brief.md`
3. If not found: error with helpful message

### Research Strategy
Use **ultrathink** for deep analysis, then multi-source research:

1. **Claude WebSearch** (built-in) - always available
2. **Additional APIs** (if configured) - Perplexity, Gemini, etc.

Run all available sources in parallel, then synthesize into unified report.

### Output Structure (The Brutal Validation Report)

```markdown
# Market Validation Report

**Idea:** [one-line summary]
**Validated:** [timestamp]
**Verdict:** [GO / CAUTION / NO-GO]

---

## Executive Summary
1-2 sentence brutal truth. Is this real or not?

---

## 1. Core Market Signal
**Signal Strength:** [Extremely High / High / Medium / Low / None]

Is the pain real? What's the evidence?
- Search volume, forum posts, existing solutions
- Quantified demand indicators

---

## 2. Market Gap Analysis
What's missing? Who's failing?
- Existing solutions and their weaknesses
- Why hasn't this been solved?

---

## 3. Buyer Psychology
Why will people pay? Three questions:
- Is there high emotional pain?
- Is there high perceived upside?
- Is there low resistance to paying?

---

## 4. Target Customer Analysis
### Primary Buyers
- Who specifically?
- Emotional drivers

### Secondary Buyers
- Adjacent segments
- B2B opportunities

---

## 5. Market Timing
Why now? Converging forces:
- Policy/regulatory changes
- Behavioral shifts
- Technology enablers
- Window of opportunity

---

## 6. Business Model Reality Check
Is the monetization concrete or vague?
- Revenue streams
- Pricing viability
- Unit economics sanity check

---

## 7. Competitive Reality
- Who's there?
- Why they're weak (or strong)
- Barriers to entry
- Defensibility assessment

---

## 8. Risk Profile
**Real risks:**
- List concrete risks

**Why manageable (or not):**
- Mitigation strategies
- Precedents

---

## 9. Core Insight
What is this really? Strip away the features.
- Durable value proposition
- What you're actually selling

---

## 10. Bottom Line

**Market Signal Strength:** [rating]

| Dimension | Score | Notes |
|-----------|-------|-------|
| Demand certainty | X/10 | ... |
| Market timing | X/10 | ... |
| Revenue potential | X/10 | ... |
| Competitive position | X/10 | ... |
| Long-term defensibility | X/10 | ... |

**Final Verdict:** [GO / CAUTION / NO-GO]

**Recommended Next Steps:**
1. ...
2. ...
3. ...
```

### Storage
- **File:** `.plan/product/validation-{timestamp}.md`
- **Also copies to clipboard** (platform-aware)

### The Harsh Persona

The validation must be written in the voice of a brutal but fair technical co-founder:

- **Direct:** No hedging, no "it depends," no weasel words
- **Evidence-based:** Every claim backed by research
- **Constructive:** Points out flaws to help fix them, not to discourage
- **Honest:** If the idea is bad, say so clearly. If it's good, acknowledge it.

Example tone:
> "The market is screaming for this. You're not inventing demand - you're organizing chaos. That's a strong position."

vs.

> "There's no evidence anyone will pay for this. The 'problem' you're solving is a minor inconvenience, not a hair-on-fire pain point. Kill this idea."

---

## Implementation Steps

### Phase 1: Command Files
1. Create `pro/commands/product.brief.md`
2. Create `pro/commands/product.validate.md`

### Phase 2: Storage Infrastructure
1. Define `.plan/product/` structure
2. Handle non-git directories gracefully

### Phase 3: Research Integration
1. Implement WebSearch-based research
2. Design extension points for additional APIs (future)

### Phase 4: Testing
1. Test with unstructured voice transcription
2. Test with single sentence idea
3. Test validation with strong idea (should pass)
4. Test validation with weak idea (should fail harshly)

---

## Command 3: `/pro:product.pitch`

### Purpose
Generate a pitch deck outline from validated product. Uses the brief + validation report to create a structured pitch narrative.

### Input Resolution
1. Look for latest `.plan/product/validation-*.md`
2. Also read `.plan/product/brief.md`
3. If either missing: error with helpful message

### Output Structure

```markdown
# Pitch Deck Outline

**Product:** [name]
**Generated:** [timestamp]

---

## Slide 1: The Hook
One sentence that makes investors lean in.
[Generated from Core Insight]

---

## Slide 2: The Problem
- Pain point (specific, quantified)
- Who has this pain
- Why it matters now
[Generated from Problem Statement + Market Timing]

---

## Slide 3: The Solution
- What you're building
- How it solves the problem
- Demo moment / key feature
[Generated from Proposed Solution]

---

## Slide 4: Market Opportunity
- TAM / SAM / SOM
- Market size evidence
- Growth trajectory
[Generated from Market Signal + Buyer Analysis]

---

## Slide 5: Business Model
- How you make money
- Pricing strategy
- Unit economics (if known)
[Generated from Business Model section]

---

## Slide 6: Traction / Validation
- Evidence of demand
- Early signals
- What you've learned
[Generated from Market Signal evidence]

---

## Slide 7: Competition
- Competitive landscape
- Your differentiation
- Why you win
[Generated from Competitive Reality]

---

## Slide 8: Team
[User fills in]
- Why you're the team to build this

---

## Slide 9: The Ask
[User fills in]
- Funding amount
- Use of funds
- Milestones

---

## Slide 10: Vision
- Where this goes
- Long-term play
- Why this matters
[Generated from Core Insight + defensibility]

---

## Appendix: Key Data Points
[Generated from validation report metrics and evidence]
```

### Storage
- **File:** `.plan/product/pitch-{timestamp}.md`
- **Also copies to clipboard**

---

## Research API Extension Design

### Configuration
Create `.plan/product/config.json` (optional):

```json
{
  "research": {
    "sources": ["websearch"],
    "perplexity": {
      "enabled": false,
      "apiKey": "${PERPLEXITY_API_KEY}"
    },
    "gemini": {
      "enabled": false,
      "apiKey": "${GEMINI_API_KEY}"
    }
  }
}
```

### How It Works
1. `/pro:product.validate` reads config (or uses defaults)
2. For each enabled source, runs research query
3. Synthesizes results from all sources
4. Notes which sources contributed to each finding

### v1 Implementation
- **WebSearch:** Always available (built into Claude Code)
- **Extension hooks:** Config structure defined, API calls stubbed
- **Future:** Implement Perplexity/Gemini connectors

---

## File Structure

```
.plan/product/
├── brief.md                           # Current product brief
├── config.json                        # Optional research config
├── validation-2026-01-01-220000.md    # Timestamped validation
├── validation-2026-01-02-103000.md    # Another run
├── pitch-2026-01-02-110000.md         # Generated pitch outline
└── ...
```

---

## Implementation Steps

### Phase 1: Command Files
1. Create `pro/commands/product.brief.md`
2. Create `pro/commands/product.validate.md`
3. Create `pro/commands/product.pitch.md`

### Phase 2: Storage Infrastructure
1. Define `.plan/product/` structure
2. Handle non-git directories gracefully
3. Implement timestamped file naming

### Phase 3: Research Integration
1. Implement WebSearch-based research
2. Create config.json schema
3. Stub extension points for external APIs

### Phase 4: Pitch Generation
1. Implement brief + validation → pitch outline
2. Template for standard pitch structure
3. Leave placeholder sections for user input

### Phase 5: Testing
1. Test with unstructured voice transcription
2. Test with single sentence idea
3. Test validation with strong idea (should pass)
4. Test validation with weak idea (should fail harshly)
5. Test pitch generation from validation output

---

## Related ADRs
- ADR-022: Ultrathink Integration - `/pro:product.validate` is a prime candidate
- ADR-026: Subagent-Skill Architecture - Not applicable (user-initiated, not proactive)
- ADR-031: Product Validation Pipeline Architecture - This feature's architectural decisions

## Decisions Made
1. ✅ Research APIs: Include extension hooks in v1
2. ✅ Report history: Versioned (timestamped files)
3. ✅ Pitch command: Yes - three-command pipeline
