# /pro:supabase.local Command

## Problem Statement

When working on multiple projects on a single machine, each using Supabase, port conflicts are common. The default Supabase ports (54320-54329) clash between projects. Manually configuring unique ports in `supabase/config.toml` is tedious and error-prone.

## Solution

A comprehensive command that handles local Supabase lifecycle:
- Detects existing Supabase instances
- Recommends non-conflicting port ranges
- Initializes, configures, starts, and verifies Supabase

## Flow

```
/pro:supabase.local
        │
        ▼
┌───────────────────────┐
│ Is Supabase           │
│ initialized?          │
│ (config.toml exists)  │
└───────────┬───────────┘
            │
   ┌────────┴────────┐
   │ NO              │ YES
   ▼                 ▼
┌─────────────┐  ┌─────────────────┐
│ SETUP:      │  │ Is it running?  │
│ 1. Detect   │  │ (docker ps)     │
│    instances│  └────────┬────────┘
│ 2. Recommend│           │
│    ports    │  ┌────────┴────────┐
│ 3. User     │  │ NO              │ YES
│    chooses  │  ▼                 ▼
│ 4. Init     │ ┌──────────┐ ┌──────────────┐
│ 5. Configure│ │ START    │ │ REPORT       │
│ 6. Start    │ │ & verify │ │ status       │
│ 7. Verify   │ └──────────┘ └──────────────┘
└─────────────┘

ALWAYS: Print useful everyday commands
```

## Supabase Default Ports

| Service | Config Key | Default Port |
|---------|-----------|--------------|
| API (PostgREST) | `api.port` | 54321 |
| Database | `db.port` | 54322 |
| Shadow Database | `db.shadow_port` | 54320 |
| Connection Pooler | `db.pooler.port` | 54329 |
| Studio Dashboard | `studio.port` | 54323 |
| Inbucket (Email) Web | `inbucket.port` | 54324 |
| Inbucket SMTP | `inbucket.smtp_port` | 54325 |
| Inbucket POP3 | `inbucket.pop3_port` | 54326 |
| Analytics (Logflare) | `analytics.port` | 54327 |
| Analytics Vector | `analytics.vector_port` | 54328 |

## Port Range Strategy

Offset entire range by increments of 1000 or 100:
- Default: 543xx
- Project A: 553xx (+1000)
- Project B: 563xx (+2000)
- etc.

## Detection Strategy

1. Run `docker ps` to find running Supabase containers
2. Parse container names (pattern: `supabase_*_{project}`)
3. Extract port mappings from running containers
4. Identify which port ranges are in use
5. Recommend next available range

## User Interaction

Present port range choices via AskUserQuestion:
- Option 1: Recommended range (e.g., "Use 563xx")
- Option 2: Alternative range (e.g., "Use 564xx")
- Option 3: Custom (let user specify)

## Everyday Commands Reference

Print these for user reference:
```bash
supabase start        # Start local instance
supabase stop         # Stop local instance
supabase status       # Check status
supabase db reset     # Reset database
supabase migration    # Run migrations
```

## Acceptance Criteria

- [ ] Detects if Supabase is initialized in current project
- [ ] Detects running Supabase instances across all projects
- [ ] Recommends non-conflicting port ranges
- [ ] Lets user choose port range
- [ ] Configures `supabase/config.toml` with chosen ports
- [ ] Starts Supabase and verifies healthy startup
- [ ] Prints useful everyday commands
