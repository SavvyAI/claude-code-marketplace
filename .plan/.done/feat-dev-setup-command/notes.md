# Feature: /pro:dev.setup

## Overview

A slash command that sets up the `npx dev` server management infrastructure in a target project.

## What It Does

1. **Copies bin files** from `pro/commands/_bins/dev/` to target's `bin/` directory:
   - `dev.ts` - Main CLI script
   - `notify.ts` - Native OS notification helper

2. **Creates `.dev/servers.json`** by auto-detecting server scripts from package.json

3. **Updates package.json**:
   - Adds `"bin": { "dev": "./bin/dev.ts" }`
   - Adds `tsx` to devDependencies
   - Adds `node-notifier` to dependencies

4. **Updates .gitignore**:
   - Adds `.dev/pid.json`
   - Adds `.dev/log/`

5. **Adds documentation**:
   - Brief section in main README.md
   - Detailed docs in `.dev/README.md`

## User Answers

| Question | Answer |
|----------|--------|
| Asset storage path | `pro/commands/_bins/dev/` |
| Force mode | N/A - command only sets up, doesn't run |
| node-notifier handling | Add to target's package.json |
| Auto-detect scripts | Yes |
| Documentation | Both README locations |
| Gitignore updates | Add .dev/pid.json and .dev/log/ only |

## Implementation Complete

### Files Created:
- `pro/commands/dev.setup.md` - The slash command (8 phases)
- `pro/commands/_bins/dev/dev.ts` - Main CLI (refactored with command-first pattern)
- `pro/commands/_bins/dev/notify.ts` - Native OS notifications
- `pro/commands/_bins/dev/README.template.md` - Template for target .dev/README.md

### Files Updated:
- `pro/readme.md` - Added `/pro:dev.setup` to commands table

### CLI Refactoring:
Changed from inconsistent pattern:
```
npx dev web stop      # server-first
npx dev logs web      # command-first
```

To consistent command-first pattern:
```
npx dev start [name]
npx dev stop [name]
npx dev restart name
npx dev status
npx dev logs [name]
```

### Coderabbit Fixes:
- Fixed "pids.json" → "pid.json" typo in comments
- Added JSON.parse error handling for loadServersConfig and loadPidFile
- Moved init/help handling before loadServersConfig to fix blocking issue
- Added child.pid undefined guard after spawn
