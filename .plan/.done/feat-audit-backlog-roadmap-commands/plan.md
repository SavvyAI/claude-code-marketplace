# Implementation Plan: Audit, Backlog, Roadmap Commands

## Reference
- ADR: `doc/decisions/015-audit-backlog-roadmap-command-architecture.md`

## Phases

### Phase 1: Backlog Infrastructure
- [x] Create `backlog.json` schema in `.plan/`
- [x] Migrate existing `known-issues.json` → `backlog.json`
- [x] Create `/pro:backlog` command (pick items, branch, work)
- [x] Create `/pro:backlog.add` command (manual additions)

### Phase 2: Audit Command
- [x] Create `/pro:audit` command
- [x] Implement analysis categories
- [x] Screen + temp file output
- [x] Capture prompt with fingerprint deduplication

### Phase 3: Roadmap Command
- [x] Create `/pro:roadmap` command
- [x] Read from git + backlog.json
- [x] Screen + temp file output

### Cleanup
- [x] Delete `gaps.md`
- [x] Delete `known.issues.md`
- [x] Delete `known-issues.json`
- [x] Update ADR status to Accepted
- [x] Update references in feature.md, bug.md, refactor.md, pr.md
- [x] Update readme.md with new commands
- [x] Mark backlog item #1 as resolved

### Additional: Resume Command
- [x] Rename `/pro:continue` to `/pro:backlog.resume`
- [x] Add state-aware check to `/pro:backlog` for in-progress items
- [x] Delete `continue.md`
- [x] Update readme.md and ADR
- [x] Make `/pro:backlog.resume` smart: resume in-progress OR recommend highest priority

## Decisions Made
- Phased implementation: backlog first
- Delete old commands immediately (no deprecation period)
- `/pro:backlog.add` for manual additions (separate command)
- `/pro:backlog.resume` replaces `/pro:continue` (namespaced under backlog)
- `/pro:backlog` checks for in-progress work first (state awareness)
- Reports go to temp directory, not `.plan/`

## Related ADRs
- [015. Audit, Backlog, and Roadmap Command Architecture](../../doc/decisions/015-audit-backlog-roadmap-command-architecture.md)
