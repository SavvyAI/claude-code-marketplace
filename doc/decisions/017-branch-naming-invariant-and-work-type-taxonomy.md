# ADR 017: Branch Naming Invariant and Work-Type Taxonomy

## Status

Accepted

## Date

2025-12-25

## Context

The plugin provides several work-initiating commands (`/pro:feature`, `/pro:bug`, `/pro:refactor`), each creating branches with different prefixes. As we add new work-type commands (`/pro:spike`, `/pro:chore`) and spec-handling commands (`/pro:spec.import`, `/pro:spec`), we need to:

1. Formalize the relationship between commands, categories, and branch prefixes
2. Distinguish work-initiating commands from non-work-initiating commands
3. Ensure consistent, automatable behavior across all commands

Additionally, backlog item #8 identified a gap: when users paste full PRDs/specs into `/pro:feature`, stories not immediately worked on are lost. This requires a new category of commands focused on spec handling that explicitly does NOT create branches.

## Decision

### Branch Naming Invariant

All **work-initiating commands** must:

1. Create a new branch at invocation time
2. Use a branch naming prefix that unambiguously reflects the type of work
3. Encode workflow class in the prefix, not content details

### Work-Type Taxonomy

| Command | Category | Branch Prefix | Backlog Category |
|---------|----------|---------------|------------------|
| `/pro:feature` | Feature | `feat/` | `feature` |
| `/pro:bug` | Bug fix | `fix/` | `bug` |
| `/pro:refactor` | Technical debt | `refactor/` | `debt` |
| `/pro:spike` | Exploration | `spike/` | `spike` |
| `/pro:chore` | Maintenance | `chore/` | `chore` |

### Non-Work-Initiating Commands

These commands do NOT create branches:

| Command | Purpose |
|---------|---------|
| `/pro:spec.import` | Ingest and persist specs, parse to backlog |
| `/pro:spec` | View imported specs (read-only) |
| `/pro:audit` | Analysis (outputs reports) |
| `/pro:roadmap` | Visibility dashboard (read-only) |
| `/pro:backlog` | Work selection (creates branch AFTER selection) |

### Backlog Category Sort Order

Updated to include new categories:

```
Security > Bug > Spike > Tests > Feature > Chore > Debt > i18n
```

Spike is placed high because exploratory work often unblocks other decisions.

### Prefix-to-Category Mapping for `/pro:backlog`

```
security → fix/
bug      → fix/
spike    → spike/
tests    → fix/
feature  → feat/
chore    → chore/
debt     → refactor/
i18n     → chore/
```

## Consequences

### Positive

- **Intent-first workflows:** Branch names encode *why* work exists
- **Separation of concerns:** Spec handling, analysis, and execution are distinct phases
- **Lossless spec ingestion:** Specs are preserved as authoritative artifacts
- **Safe defaults:** Viewing or importing specs never starts work
- **Automatable:** Consistent prefixes enable CI/CD rules, PR templates, etc.

### Negative

- **More categories to track:** Backlog now has 8 categories
- **Command count increases:** 4 new commands added

### Neutral

- Existing commands unchanged in behavior
- No migration needed for existing branches or backlog items

## Alternatives Considered

### 1. Single `/pro:work` command with type parameter

Rejected because:
- Reduces discoverability
- Makes automation harder
- Loses the semantic clarity of purpose-built commands

### 2. Context-specific prefixes for chores (docs/, test/, infra/)

Rejected because:
- Prefixes should encode workflow class, not content
- Creates fragmentation and decision fatigue
- Infra/docs/tests can be promoted to first-class commands later if needed

### 3. Spec parsing in `/pro:feature`

Rejected because:
- Bloats feature command beyond its purpose
- Mixes I/O operations with work initiation
- Makes the command harder to reason about

## Related

- ADR-015: Audit, Backlog, and Roadmap Command Architecture
- ADR-016: ADR Check and Backlog Integration for Work Commands
- Backlog item #8: PRD/spec intake workflow
