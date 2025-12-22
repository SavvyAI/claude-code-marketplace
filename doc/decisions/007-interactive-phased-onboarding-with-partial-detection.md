# 007. Interactive Phased Onboarding with Partial Detection

Date: 2025-12-22

## Status

Accepted

## Context

The `/pro:handoff` command generates comprehensive codebase documentation but is passive - it produces a report without taking action. New developers joining a project need more than documentation; they need guidance through the actual setup process with verification that each step succeeded.

The original `/pro:onboarding` concept was documented during the wtf-alias feature but explicitly deferred as out of scope. This feature implements that vision.

Key questions:
1. Should onboarding be passive (like handoff) or interactive?
2. How should it handle developers who have already completed some setup steps?
3. How can we verify setup actually worked, not just that commands ran?

## Decision

We will implement `/pro:onboarding` as a **5-phase interactive guide with partial setup detection and smoke testing**:

### 1. Five-Phase Structure
| Phase | Purpose | Interactive? |
|-------|---------|--------------|
| Prerequisites | Verify tools installed | Yes - run checks, report pass/fail |
| Environment | Setup project locally | Yes - confirm each command |
| IDE/Tooling | Configure development tools | Yes - recommend, offer to verify |
| First Steps | Orient to codebase | Read-only guidance |
| Smoke Test | Verify app actually runs | Yes - run dev server, confirm working |

### 2. Partial Setup Detection
Before prompting to run a command, check if it's already done:
- `node_modules/` exists → skip npm install
- `.env` exists → skip env copy
- Docker containers running → skip docker compose up
- Git hooks installed → skip prepare

### 3. Per-Command Confirmation
Always ask before executing setup commands (npm install, docker compose, etc.) rather than running them automatically. This:
- Teaches new developers what setup involves
- Isolates failures to individual steps
- Respects user agency over their environment

### 4. Smoke Test Phase
After setup, verify the app actually runs by:
- Detecting the dev command from package.json
- Running it in background with user confirmation
- Watching for ready indicators in output
- Reporting pass/fail with actual error output if failed

## Consequences

**Positive:**
- New developers get verified, working setup (not just "commands ran")
- Partial setup detection prevents wasting time re-running completed steps
- Interactive approach teaches the setup process, not just executes it
- Smoke test catches "setup completed but app doesn't work" scenarios
- Clear pass/fail indicators show exactly what succeeded/failed

**Negative:**
- More complex than a simple checklist document
- Requires more user interaction (each command needs confirmation)
- Smoke test adds time and may not apply to all project types (libraries, CLI tools)
- Windows support requires different command patterns

## Alternatives Considered

### 1. Passive Report (like handoff)
Generate a checklist document without actually running commands.

**Rejected because:** Doesn't verify setup worked. New developers would still need to manually run and troubleshoot each step.

### 2. Fully Automatic Setup
Run all setup commands without asking.

**Rejected because:** Too aggressive for unfamiliar codebases. Setup commands can have side effects (creating files, starting services, modifying configs). New developers should understand what's happening.

### 3. Batch Confirmation
Show all commands upfront and ask once before running the full sequence.

**Rejected for default:** If one command fails, the entire sequence stops. Per-command approach isolates failures. However, this could be a future "fast mode" option.

### 4. Skip Smoke Test
End after Phase 4 (First Steps Guide).

**Rejected because:** The most valuable signal is "does it actually work?" Many setup issues only surface when running the app.

## Related

- Planning: `.plan/.done/feat-add-onboarding-command/`
- Original concept: `.plan/.done/feat-wtf-alias-and-report-output/plan.md` (Future: Onboarding Command section)
- Contrast with: `/pro:handoff` (documentary) vs `/pro:onboarding` (interactive)
