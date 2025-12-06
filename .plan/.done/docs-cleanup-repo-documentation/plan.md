# Plan: Cleanup Repository Documentation

## Branch
`docs/cleanup-repo-documentation`

## Objective
Clean up and consolidate repository documentation to reduce clutter and improve maintainability.

## Problems Identified
1. READMEs are verbose with redundant content
2. New `/pro:og` command is not documented in READMEs
3. `.plan/` directories exist in two locations (root and `pro/`)

## Solution

### 1. Consolidate .plan/ Directories
- Move `pro/.plan/.done/` contents to root `.plan/.done/`
- Remove `pro/.plan/` directory
- Single location for all planning artifacts

### 2. Streamline Root README
- Keep brief intro (1-2 sentences)
- Minimal installation (clone command only)
- Simple plugin listing with link to plugin README
- Minimal contributing section
- Target: ~40 lines

### 3. Streamline Pro README
- Brief intro
- Command table with all 8 commands (including new `/pro:og`)
- Single workflow example
- Target: ~50 lines

## Implementation Steps

1. Move `pro/.plan/.done/*` to `.plan/.done/`
2. Delete empty `pro/.plan/` directory
3. Rewrite `readme.md` (root) - minimal version
4. Rewrite `pro/readme.md` - add `/pro:og`, simplify content
5. Verify links work correctly

## Success Criteria
- Single `.plan/` location at root
- READMEs are concise (<60 lines each)
- All 8 commands documented in Pro README
- No broken links
