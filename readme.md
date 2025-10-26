# Claude Code Marketplace

A curated collection of plugins that extend Claude Code with powerful development workflows.

## Installation

Clone this repository to start using marketplace plugins:

```bash
git clone git@github.com:SavvyAI/claude-code-marketplace.git
cd claude-code-marketplace
```

That's it! Plugins are automatically available in Claude Code.

## Available Plugins

### [Pro](./pro/readme.md)
Professional development workflows with intelligent planning and automation.

**Commands:** `/pro:feature` · `/pro:continue` · `/pro:gaps` · `/pro:refactor` · `/pro:pr` · `/pro:pr.resolve` · `/pro:pr.merged`

[View Pro documentation →](./pro/readme.md)

## Usage

Plugin commands follow this pattern:

```bash
/plugin-name:command-name [arguments]
```

**Examples:**
```bash
/pro:feature "add user authentication"
/pro:pr
```

See individual plugin READMEs for detailed command documentation.

## Contributing

Want to add a plugin or improve existing ones?

1. Fork this repository
2. Create your plugin following the [plugin structure](./pro/.claude-plugin/plugin.json)
3. Add your plugin to `/.claude-plugin/marketplace.json`
4. Test thoroughly
5. Submit a pull request

**Plugin Structure:**
```
your-plugin/
  .claude-plugin/
    plugin.json       # Metadata
  commands/           # Command .md files
  readme.md          # Documentation
```

For detailed examples, see the [Pro plugin source](./pro/).

## License

Provided as-is. Individual plugins may have their own licenses.

---

**Maintained by:** Savvy AI
