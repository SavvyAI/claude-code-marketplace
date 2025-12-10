---
description: "Feature complete and tested? → Archives planning docs and analyzes commits → Creates a comprehensive pull request"
allowed-tools: ["Bash", "Read", "Write", "Glob", "Grep", "Edit"]
---

Clean up completed planning documentation, document architectural decisions, and create a pull request.

## Your Task

1. Move planning documentation located under `.plan/{current-branch-name}` to `.plan/.done/`.
2. **Create Architecture Decision Records (ADRs)** - see ADR instructions below.
3. Create and push a pull request.
4. Document any known issues that won't be addressed here so they can be addressed in a subsequent effort.

---

## ADR Instructions

Architecture Decision Records capture the "why" behind implementation choices for future reference.

### Step 1: Setup (if needed)

Create directory and files if they don't exist:

1. Create `doc/decisions/` directory
2. Create `doc/decisions/README.md`:

```markdown
# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) documenting significant technical decisions.

## What is an ADR?

An ADR captures the context, decision, and consequences of an architecturally significant choice.

## Format

We use the [Michael Nygard format](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).

## Naming Convention

- Filename: `NNN-kebab-case-title.md` (e.g., `001-use-localStorage-for-tracking.md`)
- NNN = zero-padded sequence number (001, 002, 003...)
- Title in heading must match: `# NNN. Title` (e.g., `# 001. Use localStorage for Tracking`)

## Index

<!-- New ADRs added below -->
```

3. Create `.plan/adr-index.json` (if not exists):

```json
{
  "lastSequence": 0,
  "entries": []
}
```

### Step 2: Check for existing ADRs

Read `.plan/adr-index.json` and check if an entry exists for the current branch. If ADRs already exist for this branch, skip to Step 6.

### Step 3: Determine next ADR number

- Read `lastSequence` from `.plan/adr-index.json`
- Next number = lastSequence + 1

### Step 4: Extract decisions

Review the following to identify architectural decisions:
- `.plan/{branch-name}/` planning documents
- Git commit history: `git log main..HEAD`
- Code changes: `git diff main...HEAD`

Look for decisions about:
- Technology/library choices
- Data storage approaches
- API design patterns
- Architecture patterns
- Trade-offs made
- Rejected alternatives

### Step 5: Create ADRs

For each decision, create `doc/decisions/{NNN}-{kebab-case-title}.md`:

```markdown
# {NNN}. {Title}

Date: {YYYY-MM-DD}

## Status

Accepted

## Context

{What problem or situation prompted this decision?}

## Decision

{What did we decide to do?}

## Consequences

{What are the positive and negative outcomes?}

## Alternatives Considered

{What options were evaluated? Why rejected?}

## Related

- Planning: `.plan/.done/{branch-name}/`
```

### Step 6: Update tracking files

1. Update `.plan/adr-index.json`:
   - Set `lastSequence` to highest ADR number created
   - Add entry: `{"branch": "{branch-name}", "adrs": ["NNN-title.md", ...]}`

2. Update `doc/decisions/README.md` index with links to new ADRs

3. Add "Related ADRs" section to `.plan/.done/{branch-name}/plan.md`

---

### Omit the following from the commit message:
- [ ] "Generated with" line
- [ ] "Co-Auth-By"
