---
description: "Have a PRD or spec? → Ingest and persist with structured extraction → Auto-parses epics and stories to backlog"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
---

## Context

Let's import: $ARGUMENTS

## Purpose

Ingest and persist an external specification, then extract its structured contents into the backlog.

**This command:**
- Accepts PRDs and specs in common forms (markdown, pasted content, file path)
- Stores the specification as a first-class, durable record
- Parses and extracts structured items (epics, stories, acceptance criteria)
- Auto-adds extracted items to the backlog (with deduplication)
- Verifies extraction succeeded
- Displays extraction results

**This command does NOT:**
- Create branches (this is an I/O operation, not work initiation)
- Enter planning modes
- Start work
- Rewrite or reinterpret content beyond structural extraction

## Your Task

### Step 1: Accept Input

- If `$ARGUMENTS` is a file path: read the file
- If `$ARGUMENTS` contains spec content directly: use it as-is
- If no arguments: ask user to paste the spec content

### Step 2: Generate Spec Metadata

- Extract title from first H1 heading or first line
- Read `.plan/specs/index.json` to get next sequence number
- Generate unique spec ID: `spec-{NNN}` (zero-padded 3 digits)
- Create filename: `{spec-id}-{slugified-title}.md`

### Step 3: Store Raw Spec (Atomic Write)

```bash
mkdir -p .plan/specs
```

Write spec to `.plan/specs/{filename}`:
- Write to a temp file first (`.plan/specs/.{filename}.tmp`)
- Preserve original content exactly (lossless)
- Rename temp file to final location (atomic)

### Step 4: Update Spec Index

Ensure `.plan/specs/index.json` exists (create with `{"lastSequence": 0, "specs": []}` if not).

Add spec entry:
```json
{
  "id": "spec-{NNN}",
  "title": "<extracted title>",
  "filename": "<filename>",
  "source": "clipboard|file",
  "importedAt": "<ISO 8601 timestamp>",
  "extractedItems": {
    "epics": 0,
    "stories": 0
  }
}
```

### Step 5: Parse for Structured Items

**Parsing Precedence** (in order of priority):
1. Epics (highest)
2. Stories
3. Acceptance Criteria (attach to parent story, not separate items)

#### Epic Detection (mutually exclusive, check in order):

| Pattern | Example | Notes |
|---------|---------|-------|
| H2 with "Epic" keyword | `## Epic 1: User Auth` | Explicit epic marker |
| Numbered H2 section | `## 1. User Management` | Only if NOT prefixed with "Story" |
| Section with `[Epic]` tag | `## [Epic] Authentication` | Tag-based marker |

#### Story Detection (mutually exclusive, check in order):

| Pattern | Example | Notes |
|---------|---------|-------|
| "As a..." format | `As a user, I want...` | Classic user story |
| "Story:" prefix | `Story: Login functionality` | Explicit marker |
| "User story:" prefix | `User story: Password reset` | Explicit marker |
| Numbered sub-item under Epic | `1.1 Login flow` | Only direct children |

#### Acceptance Criteria (attach to nearest parent story):

| Pattern | Example | Notes |
|---------|---------|-------|
| "AC:" prefix | `AC: Password must be 8+ chars` | Explicit marker |
| "Acceptance:" prefix | `Acceptance: Shows error on failure` | Explicit marker |
| Given/When/Then | `Given I am logged out...` | BDD format |
| Indented checklist under story | `- [ ] Validates email format` | Only if directly under story |

#### MoSCoW Phase Detection (per-item):

Detect MoSCoW priority markers on each epic/story line:

| Pattern | Phase | Example |
|---------|-------|---------|
| `[MUST]`, `[M]`, `(MUST)` | `must` | `- US-001 [MUST] As a user, I can sign up` |
| `[SHOULD]`, `[S]`, `(SHOULD)` | `should` | `- US-002 [SHOULD] As a user, I can reset password` |
| `[COULD]`, `[C]`, `(COULD)` | `could` | `- US-003 [COULD] As a user, I can use social login` |
| `[WONT]`, `[W]`, `(WON'T)`, `[WON'T]` | `wont` | `- US-004 [WONT] As a user, I can use SSO` |

**Detection Rules:**
- Case-insensitive matching
- Markers can appear anywhere in the line (typically after ID or at start)
- If no marker found, leave `phase` unset (will be inferred later from severity)
- Set `phaseSource: "explicit"` when marker is detected
- Remove marker from title when storing (e.g., `[MUST] Login flow` → title: `Login flow`)

