---
description: "Install bundled CLAUDE.md rules → Interactive symlink creation → Global or project-level installation"
allowed-tools: ["Bash", "Read", "Glob", "AskUserQuestion"]
---

# Install Pro Plugin Rules

Interactively install the bundled CLAUDE.md rules via symlink.

## Instructions

1. **Locate the plugin's CLAUDE.md file**
   - Find the installed pro plugin directory by searching for it:
     ```bash
     find ~/.claude -name "plugin.json" -path "*pro*" 2>/dev/null | head -1 | xargs dirname | xargs dirname
     ```
   - The CLAUDE.md file is in the plugin root (sibling to the `.claude-plugin` directory)
   - Store this path as `PLUGIN_PATH` for use in subsequent commands
   - Verify the file exists: `test -f "${PLUGIN_PATH}/CLAUDE.md"`

2. **Check for existing CLAUDE.md files**
   - Check if `~/.claude/CLAUDE.md` exists (global)
   - Check if `.claude/CLAUDE.md` exists (project-level)
   - Note whether these are regular files or symlinks

3. **Ask user for installation scope**

   Use AskUserQuestion to ask:
   - **Global** (all projects): Symlinks to `~/.claude/CLAUDE.md`
   - **Project** (current project only): Symlinks to `.claude/CLAUDE.md`

4. **Handle existing files**

   If a file already exists at the target location:
   - If it's already a symlink pointing to the plugin's CLAUDE.md, inform user it's already installed
   - If it's a different file, ask user to confirm overwrite (will create backup with `.backup` extension)

5. **Create the symlink**

   Using the `PLUGIN_PATH` found in step 1:

   For global installation:
   ```bash
   mkdir -p ~/.claude
   # If backup needed: mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup
   ln -sf "${PLUGIN_PATH}/CLAUDE.md" ~/.claude/CLAUDE.md
   ```

   For project installation:
   ```bash
   mkdir -p .claude
   # If backup needed: mv .claude/CLAUDE.md .claude/CLAUDE.md.backup
   ln -sf "${PLUGIN_PATH}/CLAUDE.md" .claude/CLAUDE.md
   ```

6. **Verify installation**
   - Confirm the symlink was created successfully
   - Show the symlink target to verify it points to the correct location
   - Use `ls -la` to display the result

7. **Report success**
   - Confirm installation is complete
   - Remind user the rules are now active
   - Note that updates to the plugin will automatically apply (since it's a symlink)

## Output Format

```
## Installing Pro Plugin Rules

Source: ${plugin_claude_md_path}
Target: ${target_path}

[Status messages about existing files, backups, etc.]

Creating symlink...

Installation complete.
  ${target_path} -> ${plugin_claude_md_path}

The rules are now active. Since this is a symlink, any updates to the
pro plugin will automatically apply to your configuration.
```
