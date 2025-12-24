# Implementation Plan: /pro:dev.setup

## Phase 1: Bundle Assets

Create `pro/commands/_bins/dev/` with:
- `dev.ts` - Copy from `/Users/wilmooreiii/Documents/src/oneresume/bin/dev.ts`
- `notify.ts` - Copy from `/Users/wilmooreiii/Documents/src/oneresume/bin/notify.ts`
- `README.template.md` - Template for target project's `.dev/README.md`

## Phase 2: Create Command File

Create `pro/commands/dev.setup.md` with phases:

### Phase 2.1: Prerequisites Check
- Verify package.json exists
- Check if `bin/dev.ts` already exists (offer to overwrite)
- Check if `.dev/` directory exists

### Phase 2.2: Copy Bin Files
- Create `bin/` directory if needed
- Copy `dev.ts` and `notify.ts` from plugin assets
- Set executable permissions on dev.ts

### Phase 2.3: Configure package.json
- Add bin entry: `"bin": { "dev": "./bin/dev.ts" }`
- Add devDependencies: `"tsx": "^4.20.6"`
- Add dependencies: `"node-notifier": "^10.0.1"`

### Phase 2.4: Auto-Detect Servers
- Parse package.json scripts
- Detect dev/start/serve patterns (like existing init command)
- Generate `.dev/servers.json`

### Phase 2.5: Update .gitignore
- Append `.dev/pid.json` if not present
- Append `.dev/log/` if not present

### Phase 2.6: Add Documentation
- Append "Development Servers" section to README.md
- Create `.dev/README.md` from template

### Phase 2.7: Summary
- Display what was created
- Show quick start commands

## Phase 3: Update Plugin Documentation

Update `pro/readme.md` to add:
```
| `/pro:dev.setup` | Set up npx dev server management infrastructure |
```

## File Structure After Implementation

```
pro/
├── commands/
│   ├── _bins/
│   │   └── dev/
│   │       ├── dev.ts
│   │       ├── notify.ts
│   │       └── README.template.md
│   ├── dev.setup.md
│   └── ... (other commands)
└── readme.md
```

## Target Project Structure After Running /pro:dev.setup

```
target-project/
├── bin/
│   ├── dev.ts
│   └── notify.ts
├── .dev/
│   ├── servers.json      (auto-generated)
│   ├── README.md         (from template)
│   ├── pid.json          (created at runtime)
│   └── log/              (created at runtime)
├── .gitignore            (updated)
├── package.json          (updated with bin, deps)
└── README.md             (updated with section)
```