**Hierarchy Rules:**
- Stories may exist outside epics (standalone)
- ACs must attach to nearest ancestor story
- If AC has no parent story, skip it (log warning, don't create orphan)
- Sub-items only count direct children (one level deep)

### Step 6: Deduplicate Before Adding to Backlog

Before adding items, check for duplicates:

1. Read existing `.plan/backlog.json`
2. For each extracted item, generate fingerprint:
   - Use content-based hash: `spec|{spec-id}|{item-type}|{hash(title+first-50-chars-description)}`
3. Check if fingerprint exists in backlog
4. **Resolution policy:**
   - If fingerprint exists: **skip** (do not insert duplicate)
   - Log skipped items in summary

### Step 7: Add Extracted Items to Backlog

For each epic (not already in backlog):
```json
{
  "id": <next sequence>,
  "title": "<epic title>",
  "description": "<epic description with full context>",
  "category": "feature",
  "severity": "medium",
  "phase": "must|should|could|wont",
  "phaseSource": "explicit",
  "fingerprint": "spec|<spec-id>|epic|<hash>",
  "source": "/pro:spec.import",
  "sourceSpec": "<spec-id>",
  "sourceBranch": null,
  "createdAt": "<ISO 8601 timestamp>",
  "status": "open"
}
```

**Note:** `phase` and `phaseSource` are only included if a MoSCoW marker was detected. If no marker, omit these fields (phase will be inferred from severity by consuming commands).

For each story (not already in backlog):
```json
{
  "id": <next sequence>,
  "title": "<story title or first line>",
  "description": "<full story text including acceptance criteria>",
  "category": "feature",
  "severity": "medium",
  "phase": "must|should|could|wont",
  "phaseSource": "explicit",
  "fingerprint": "spec|<spec-id>|story|<hash>",
  "source": "/pro:spec.import",
  "sourceSpec": "<spec-id>",
  "sourceBranch": null,
  "createdAt": "<ISO 8601 timestamp>",
  "status": "open"
}
```

### Step 8: Update Spec Index Counts

Update `extractedItems.epics` and `extractedItems.stories` with final counts.

### Step 9: Display Summary

```
## Spec Imported Successfully

**Spec ID:** spec-001
**Title:** Feature Specification Title
**Stored:** .plan/specs/spec-001-feature-specification-title.md

### Extracted Items

**Epics:** 2
- Epic 1: User Authentication
- Epic 2: Dashboard Features

**Stories:** 8
- As a user, I want to log in with email and password
- As a user, I want to reset my password
- ...

### MVP Scope (MoSCoW)

| Phase | Count | Items |
|-------|-------|-------|
| MUST  | 5     | US-001, US-002, US-003, US-005, US-007 |
| SHOULD | 2    | US-004, US-006 |
| COULD | 1     | US-008 |
| (no marker) | 0 | — |

**MVP Items:** 5 stories marked as MUST
Use `/pro:backlog.mvp` to work through MVP items.

### Backlog Updates

- Added: 10 new items
- Skipped: 2 duplicates (already in backlog)

All new items have been added to the backlog as "open".
Use `/pro:backlog` to select items to work on.
Use `/pro:spec` to view imported specifications.
```

## Parsing Examples

### Epic Example
```markdown
## Epic 1: User Authentication
User authentication with email/password and social login options.
```
→ Creates epic with title "User Authentication"

### Story Example
```markdown
As a user, I want to log in with my email and password so that I can access my account.

**Acceptance Criteria:**
- [ ] Email field validates format
- [ ] Password must be 8+ characters
- Given I enter valid credentials, When I click login, Then I am redirected to dashboard
```
→ Creates story with title and description including all ACs

### Numbered Section Example
```markdown
## 1. User Management

### 1.1 Login Flow
Allow users to sign in with email/password.

### 1.2 Password Reset
Allow users to reset forgotten passwords.
```
→ Creates 1 epic ("User Management") and 2 stories ("Login Flow", "Password Reset")

## Edge Cases

- **Unstructured specs:** Store raw file, extract 0 items, inform user
- **Duplicate import:** Skip items that already exist in backlog
- **Malformed structure:** Be conservative, only extract clearly identifiable items
- **Large specs:** Process incrementally, show progress

## No Branch Creation

This command is an I/O operation. It persists specs and populates the backlog, but does NOT:
- Create git branches
- Switch branches
- Start work
- Enter plan mode

To start working on imported items, use `/pro:backlog`.
