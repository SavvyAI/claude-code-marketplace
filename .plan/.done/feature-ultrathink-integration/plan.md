# Spike: Strategic Use of Ultrathink in Pro Plugin

## Overview

**Goal:** Determine if and where the `ultrathink` keyword provides material benefit within the pro plugin's commands and skills.

## Research Findings

### What is Ultrathink?

Ultrathink is a Claude Code-specific feature that triggers **extended thinking mode** with maximum token allocation (31,999 tokens). It's part of a three-tier system:

| Trigger | Budget | Use Case |
|---------|--------|----------|
| `think` | 4,000 tokens | Basic debugging, simple refactoring |
| `think hard` / `megathink` | 10,000 tokens | Moderate complexity |
| `ultrathink` | 31,999 tokens | Deep reasoning, complex problems |

**Key constraint:** Only works in Claude Code CLI, not API or web.

### When Ultrathink Provides Material Benefit

According to Anthropic documentation, ultrathink significantly improves outcomes for:

1. **System Design & Architecture** - Deep exploration of design tradeoffs
2. **Complex Problem-Solving** - When Claude gets stuck in loops
3. **Multi-step Implementation Planning** - Evaluating approaches before coding
4. **Challenging Bugs** - Deep root cause analysis
5. **Edge Case Analysis** - Systematic evaluation of corner cases

**Diminishing returns:** Jumping from 10K→31,999 tokens shows gains primarily for genuinely complex problems.

---

## Analysis: Pro Plugin Commands

### High-Value Candidates (Recommend Ultrathink)

| Command | Current Complexity | Why Ultrathink Helps |
|---------|-------------------|---------------------|
| `/pro:audit.security` | Very High (468 lines) | OWASP analysis, CVE scanning, framework-specific security patterns - deep reasoning needed to identify subtle vulnerabilities |
| `/pro:react.to.next` | Very High (608 lines) | Deterministic migration pipeline with route safety guarantees - architectural decisions, edge case handling |
| `/pro:handoff` | High | Comprehensive codebase analysis - needs thorough exploration to capture tribal knowledge |
| `/pro:audit.quality` | High (171 lines) | Production readiness assessment - systematic analysis of multiple dimensions |

### Medium-Value Candidates (Consider Ultrathink)

| Command | Rationale |
|---------|-----------|
| `/pro:feature` | Planning mode with architectural decisions |
| `/pro:bug` | Root cause analysis when diagnosis is unclear |
| `/pro:spec.import` | Parsing complex PRD documents with MoSCoW extraction |

### Low-Value Candidates (Skip Ultrathink)

| Command | Rationale |
|---------|-----------|
| `/pro:pr` | Mechanical PR generation |
| `/pro:backlog.add` | Simple data capture |
| `/pro:git.main` | Simple branch rename |
| `/pro:roadmap` | Display only |
| `/pro:bip` | Review queue display |

---

## Implementation Approach

### Option A: Explicit Inline Trigger (Recommended)

Add ultrathink trigger directly in command prompts where deep thinking is beneficial:

```markdown
---
description: "Deep security scan? → ..."
---

# Comprehensive Security Audit

**ultrathink:** This audit requires deep analysis across multiple security dimensions...
```

**Pros:**
- Simple, transparent
- User can see when extended thinking is invoked
- No code changes needed

**Cons:**
- Relies on keyword detection (implementation detail)

### Option B: Instruction-Based Guidance

Add instructions that encourage thorough analysis without explicit trigger:

```markdown
## Analysis Requirements

Before proceeding, thoroughly analyze all possible attack vectors. Consider:
- Edge cases that might bypass validation
- Framework-specific vulnerabilities
- Interaction effects between components
```

**Pros:**
- More portable (works beyond Claude Code)
- Focuses on behavior, not mechanism

**Cons:**
- May not reliably trigger extended thinking

### Option C: Hybrid (Best Practice)

Combine both approaches:

```markdown
## Phase 1: Deep Analysis

**ultrathink:** Analyze the codebase security posture thoroughly before scanning.

Consider:
- [detailed guidance points]
```

---

## Proposed Changes

### 1. `/pro:audit.security` - Add at Phase 3 (OWASP Analysis)

```markdown
## Phase 3: OWASP Top 10 Static Analysis

**ultrathink:** Analyze codebase for OWASP vulnerabilities systematically.

This requires careful pattern matching and understanding of how
vulnerabilities manifest in different frameworks and contexts.
```

**Rationale:** Security analysis benefits most from extended thinking - subtle vulnerabilities require deep context understanding.

### 2. `/pro:audit.quality` - Add at start

```markdown
## Your Task

**ultrathink:** Perform comprehensive quality analysis.

Analyze the current branch against these categories...
```

**Rationale:** Quality audits cover many dimensions; thorough initial thinking prevents missed issues.

### 3. `/pro:react.to.next` - Add at Phase 1 (Preflight)

```markdown
## Phase 1: Preflight Analysis

**ultrathink:** Analyze the React application architecture thoroughly.

This migration requires understanding the full routing structure,
state management patterns, and framework-specific idioms before
making any changes.
```

**Rationale:** Migration success depends on complete understanding before any changes.

### 4. `/pro:handoff` - Add at start

```markdown
## Instructions

**ultrathink:** Generate comprehensive codebase analysis.

1. Read the report template...
```

**Rationale:** Handoff reports need thorough exploration to capture non-obvious patterns.

---

## Cost Consideration

Extended thinking tokens are billed. For the pro plugin:

- `/pro:audit.security` - Justified (high-stakes decisions)
- `/pro:audit.quality` - Justified (comprehensive analysis)
- `/pro:react.to.next` - Justified (irreversible changes)
- `/pro:handoff` - Justified (documentation completeness)

**Not recommended** for high-frequency, low-complexity commands to avoid unnecessary costs.

---

## Success Criteria

To validate ultrathink provides material benefit:

1. **Before/After comparison** - Run audits with and without ultrathink
2. **Measure finding completeness** - Does extended thinking catch more issues?
3. **Measure accuracy** - Are false positives reduced?
4. **User feedback** - Do users perceive better quality?

---

## Recommendation

**Implement Option C (Hybrid)** for the four high-value commands:

1. `/pro:audit.security`
2. `/pro:audit.quality`
3. `/pro:react.to.next`
4. `/pro:handoff`

This provides:
- Material improvement in output quality for complex tasks
- Clear user visibility into when extended thinking is used
- Focused cost (only on high-value operations)
- Easy to add/remove based on feedback

---

## Related ADRs

- [ADR 022: Ultrathink Integration for Complex Commands](../../doc/decisions/022-ultrathink-integration-for-complex-commands.md)

