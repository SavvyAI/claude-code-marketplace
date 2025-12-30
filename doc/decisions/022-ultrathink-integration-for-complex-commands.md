# ADR 022: Ultrathink Integration for Complex Commands

## Status

Accepted

## Date

2025-12-30

## Context

Claude Code supports extended thinking mode through keyword triggers (`think`, `think hard`/`megathink`, `ultrathink`). These allocate different token budgets for reasoning:

| Trigger | Budget | Use Case |
|---------|--------|----------|
| `think` | 4,000 tokens | Basic debugging, simple refactoring |
| `think hard` / `megathink` | 10,000 tokens | Moderate complexity |
| `ultrathink` | 31,999 tokens | Deep reasoning, complex problems |

Extended thinking provides material benefit for:
- System design and architecture decisions
- Complex problem-solving (breaking loops)
- Multi-step implementation planning
- Challenging bug diagnosis
- Edge case analysis

The pro plugin contains several commands that perform complex analytical tasks where deeper reasoning could improve output quality.

## Decision

### 1. Add Ultrathink Triggers to High-Value Commands

Integrate `ultrathink` into commands where extended thinking provides material benefit:

| Command | Location | Rationale |
|---------|----------|-----------|
| `/pro:audit.security` | Phase 1 + Phase 3 | Security analysis requires understanding attack vectors across multiple dimensions |
| `/pro:audit.quality` | Start of task | Multi-dimensional quality analysis benefits from comprehensive initial thinking |
| `/pro:react.to.next` | Phase 1 (Preflight) | Migration success depends on complete understanding before changes |
| `/pro:handoff` | Start of instructions | Comprehensive documentation requires identifying non-obvious patterns |

### 2. Use Hybrid Approach

Combine explicit trigger with contextual guidance:

```markdown
**ultrathink:** This security audit requires systematic analysis...
Consider the project's architecture, framework-specific vulnerabilities...
```

This provides:
- Clear trigger for extended thinking
- Contextual guidance for what to analyze
- Transparency about when extended thinking is invoked

### 3. Exclude Low-Complexity Commands

Do NOT add ultrathink to:
- `/pro:pr` - Mechanical PR generation
- `/pro:backlog.add` - Simple data capture
- `/pro:git.main` - Simple branch operations
- `/pro:roadmap` - Display only
- `/pro:bip` - Queue review

These commands don't benefit from extended thinking and would add unnecessary token cost.

## Consequences

### Positive

- **Improved output quality** for complex analytical tasks
- **Better security analysis** with deeper reasoning about attack vectors
- **More complete handoff documentation** capturing non-obvious patterns
- **Safer migrations** with thorough preflight analysis
- **Transparent usage** - users can see when extended thinking is invoked

### Negative

- **Increased token cost** for commands with ultrathink
- **Claude Code CLI only** - ultrathink doesn't work in API or web chat
- **Implementation detail exposure** - relies on keyword detection behavior

### Mitigations

- Only apply to high-value commands where cost is justified
- Document that this is a Claude Code-specific optimization
- Contextual guidance still helps even without extended thinking

## Alternatives Considered

### 1. Instruction-Based Guidance Only

Use detailed analysis instructions without explicit trigger.

Rejected because:
- May not reliably trigger extended thinking
- Hybrid approach provides both benefits

### 2. Global Ultrathink for All Commands

Add ultrathink to every command.

Rejected because:
- Many commands don't benefit from extended thinking
- Increases token cost without material improvement
- Diminishing returns for simple tasks

### 3. User-Controlled Flag

Let users opt-in to ultrathink per invocation.

Rejected because:
- Adds friction to workflow
- Users may not know when it helps
- Pre-selecting commands is more ergonomic

## Related

- ADR-020: Audit Command Namespace Hierarchy
- ADR-019: React to Next.js Migration Design
- Anthropic documentation on extended thinking
