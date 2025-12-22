# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) documenting significant technical decisions.

## What is an ADR?

An ADR captures the context, decision, and consequences of an architecturally significant choice.

## Format

We use the [Michael Nygard format](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).

## Naming Convention

- Filename: `NNN-kebab-case-title.md` (e.g., `001-use-localStorage-for-tracking.md`)
- NNN = zero-padded sequence number (001, 002, 003...)
- Title in heading must match: `# NNN. Title` (e.g., `# 001. Use localStorage for Tracking`)

## Index

- [001. Integrate ADRs into PR Workflow](001-integrate-adrs-into-pr-workflow.md)
- [002. Support HTTP Transport MCP Servers](002-support-http-transport-mcp-servers.md)
- [003. Symlink Approach for Plugin Instructions](003-symlink-approach-for-plugin-instructions.md)
- [004. Forensic Capture Workflow for Bug Command](004-forensic-workflow-for-bug-command.md)
- [005. Runtime Inference for Version Check](005-runtime-inference-for-version-check.md)
- [006. Subdirectory Pattern for Shared Templates](006-subdirectory-pattern-for-shared-templates.md)
