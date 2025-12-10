# ADR Integration Workflow

## Summary
Integrate Architecture Decision Records (ADRs) into the existing `/pro:pr` and `/pro:pr.merged` commands so that every implementation documents its key decisions.

## Requirements

### Confirmed with User
1. **Location:** `doc/decisions/` in the TARGET project (not this plugin repo)
2. **Format:** Michael Nygard style (Title, Status, Context, Decision, Consequences)
3. **Trigger:** Both `/pro:pr` AND `/pro:pr.merged` include ADR creation (redundant coverage)
4. **Mandatory:** Every implementation must document decisions - no skipping
5. **Discovery:** AI extracts decisions from `.plan/` and code changes, user validates
6. **Numbering:** Global sequential (001, 002, 003...)
7. **Linking:** Bidirectional between ADRs and `.plan/` documents

### Scope
- Update `/pro:pr` command to include ADR creation step
- Update `/pro:pr.merged` command to include ADR creation step (fallback if pr not used)
- Commands should create `doc/decisions/` directory if it doesn't exist
- Commands should create `doc/decisions/README.md` if it doesn't exist

**Note:** This plugin repo does NOT contain `doc/decisions/` - the commands CREATE that structure in whatever project they're run in.

## Design Decisions

### Why both pr and pr.merged?
User workflow varies - sometimes they create a PR via the command, sometimes manually. Either path should capture ADRs.

### Why mandatory?
Every implementation involves decisions. Making it optional leads to inconsistent documentation. The prompt can result in "no significant architectural decisions" being documented, which is itself a valid record.

### AI-assisted discovery
Rather than asking users to enumerate decisions from memory, the AI should:
1. Review the `.plan/` directory for the current branch
2. Analyze commit history/changes
3. Propose decisions to document
4. User validates, adds context, or identifies additional decisions

## Implementation Steps

1. **Update `/pro:pr`**
   - Before creating PR, add ADR creation step
   - Instructions for AI to:
     - Create `doc/decisions/` if not exists
     - Create `doc/decisions/README.md` if not exists
     - Analyze `.plan/` and commits to extract decisions
     - Create ADR files with next sequential number
     - Add link to ADR in `.plan/` summary

2. **Update `/pro:pr.merged`**
   - Check if ADRs were created during PR phase
   - If not, run the same ADR extraction process
   - This ensures coverage regardless of workflow path

## ADR Template (Michael Nygard Style)

```markdown
# {NUMBER}. {Title}

Date: {YYYY-MM-DD}

## Status

{Proposed | Accepted | Deprecated | Superseded by [ADR-XXX](XXX-title.md)}

## Context

{What is the issue that we're seeing that motivates this decision?}

## Decision

{What is the change that we're proposing and/or doing?}

## Consequences

{What becomes easier or more difficult because of this decision?}

## Alternatives Considered

{What other options were evaluated? Why were they rejected?}

## Related

- Planning: `.plan/{branch-name}/`
- ADRs: [ADR-XXX](XXX-related.md)
```

## Success Criteria

- [x] `/pro:pr` includes mandatory ADR creation step
- [x] `/pro:pr.merged` includes ADR creation (fallback)
- [x] ADRs use global sequential numbering (via `.plan/adr-index.json`)
- [x] Instructions specify bidirectional linking
- [x] Duplicate detection via `.plan/adr-index.json` entries
- [x] Commands create `doc/decisions/README.md` with naming conventions
- [x] Filename convention: `NNN-kebab-case-title.md`

## Related ADRs

- [001. Integrate ADRs into PR Workflow](../../doc/decisions/001-integrate-adrs-into-pr-workflow.md)
