# ccplugins

[![GitHub stars](https://img.shields.io/github/stars/SavvyAI/ccplugins?style=flat-square)](https://github.com/SavvyAI/ccplugins/stargazers)
[![License](https://img.shields.io/github/license/SavvyAI/ccplugins?style=flat-square)](https://github.com/SavvyAI/ccplugins/blob/main/LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet?style=flat-square)](https://docs.anthropic.com/en/docs/claude-code)

Plugins that extend Claude Code with powerful development workflows.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [Pro](./pro/readme.md) | Professional development workflows with planning, branch management, and PR automation |

## Installation

```bash
# Clone the repository
git clone https://github.com/SavvyAI/ccplugins.git
cd ccplugins

# Add the marketplace
claude plugin marketplace add .

# Install a plugin (e.g., pro)
claude plugin install pro@ccplugins

# Restart Claude Code to load the plugin
```

## Contributing

1. Fork this repository
2. Create your plugin directory with a `commands/` folder
3. Add `.md` command files
4. Submit a pull request

---

Maintained by [Savvy AI](https://github.com/SavvyAI)
