# Claude Code Marketplace

A curated collection of plugins that extend Claude Code with advanced development workflows and automation.

## What is This?

A plugin registry that makes it easy to:

- **Install powerful plugins** with simple commands
- **Streamline your workflow** with pre-built commands and automations
- **Share your own plugins** with the community
- **Manage plugin versions** and updates

## Quick Start

### Installing the Marketplace

1. Clone this repository:
```bash
git clone git@github.com:SavvyAI/claude-code-marketplace.git
cd claude-code-marketplace
```

2. The marketplace configuration automatically makes plugins available - just start using the commands!

### Using Plugins

Once installed, use plugin commands directly in Claude Code:

```bash
# Create a new feature with planning mode
/pro:feature "add user authentication"

# Create a pull request
/pro:pr
```

## Available Plugins

### Pro - Product Planning & Development Workflows

**Author:** Wil Moore III
**Version:** 1.0.0

Supercharges your development workflow with intelligent planning, branch management, and pull request automation.

**Commands:**
- `/pro:feature` - Create feature branches with guided planning
- `/pro:continue` - Continue working on existing plans
- `/pro:gaps` - Run comprehensive gap analysis
- `/pro:refactor` - Refactoring workflow automation
- `/pro:pr` - Create and push pull requests
- `/pro:pr.resolve` - Resolve all PR comments systematically
- `/pro:pr.merged` - Post-merge cleanup automation

[Learn more about the Pro plugin](./pro/readme.md)

## For Users: Using Plugins

### Understanding Plugin Commands

Plugins provide custom slash commands that you can use in Claude Code:

```
/plugin-name:command-name [arguments]
```

Examples:
- `/pro:feature "my new feature"` - Uses the `pro` plugin's `feature` command
- `/pro:pr` - Uses the `pro` plugin's `pr` command

### Command Syntax

Most commands support natural language arguments:

```bash
/pro:feature "add dark mode toggle to settings"
```

### Finding Available Commands

Each plugin's README lists all available commands. Check the plugin directory for detailed documentation.

## For Developers: Creating Plugins

Plugins are built using markdown files and simple JSON configuration.

### Plugin Structure

A basic plugin looks like this:

```
your-plugin/
  .claude-plugin/
    plugin.json          # Plugin metadata
  commands/              # Your command files
    hello.md            # Command: /your-plugin:hello
    goodbye.md          # Command: /your-plugin:goodbye
  readme.md             # Plugin documentation
```

### Creating `plugin.json`

This file defines your plugin's metadata:

```json
{
  "name": "your-plugin",
  "description": "A helpful description of what your plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

### Creating Commands

Commands are markdown files in the `commands/` directory. Each file becomes a command:

**Example: `commands/hello.md`**

```markdown
# Command Description
Brief description of what this command does.

## Allowed Tools
- Bash
- Read
- Write

## Instructions
Detailed instructions for Claude Code to follow when this command is executed.

You can include:
- Step-by-step workflows
- Best practices
- Expected outputs
- Error handling

The command will be available as: /your-plugin:hello
```

### Command File Naming

- `feature.md` → `/your-plugin:feature`
- `feature.continue.md` → `/your-plugin:feature.continue`
- `setup.md` → `/your-plugin:setup`

### Tool Permissions

Each command must specify which Claude Code tools it's allowed to use:

**Available Tools:**
- `Bash` - Run shell commands
- `Read` - Read files
- `Write` - Create new files
- `Edit` - Modify existing files
- `Glob` - Find files by pattern
- `Grep` - Search file contents
- `TodoWrite` - Manage todo lists
- `Task` - Launch specialized agents
- `WebFetch` - Fetch web content
- `WebSearch` - Search the web

Only include tools your command actually needs!

### Adding Your Plugin to the Marketplace

1. Create your plugin directory in the marketplace
2. Update `/.claude-plugin/marketplace.json`:

```json
{
  "name": "claude-code-marketplace",
  "owner": {
    "name": "Savvy AI"
  },
  "plugins": [
    {
      "name": "pro",
      "source": "./pro"
    },
    {
      "name": "your-plugin",
      "source": "./your-plugin"
    }
  ]
}
```

3. Test your plugin thoroughly
4. Submit a pull request!

## Technical Reference

### marketplace.json Format

The root marketplace configuration file:

```json
{
  "name": "claude-code-marketplace",
  "owner": {
    "name": "Organization or Owner Name"
  },
  "plugins": [
    {
      "name": "plugin-identifier",
      "source": "./path-to-plugin"
    }
  ]
}
```

### plugin.json Format

Each plugin's metadata file:

```json
{
  "name": "plugin-name",
  "description": "What your plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Author Name"
  }
}
```

**Fields:**
- `name` - Unique plugin identifier (used in commands)
- `description` - Brief description of plugin purpose
- `version` - Semantic version number
- `author.name` - Plugin author's name

### Command Markdown Structure

Commands use a standardized markdown format:

```markdown
# Brief Title

Description of what the command does.

## Allowed Tools
- Tool1
- Tool2

## Full Instructions

Detailed instructions for Claude Code...
```

## Contributing

We love contributions! Here's how you can help:

### Submitting a Plugin

1. **Fork this repository**
2. **Create your plugin** following the structure above
3. **Test thoroughly** - Make sure all commands work as expected
4. **Document well** - Write a clear README for your plugin
5. **Submit a PR** - Include examples and use cases

### Plugin Guidelines

- Use clear, descriptive command names
- Include helpful examples in your README
- Specify only the tools you need
- Test with various inputs and edge cases
- Follow semantic versioning
- Write user-friendly documentation

### Getting Help

- Check existing plugins for examples
- Open an issue for questions
- Report bugs with detailed reproduction steps

## License

This marketplace and its plugins are provided as-is. Individual plugins may have their own licenses - check each plugin's directory for details.

## Credits

**Maintained by:** Savvy AI
**Contributors:** Plugin authors and community members

---

Ready to boost your productivity? Pick a plugin and start coding smarter!
