---
description: "Local Supabase setup? → Detects conflicts, configures unique ports → Starts verified instance"
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

# Local Supabase Setup & Management

Manages local Supabase lifecycle: initialization, port configuration, startup, and verification. Automatically detects other running Supabase instances and recommends non-conflicting port ranges.

## Status Indicators

- `[PASS]` - Check passed or step completed
- `[FAIL]` - Check failed (includes remediation)
- `[SKIP]` - Not applicable or already done
- `[WARN]` - Optional but recommended

---

## Phase 1: Prerequisites Check

### 1.1 Supabase CLI

```bash
supabase --version
```

- If installed: `[PASS] Supabase CLI vX.Y.Z`
- If missing: `[FAIL] Supabase CLI not installed`
  - Remediation: `brew install supabase/tap/supabase`

### 1.2 Docker

```bash
docker --version
docker info > /dev/null 2>&1
```

- If running: `[PASS] Docker vX.Y.Z (daemon running)`
- If not running: `[FAIL] Docker daemon not running`
  - Remediation: Start Docker Desktop or `dockerd`

---

## Phase 2: Detect Current State

### 2.1 Check if Supabase is Initialized

Look for `supabase/config.toml` in the current project:

```bash
test -f supabase/config.toml && echo "initialized" || echo "not initialized"
```

### 2.2 Check if Running (if initialized)

```bash
supabase status 2>/dev/null
```

**Decision Tree:**

| Initialized? | Running? | Action |
|--------------|----------|--------|
| No | - | → Phase 3 (Setup) |
| Yes | No | → Phase 4 (Start) |
| Yes | Yes | → Phase 5 (Status) |

---

## Phase 3: Setup (Not Initialized)

### 3.1 Detect Running Supabase Instances

Find all Supabase containers across projects:

```bash
docker ps --format "table {{.Names}}\t{{.Ports}}" 2>/dev/null | grep -E "supabase_"
```

Parse the output to identify:
- Project names (from container name suffix)
- Port ranges in use

### 3.2 Identify Port Ranges in Use

**Default Supabase Ports:**

| Service | Config Key | Default |
|---------|-----------|---------|
| API | `api.port` | 54321 |
| Database | `db.port` | 54322 |
| Shadow DB | `db.shadow_port` | 54320 |
| Pooler | `db.pooler.port` | 54329 |
| Studio | `studio.port` | 54323 |
| Inbucket Web | `inbucket.port` | 54324 |
| Inbucket SMTP | `inbucket.smtp_port` | 54325 |
| Inbucket POP3 | `inbucket.pop3_port` | 54326 |
| Analytics | `analytics.port` | 54327 |
| Analytics Vector | `analytics.vector_port` | 54328 |

**Port Range Strategy:** Offset by 1000 (e.g., 543xx → 553xx → 563xx)

Analyze running containers and determine which ranges are occupied:
- 543xx (default)
- 553xx (+1000)
- 563xx (+2000)
- etc.

### 3.3 Recommend Available Port Range

Present findings to user:

```
Existing Supabase Instances:
┌─────────────┬─────────────┐
│ Project     │ Port Range  │
├─────────────┼─────────────┤
│ oneresume   │ 543xx       │
│ agentico    │ 553xx       │
└─────────────┴─────────────┘

Recommended for {current-project}: 563xx
```

### 3.4 User Chooses Port Range

Use AskUserQuestion with options:
- Option 1: Recommended range (e.g., "Use 563xx - API: 56321, DB: 56322, Studio: 56323")
- Option 2: Next available (e.g., "Use 564xx - API: 56421, DB: 56422, Studio: 56423")
- Option 3: Custom - let user specify base port

### 3.5 Initialize Supabase

```bash
supabase init
```

### 3.6 Configure Ports in config.toml

After user selects port range (base port), update `supabase/config.toml`:

**Port Mapping (where BASE = chosen base, e.g., 56300):**

| Config Key | Value |
|-----------|-------|
| `api.port` | BASE + 21 |
| `db.port` | BASE + 22 |
| `db.shadow_port` | BASE + 20 |
| `db.pooler.port` | BASE + 29 |
| `studio.port` | BASE + 23 |
| `inbucket.port` | BASE + 24 |
| `inbucket.smtp_port` | BASE + 25 |
| `inbucket.pop3_port` | BASE + 26 |
| `analytics.port` | BASE + 27 |
| `analytics.vector_port` | BASE + 28 |

Use the Edit tool to update each port setting in `supabase/config.toml`.

### 3.7 Start Supabase

Proceed to Phase 4.

---

## Phase 4: Start (Initialized but Not Running)

### 4.1 Start Supabase

```bash
supabase start
```

### 4.2 Verify Healthy Startup

After start completes, verify all services are running:

```bash
supabase status
```

Check that output shows:
- API URL is accessible
- DB URL is accessible
- Studio URL is accessible

Report:
- `[PASS] Supabase started successfully`
- Or `[FAIL]` with specific service that failed

### 4.3 Display Access URLs

Parse `supabase status` output and display:

```
Supabase is running:
┌─────────────┬─────────────────────────────┐
│ Service     │ URL                         │
├─────────────┼─────────────────────────────┤
│ API         │ http://127.0.0.1:56321      │
│ Studio      │ http://127.0.0.1:56323      │
│ Inbucket    │ http://127.0.0.1:56324      │
│ Database    │ postgresql://...            │
└─────────────┴─────────────────────────────┘
```

---

## Phase 5: Status (Already Running)

### 5.1 Report Current Status

```bash
supabase status
```

Display:
- `[PASS] Supabase is already running`
- Show all service URLs

---

## Phase 6: Everyday Commands Reference

Always display this reference at the end:

```
Useful Commands:
────────────────────────────────────────
supabase start         Start local instance
supabase stop          Stop local instance
supabase status        Check status & URLs
supabase db reset      Reset database (destructive)
supabase db push       Push local migrations to remote
supabase migration list   List migrations
supabase gen types typescript --local   Generate TypeScript types
────────────────────────────────────────
```

---

## Error Handling

### Port Conflict on Start

If `supabase start` fails due to port conflict:
1. Run detection again to find what's using the port
2. Offer to reconfigure ports
3. Or suggest stopping the conflicting instance

### Docker Issues

If Docker-related errors occur:
1. Check Docker daemon: `docker info`
2. Check Docker resources (memory/CPU)
3. Suggest: `docker system prune` if disk space issues

---

## Output Summary

After completion, summarize:

```
/pro:supabase.local Summary
───────────────────────────────────────
Project:     {project-name}
Status:      {initialized | started | already running}
Port Range:  {XXX}xx
API:         http://127.0.0.1:{port}
Studio:      http://127.0.0.1:{port}
Database:    postgresql://postgres:postgres@127.0.0.1:{port}/postgres
───────────────────────────────────────
```
