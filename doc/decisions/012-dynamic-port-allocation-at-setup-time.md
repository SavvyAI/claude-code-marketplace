# 012. Dynamic Port Allocation at Setup Time

Date: 2025-12-24

## Status

Accepted

## Context

The `/pro:dev.setup` command was hardcoding port 3000 as the starting port for all server configurations. This caused frequent port conflicts because:

1. Multiple projects on the same machine would all attempt to use port 3000
2. Common frameworks default to port 3000 (Rails, React, Express, Next.js)
3. Users had to manually edit `.dev/servers.json` after every setup to avoid conflicts

The design principle in CLAUDE.md explicitly states: "Never hardcode localhost ports; always read from config" and "Hardcode values that can be resolved dynamically."

## Decision

Modify `dev.setup` to dynamically scan for available ports **at setup time** rather than using hardcoded defaults.

The port allocation strategy:

1. **Scan port ranges in order of preference:**
   - Primary: 4000-4099 (clean range, minimal known conflicts)
   - Fallback 1: 6000-6099 (alternative range)
   - Fallback 2: 7000-7099 (secondary fallback)

2. **Port detection mechanism:**
   ```bash
   lsof -i :<port>  # Returns error if port is free
   ```

3. **Assignment pattern:**
   - First free port becomes `basePort` for the first server
   - Subsequent servers: `basePort + 10`, `basePort + 20`, etc.

4. **Graceful fallback:**
   - If all scanned ranges are busy, default to 4000 with a warning

## Consequences

### Positive

- Zero-conflict setup for projects across machines with varying services
- Follows the existing 10-port spacing convention from `findFreePort` in dev.ts
- Avoids well-known conflict ports (3000, 5000, 8080)
- Consistent with the Supabase local command's port allocation strategy (ADR-009)

### Negative

- Port scan adds ~1-2 seconds to setup time
- `lsof` is macOS/Linux only (Windows WSL works; native Windows would need `netstat -ano`)
- Ports may differ between developer machines (mitigated by the 4000-range preference)

## Alternatives Considered

1. **Random port selection** - Rejected because it makes it harder for developers to remember/share ports
2. **User prompt for port** - Rejected as too much friction for a common operation
3. **Keep 3000 default** - Rejected because it caused the original conflict issue

## Related

- Planning: `.plan/.done/fix-dev-setup-port-detection/`
- ADR-009: Supabase Port Range Allocation Strategy (similar pattern)
