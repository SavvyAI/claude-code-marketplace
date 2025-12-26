# Implementation Plan: Work-Type Commands + Spec Ingestion

## Overview

This feature introduces:
1. **Two new work-initiating commands:** `/pro:spike` and `/pro:chore`
2. **Two new spec-handling commands:** `/pro:spec.import` and `/pro:spec`
3. **Formalized branch naming invariant** for all work-initiating commands

## Addresses

- Backlog item #8: PRD/spec intake workflow - backlog preservation

## Design Decisions (Confirmed)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Spike workflow | Optional documentation with strong default | Preserves speed + institutional memory |
| Chore prefix | Single `chore/` prefix | Prefixes encode workflow class, not content |
| Spec storage | `.plan/specs/` | Specs are planning artifacts |
| Auto-backlog | Auto-add all parsed items | Spec is authoritative; losslessness is core |

## Branch Naming Invariant (New ADR)

All work-initiating commands must:
- Create a new branch at invocation time
- Use intent-appropriate prefix
- Encode workflow class in prefix, not content

**Prefix Mapping:**

| Command | Category | Prefix |
|---------|----------|--------|
| `/pro:feature` | feature | `feat/` |
| `/pro:bug` | bug | `fix/` |
| `/pro:refactor` | debt | `refactor/` |
| `/pro:spike` | spike | `spike/` |
| `/pro:chore` | chore | `chore/` |

**Existing commands already follow this pattern** - this ADR formalizes the invariant.

---

## Implementation Steps

### Phase 1: New Work-Initiating Commands

#### 1.1 Create `/pro:spike` command

**File:** `pro/commands/spike.md`

**Behavior:**
- Enter plan mode
- Check ADRs for related decisions
- Create `spike/` branch
- Add to backlog as `in-progress` with `category: "spike"`
- Create minimal planning directory
- **Key difference:** After exploration, prompt user: "Would you like to document your findings?"
  - If yes: create findings doc in `.plan/{branch}/findings.md`
  - If no: proceed without documentation
- No CodeRabbit review (spikes may not merge)
- Explicit note about spike lifecycle: may be discarded, promoted to feature, or merged as-is

**Backlog schema:**
```json
{
  "category": "spike",
  "severity": "medium",
  "fingerprint": "spike|{id}|{slugified-title}",
  "source": "/pro:spike"
}
```

#### 1.2 Create `/pro:chore` command

**File:** `pro/commands/chore.md`

**Behavior:**
- Enter plan mode
- Check ADRs for related decisions
- Create `chore/` branch
- Add to backlog as `in-progress` with `category: "chore"`
- Full planning workflow (same as feature)
- CodeRabbit review
- Absorbs: infrastructure, documentation, tests, dependencies, CI/config

**Backlog schema:**
```json
{
  "category": "chore",
  "severity": "medium",
  "fingerprint": "chore|{id}|{slugified-title}",
  "source": "/pro:chore"
}
```

### Phase 2: Spec Handling Commands

#### 2.1 Create `/pro:spec.import` command

**File:** `pro/commands/spec.import.md`

**Behavior:**
1. Accept spec input (markdown, pasted content, or file path)
2. Generate unique spec ID and filename
3. Store raw spec in `.plan/specs/{spec-id}.md`
4. Create `.plan/specs/index.json` if not exists
5. Parse spec for structured items:
   - Epics (H2 headers with "Epic" or numbered sections)
   - User stories (list items with "As a...", "User story:", numbered items)
   - Acceptance criteria (checklist items, "Given/When/Then")
6. For each parsed item, auto-add to backlog:
   - Epic → `category: "feature"`, `severity: "medium"`
   - Story → `category: "feature"`, `severity: "medium"`
   - Acceptance criteria → stored in story description, not separate backlog items
7. Display extraction summary
8. **No branch creation** - this is an I/O operation, not work initiation

**Spec storage schema (`.plan/specs/index.json`):**
```json
{
  "lastSequence": 1,
  "specs": [
    {
      "id": "spec-001",
      "title": "Feature Specification Title",
      "filename": "spec-001-feature-title.md",
      "source": "clipboard|file|url",
      "importedAt": "2025-12-25T00:00:00Z",
      "extractedItems": {
        "epics": 2,
        "stories": 8
      }
    }
  ]
}
```

**Backlog item linking:**
```json
{
  "fingerprint": "spec|{spec-id}|{item-type}|{item-index}",
  "source": "/pro:spec.import",
  "sourceSpec": "spec-001"
}
```

#### 2.2 Create `/pro:spec` command

**File:** `pro/commands/spec.md`

**Behavior:**
1. Read `.plan/specs/index.json`
2. Display list of imported specs with metadata
3. If spec ID provided as argument, display that spec's details:
   - Full spec content (or summary if large)
   - List of extracted items
   - Links to related backlog items
4. **Read-only** - no side effects, no work initiation, no branch creation

### Phase 3: ADR and Documentation

#### 3.1 Create ADR for Branch Naming Invariant

**File:** `doc/decisions/017-branch-naming-invariant.md`

**Content:**
- Formalize the invariant: all work-initiating commands create branches
- Document prefix mapping
- Distinguish work-initiating vs. non-work-initiating commands
- Exclude spec-handling commands from branch creation

#### 3.2 Update Category Mappings

Update `/pro:backlog` to recognize new categories in sort order:
```
Security > Bug > Spike > Tests > Feature > Chore > Debt > i18n
```

Update prefix mapping:
```
spike   → spike/
chore   → chore/
```

#### 3.3 Update `pro/readme.md`

Add documentation for:
- `/pro:spike`
- `/pro:chore`
- `/pro:spec.import`
- `/pro:spec`

### Phase 4: Verification

- Test each new command
- Verify backlog integration
- Verify spec parsing with sample PRD
- Ensure no regressions to existing commands

---

## Files to Create

| File | Purpose |
|------|---------|
| `pro/commands/spike.md` | Spike command |
| `pro/commands/chore.md` | Chore command |
| `pro/commands/spec.import.md` | Spec import command |
| `pro/commands/spec.md` | Spec viewer command |
| `doc/decisions/017-branch-naming-invariant.md` | ADR for branch naming |

## Files to Modify

| File | Change |
|------|--------|
| `pro/commands/backlog.md` | Add spike/chore to category sort order and prefix mapping |
| `pro/readme.md` | Document new commands |
| `.plan/backlog.json` | Already updated with in-progress item |

---

## Success Criteria

1. `/pro:spike` creates `spike/` branches and supports optional documentation
2. `/pro:chore` creates `chore/` branches and absorbs maintenance work
3. `/pro:spec.import` persists specs and auto-parses to backlog
4. `/pro:spec` displays imported specs (read-only)
5. All work-initiating commands create branches with correct prefixes
6. Spec-handling commands never create branches
7. Backlog item #8 is resolved by this implementation
