---
description: "View bundled CLAUDE.md rules → Shows file location and symlink commands → Version-controlled global instructions"
allowed-tools: ["Bash", "Read", "Glob"]
---

# Pro Plugin Rules

Display the bundled CLAUDE.md rules and provide symlink commands for installation.

## Instructions

1. **Locate the plugin's CLAUDE.md file**
   - Find the installed pro plugin directory by searching for it:
     ```bash
     find ~/.claude -name "plugin.json" -path "*pro*" 2>/dev/null | head -1 | xargs dirname | xargs dirname
     ```
   - The CLAUDE.md file is in the plugin root (sibling to the `.claude-plugin` directory)
   - Store this path for use in the symlink commands

2. **Display the file location**
   - Show the absolute path to the bundled CLAUDE.md file
   - This helps users understand where the version-controlled rules live

3. **Display the rules content**
   - Read and display the full content of the CLAUDE.md file
   - Use a code block or quoted section for clarity

4. **Provide symlink commands**

   After finding the plugin path (let's call it `PLUGIN_PATH`), show ready-to-run commands:

   **Global installation** (applies to all projects):
   ```bash
   ln -sf "${PLUGIN_PATH}/CLAUDE.md" ~/.claude/CLAUDE.md
   ```

   **Project-level installation** (applies to current project only):
   ```bash
   mkdir -p .claude && ln -sf "${PLUGIN_PATH}/CLAUDE.md" .claude/CLAUDE.md
   ```

   Replace `${PLUGIN_PATH}` with the actual absolute path found in step 1.

5. **Note about existing files**
   - Warn users that the symlink will replace any existing CLAUDE.md at the target location
   - Suggest backing up existing files first if they have custom content

## Output Format

```
## Pro Plugin Rules

### File Location
The bundled CLAUDE.md is located at:
  ${absolute_path_to_plugin}/CLAUDE.md

### Current Rules Content

[Display the content of CLAUDE.md]

### Installation Commands

To symlink globally (all projects):
  ln -sf "${path}" ~/.claude/CLAUDE.md

To symlink to current project:
  mkdir -p .claude && ln -sf "${path}" .claude/CLAUDE.md

Note: These commands will replace any existing CLAUDE.md at the target location.
Consider backing up existing files first if they contain custom content.

Tip: Use /pro:rules.install for interactive installation with prompts.
```
