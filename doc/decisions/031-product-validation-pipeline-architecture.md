# 031. Product Validation Pipeline Architecture

Date: 2026-01-01

## Status

Accepted

## Context

Early-stage idea validation typically happens before any code exists - often before even a git repository. Founders and product owners need to validate market opportunities before committing resources to implementation.

Current tools like Perplexity Deep Research, ChatGPT, and Gemini provide general research capabilities, but they:
- Don't provide structured output for startup workflows
- Are overly polite (not harsh enough for real validation)
- Don't persist findings for future reference
- Don't integrate with development workflows

The user requested a "harsh technical co-founder" persona that would brutally validate ideas and surface uncomfortable truths, while confirming strong ideas that survive the gauntlet.

## Decision

### Three-Command Pipeline

Implement a three-command product validation pipeline:

1. **`/pro:product.brief`** - Transform unstructured chaos (voice transcriptions, notes, single sentences) into a structured product brief
2. **`/pro:product.validate`** - Run brutal, evidence-based market validation with GO/CAUTION/NO-GO verdict
3. **`/pro:product.pitch`** - Generate investor-ready 10-slide pitch deck outline from validated product

### Key Design Choices

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Storage location | `.plan/product/` | Consistent with existing `.plan/` pattern |
| Git requirement | None | Works pre-repo; idea validation happens before commitment |
| Versioning | Timestamped files | Enable comparison of multiple validation runs |
| Tone | Brutally honest, not cruel | Direct feedback that helps, not discourages |
| Research | WebSearch + extension hooks | Built-in capability with future API expansion |

### Pre-Repo Support

Unlike most `/pro:*` commands which assume a git repository, these commands work in any directory:
- No git operations required
- Storage at `.plan/product/` created as needed
- Designed for the earliest stage of idea exploration

### Harsh Persona Guidelines

The validate command acts like a brutal but fair technical co-founder:
- **Direct:** "This won't work because..." not "There might be some challenges..."
- **Evidence-based:** Every claim backed by research
- **Constructive:** Points out flaws to help fix them, not discourage

### Research API Extension

Designed for future multi-source research integration:
- WebSearch (built-in) always available
- Extension hooks for Perplexity, Gemini, etc.
- Config structure defined in `.plan/product/config.json`

## Consequences

### Positive

- **Early validation** before wasting resources on bad ideas
- **Persistent artifacts** for future reference (pitch decks, pivots)
- **Structured workflow** from chaos to pitch-ready
- **Pre-repo support** for earliest idea stage
- **Extensible research** with API hooks for future expansion

### Negative

- **WebSearch limitations** - built-in search less comprehensive than dedicated APIs
- **Three commands** - could feel like overhead for quick validation
- **No git history** in pre-repo mode

### Neutral

- Extends the `product.*` namespace in the pro plugin
- Uses `ultrathink` for deep analysis (consistent with ADR-022)
- Files persist even if idea is abandoned

## Alternatives Considered

### 1. Single Command with Flags

`/pro:validate --brief --pitch`

Rejected because:
- Commands have distinct purposes and outputs
- Brief and validate serve different user needs
- Pitch requires validation to succeed first

### 2. Require Git Repository

Make git init mandatory before running these commands.

Rejected because:
- Adds friction at the earliest, most fragile idea stage
- Git commitment should come after validation, not before
- Some ideas never need a repo

### 3. External API Only

Require Perplexity/Gemini API keys for research.

Rejected because:
- Adds setup friction
- Claude WebSearch provides baseline capability
- Can add APIs as optional enhancement later

## Related

- ADR-022: Ultrathink Integration (used for deep validation analysis)
- Planning: `.plan/.done/feat-product-validation-pipeline/`
