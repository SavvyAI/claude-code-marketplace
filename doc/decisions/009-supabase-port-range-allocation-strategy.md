# 009. Supabase Port Range Allocation Strategy

Date: 2025-01-23

## Status

Accepted

## Context

When running multiple Supabase projects locally on a single machine, each project requires its own set of ports for various services (API, database, Studio, Inbucket, Analytics). The default Supabase ports (54320-54329) conflict between projects, requiring manual configuration of `supabase/config.toml` for each project.

Users need a way to:
1. Detect which port ranges are already in use by other Supabase projects
2. Get recommendations for non-conflicting port ranges
3. Configure new projects with unique ports automatically

## Decision

We implement a port range detection and allocation strategy with these characteristics:

1. **Detection via Docker**: Scan running containers with `docker ps` filtering for `supabase_*` naming pattern to identify active instances and their port mappings.

2. **Range-based allocation**: Treat Supabase ports as a contiguous range (543xx) and offset entire ranges by 1000 for new projects:
   - Default: 543xx (54320-54329)
   - Next: 553xx (55320-55329)
   - Next: 563xx (56320-56329)

3. **Consistent offset mapping**: Each service maintains its position within the range:
   - API: BASE + 21 (e.g., 54321, 55321, 56321)
   - DB: BASE + 22
   - Studio: BASE + 23
   - etc.

4. **User choice**: Present detected ranges and recommendations, letting users select from available options rather than auto-assigning.

## Consequences

**Positive:**
- Predictable port assignments (knowing one port reveals all others)
- Easy to remember (563xx means "third project")
- Simple mental model for users managing multiple projects
- Non-destructive: existing projects remain unchanged

**Negative:**
- Large gaps between ranges (1000 ports) may seem wasteful
- Doesn't handle edge cases like partially-running instances
- Relies on Docker container naming convention which could change

## Alternatives Considered

1. **Sequential port assignment**: Assign ports one-by-one (54321, 54322... then 54331, 54332...). Rejected because it's harder to mentally group services by project.

2. **Hash-based allocation**: Generate ports from project name hash. Rejected because unpredictable and could still collide.

3. **User-specified base port**: Let user specify exact starting port. Kept as fallback option but not default, as recommendations are more user-friendly.

## Related

- Planning: `.plan/.done/feat-supabase-local-command/`
- Command: `pro/commands/supabase.local.md`
