# Fix: dev.setup Port Detection

## Problem Statement

The `/pro:dev.setup` command hardcodes port 3000 as the starting port for server configurations. This causes conflicts when:

1. Multiple projects on the same machine all try to use port 3000
2. Common frameworks (Rails, React, Express) default to port 3000
3. Another server is already running on port 3000

**Evidence:**
```
/Users/wilmooreiii/Documents/src/vinwise $ npx dev
Starting dev...
❌ dev failed health check at http://localhost:3002
```

The log shows:
```
⚠ Port 3000 is in use by process 86255, using available port 3002 instead.
```

## Root Cause

In `pro/commands/dev.setup.md`, lines 158-160:

```markdown
**Port Assignment:**
- First server: 3000
- Subsequent servers: increment by 10 (3010, 3020, etc.)
```

This violates CLAUDE.md rules:
- "Never hardcode localhost ports; always read from config"
- "Hardcode values that can be resolved dynamically"

## Solution

Modify `dev.setup.md` to dynamically find available ports at setup time:

### Port Allocation Strategy

1. **Define acceptable port ranges** (avoid reserved/well-known ports):
   - User ports: 1024-49151
   - Dynamic/private: 49152-65535
   - Avoid well-known conflicts: 3000, 5000, 8000, 8080

2. **Preferred starting ranges** (in order of preference):
   - 4000-4999: Clean range, minimal conflicts
   - 6000-6999: Alternative if 4000s busy
   - 7000-7999: Fallback range

3. **Port scanning algorithm**:
   ```
   for each candidate range (4000, 6000, 7000):
     startPort = findFirstFreePort(candidate, candidate + 100)
     if found:
       break

   servers[0].preferredPort = startPort
   servers[1].preferredPort = startPort + 10
   servers[2].preferredPort = startPort + 20
   ...
   ```

4. **Port check command** (already in dev.ts):
   ```bash
   lsof -i :<port>  # returns error if port is free
   ```

## Implementation Steps

### Step 1: Update dev.setup.md Phase 4.2

Change the port assignment section to:

```markdown
**Port Assignment:**
1. Scan for available ports starting from 4000
2. Use `lsof -i :<port>` to check availability
3. First free port becomes first server's preferredPort
4. Subsequent servers: increment by 10

**Port Scan Ranges (in order):**
- Primary: 4000-4099
- Fallback 1: 6000-6099
- Fallback 2: 7000-7099

**Command to find free port:**
```bash
for port in 4000 4001 4002 ... ; do
  lsof -i :$port 2>/dev/null || echo $port && break
done
```
```

### Step 2: Add Port Scanning Instructions

Add a new section to Phase 4 that runs before server detection:

```markdown
### 4.0 Find Available Port Range

Before assigning ports, scan for available ports:

```bash
# Check ports 4000-4099, find first free
for port in $(seq 4000 4099); do
  if ! lsof -i :$port >/dev/null 2>&1; then
    echo "Found free port: $port"
    break
  fi
done
```

Store the result as `basePort` for subsequent assignments.
```

### Step 3: Update Error Handling

Add a new error case for when no ports are available:

```markdown
### No Available Ports

If no free ports found in any range:
1. Report: "[WARN] Could not find free port in ranges 4000-4099, 6000-6099, 7000-7099"
2. Default to 4000 with warning: "Port 4000 may conflict - edit .dev/servers.json as needed"
```

## Test Plan

1. Kill any process on port 3000: `kill -9 86255`
2. In vinwise project:
   - Delete `.dev/servers.json`
   - Run `/pro:dev.setup` again
3. Verify new `servers.json` has ports in 4000+ range
4. Run `npx dev` and confirm health check passes

## Files to Modify

| File | Changes |
|------|---------|
| `pro/commands/dev.setup.md` | Update port assignment logic in Phase 4.2 |

## Definition of Done

- [x] dev.setup scans for available ports at setup time
- [x] Ports start from 4000+ range, not 3000
- [x] Port scan uses multiple fallback ranges (4000, 6000, 7000)
- [x] vinwise servers.json updated to use port 4000
- [ ] User verification: `npx dev` runs without port conflicts
- [ ] No regressions to existing dev.setup functionality

## Changes Made

### `pro/commands/dev.setup.md`

1. Added new section **4.1 Find Available Port Range** that:
   - Scans port ranges 4000-4099, 6000-6099, 7000-7099 (in order)
   - Uses `lsof -i :<port>` to check availability
   - Stores `basePort` for subsequent server assignments
   - Falls back to 4000 with warning if all ranges busy

2. Renumbered sections 4.2-4.6 to accommodate new port scan step

3. Updated **Port Assignment** to use dynamic `basePort`:
   - First server: `basePort` (not hardcoded 3000)
   - Subsequent: `basePort + 10`, `basePort + 20`, etc.

4. Updated summary example to show ports 4000/4010

5. Updated error handling template to use `<basePort>` placeholder

### `vinwise/.dev/servers.json`

- Changed `preferredPort` from 3000 → 4000
- Changed second server from 3010 → 4010
