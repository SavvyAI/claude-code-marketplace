---
description: "Need to onboard developers? → Analyzes codebase structure, health, and operations → Generates comprehensive handoff documentation"
allowed-tools: ["Bash", "Read", "Glob", "Grep", "Write"]
---

# Codebase Handoff Report Generator

Generate a comprehensive codebase handoff report suitable for developer onboarding, team transitions, or project audits. This report should provide a complete picture of the project's current state, health, and operational knowledge.

## Instructions

**ultrathink:** This handoff report must capture comprehensive institutional knowledge. Before exploring the codebase, consider what a new developer would need to understand: architectural decisions, operational patterns, tribal knowledge, and non-obvious gotchas. Look for patterns that span multiple files and aren't immediately apparent.

1. Read the report template from `_templates/handoff-report.md` (relative to this command file)
2. Thoroughly explore the codebase and generate a structured markdown report covering ALL sections in the template
3. Use actual data from the codebase - do not make assumptions
4. If information is unavailable, explicitly note it as "Not found" or "Not configured"
5. For metrics that require running commands, run them and include the actual results

## Output Requirements

### 1. Generate the Report
Generate the report as a single markdown document with clear section headers. Use tables where specified.

### 2. Save to Temp Directory
Save the report to a file using this naming convention:
- **Filename pattern:** `handoff-{project}-{timestamp}.md`
- **Location:** Cross-platform temp directory
- **Project name:** Use the current directory name (lowercase, sanitized)
- **Timestamp:** Format as `YYYYMMDD-HHMMSS`

**Platform-specific temp directory:**
- **macOS/Linux/WSL:** `${TMPDIR:-/tmp}/`
- **Windows (PowerShell):** `$env:TEMP\` or `%TEMP%\`

Example (Unix): `${TMPDIR:-/tmp}/handoff-myproject-20241222-143022.md`
Example (Windows): `$env:TEMP\handoff-myproject-20241222-143022.md`

### 3. Copy to Clipboard
After saving the file, copy the markdown content to the clipboard:
- **macOS:** `pbcopy`
- **Linux:** `xclip -selection clipboard` (or `xsel --clipboard` if xclip unavailable)
- **Windows/WSL:** `clip.exe`

Use this detection pattern:
```bash
if command -v pbcopy &> /dev/null; then
    cat "$OUTPUT_FILE" | pbcopy
elif command -v xclip &> /dev/null; then
    cat "$OUTPUT_FILE" | xclip -selection clipboard
elif command -v xsel &> /dev/null; then
    cat "$OUTPUT_FILE" | xsel --clipboard
elif command -v clip.exe &> /dev/null; then
    cat "$OUTPUT_FILE" | clip.exe
fi
```

### 4. Report Output Location
After completing the report, clearly display:
- The full path to the saved file
- Confirmation that the report was copied to clipboard

## Report Footer

End the report with:
- Report generated: [timestamp]
- Git commit: [current HEAD commit hash]
- Generator: Claude Code /pro:handoff

## Design Principles

This report is designed to be:
1. **Comprehensive** - covers code, ops, security, and tribal knowledge
2. **Actionable** - includes specific commands to run for metrics
3. **Structured** - consistent table formats for easy scanning
4. **Honest** - explicitly notes missing information rather than hiding gaps
