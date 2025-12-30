# Writer Plugin

Markdown-native authoring and publishing for long-form writing workflows.

## Overview

Writer is a Claude Code plugin for authors who want to write books, essays, and guides using Markdown as their single source of truth. It prioritizes voice-first input, incremental drafting, and Git-based version control.

## Design Principles

1. **Markdown as single source of truth** - No proprietary formats
2. **Voice-first interaction** - Natural language over rigid syntax
3. **Write once, compile many** - Web, print, and documentation targets
4. **Low ceremony, repo-first** - Git-native workflows
5. **No runtime state** - Everything persists in the repository

## Commands

| Command | Purpose |
|---------|---------|
| `/writer:init` | Initialize a new book project |
| `/writer:chapter` | Create or edit chapters |
| `/writer:revise` | Revision operations (clarity, tone) |
| `/writer:compile` | Compile to publishing targets |

## Quick Start

```bash
# Initialize a book project
/writer:init

# Add a chapter
/writer:chapter "Introduction"

# Revise for clarity
/writer:revise 01 --clarity

# Compile to all targets
/writer:compile all
```

## Book Project Structure

```
book/
├── book.json              # Book manifest
├── chapters/              # Chapter Markdown files
│   ├── 00-preface.md
│   ├── 01-introduction.md
│   └── ...
├── front-matter/          # Title, dedication, preface
├── back-matter/           # Appendix, bibliography
└── dist/                  # Compiled outputs
    ├── specmd/            # Bundled Markdown
    ├── latex/             # LaTeX/PDF
    └── markdown/          # Linked files
```

## Compilation Targets

| Target | Output | Use Case |
|--------|--------|----------|
| SpecMD | Single bundled Markdown | Web publishing |
| LaTeX | PDF via LaTeX | Print publishing |
| Markdown Bundle | Directory of linked files | Documentation sites |

## Anti-Features

Writer intentionally does NOT include:

- WYSIWYG editor
- CMS dashboards
- Proprietary file formats
- Direct publishing or uploading
- Account management or cloud sync

## Requirements

- Claude Code CLI
- Git (for version control)
- pdflatex (optional, for PDF output)

## Version

1.0.0

## Author

Wil Moore III
