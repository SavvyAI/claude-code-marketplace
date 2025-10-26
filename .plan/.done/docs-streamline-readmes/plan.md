# Plan: Streamline README Files

## Objective
Remove duplication between marketplace and Pro plugin README files. Make both super minimal with just essentials: installation, contributing, light command info, and links to source.

## Problem
Current READMEs have extensive duplication:
- Marketplace README documents Pro plugin commands in detail
- Pro plugin README has the same detailed documentation
- Both have extensive examples, workflows, and guides
- Creates maintenance burden and redundancy

## Solution
Streamline both READMEs to minimal essential information:

### Marketplace README Changes
- Keep brief intro (2-3 sentences)
- Minimal installation steps
- Simple plugin list with 1-line descriptions
- Link to individual plugin READMEs for details
- Brief contributing section
- Remove extensive plugin development guide

### Pro Plugin README Changes
- Keep brief intro about Pro's purpose
- Simple command table: name, 1-line description, link to source .md
- 1-2 basic usage examples
- Remove detailed command documentation
- Remove extensive workflows and tips sections

## Implementation Steps
1. Simplify `readme.md` (marketplace root)
2. Simplify `pro/readme.md`
3. Ensure proper linking between docs
4. Review for consistency

## Success Criteria
- READMEs are <100 lines each
- No duplicated content between files
- Clear navigation via links
- Installation and contribution info preserved
- Users can find detailed info via links
