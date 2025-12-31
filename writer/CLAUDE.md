# Writer Plugin Instructions

> Markdown-native authoring and publishing for long-form writing workflows.

## Design Principles

1. **Markdown as single source of truth** - All content lives in `.md` files
2. **Write once, compile many** - Single source compiles to web, print, and more
3. **Low ceremony, repo-first** - Minimal overhead, Git-native workflows
4. **No runtime state** - All state persists in the repository

## Book Project Structure

```
book/
├── book.json              # Book manifest
├── chapters/              # Chapter Markdown files
│   ├── 01-introduction.md
│   └── ...
├── front-matter/          # Title, dedication, preface
├── back-matter/           # Appendix, bibliography
└── dist/                  # Compiled outputs
```

## Commands

| Command | Purpose |
|---------|---------|
| `/writer:init` | Initialize a new book project |
| `/writer:import` | Import existing markdown content into book structure |
| `/writer:weave` | Incorporate reference material with collaborative dialogue |
| `/writer:chapter` | Create or edit chapters |
| `/writer:revise` | Revision operations (clarity, tone) |
| `/writer:compile` | Compile to publishing targets |

## Anti-Features

- No WYSIWYG editor
- No CMS dashboards
- No proprietary file formats
- No direct publishing or uploading
- No shared runtime state with Pro plugin

## Working with Chapters

Chapters are numbered Markdown files in `chapters/`:
- Filename pattern: `{NN}-{slug}.md` (e.g., `01-introduction.md`)
- Title comes from first H1 heading in file
- Order determined by numeric prefix

## Compilation Targets

| Target | Output | Use Case |
|--------|--------|----------|
| SpecMD | Single bundled Markdown | Web publishing |
| LaTeX | PDF via LaTeX | Print publishing |
| Markdown Bundle | Directory of linked files | Documentation sites |
