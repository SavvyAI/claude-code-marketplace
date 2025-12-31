# Contributing

## Getting Started

```bash
# Clone the repository
git clone https://github.com/SavvyAI/ccplugins.git
cd ccplugins

# Add your local clone as a marketplace
/plugin marketplace add .

# Install a plugin to test
/plugin install pro@ccplugins
```

## Creating a Plugin

1. Create your plugin directory with a `commands/` folder
2. Add `.md` command files (see existing plugins for examples)
3. Add a `.claude-plugin/plugin.json` manifest
4. Submit a pull request

## Plugin Structure

```
your-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── your-command.md
└── readme.md
```
