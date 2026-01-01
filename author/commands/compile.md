## Context

Compile manuscript to publishing targets.

## Purpose

Generate publishable artifacts for web and print distribution.

**US-006:** Given valid manifests, when `/author:compile` is invoked, then SpecMD output is generated.

**US-007:** Given valid content, when LaTeX target is selected, then a print-ready PDF artifact is produced.

## Arguments

- `<target>` - Optional: "specmd", "latex", "markdown", "all"

## Examples

```
/author:compile                    # Interactive (choose target)
/author:compile specmd             # Compile to SpecMD only
/author:compile latex              # Compile to LaTeX/PDF
/author:compile all                # Compile all targets
```

## Your Task

### Step 1: Verify Project Exists

```bash
test -f book/book.json && echo "exists" || echo "missing"
```

If missing:
- Display: "No book project found. Run `/author:init` first."
- Exit

### Step 2: Validate Manuscript

Before compiling, verify:

1. At least one chapter exists
2. All referenced chapters have content
3. Front matter exists (title page at minimum)

If validation fails:
```
[ writer:compile ]
------------------
✗ Validation failed

Issues:
- No chapters found in book/chapters/
- Missing title page in front-matter/

Fix these issues and try again.
```

### Step 3: Select Target

If target not specified, use `AskUserQuestion`:

```
question: "Which compilation target?"
header: "Target"
options:
  - "SpecMD (Recommended)" (single bundled Markdown for web)
  - "LaTeX" (PDF for print publishing)
  - "Markdown Bundle" (directory of linked files)
  - "All targets" (compile everything)
```

### Step 4: Read Manifest and Content

1. Read `book/book.json` for structure
2. Load all content in order:
   - Front matter (title, dedication, preface)
   - Chapters (by number)
   - Back matter (appendix, bibliography)

### Step 5A: Compile to SpecMD

SpecMD is a single bundled Markdown file optimized for web publishing.

**Output:** `book/dist/specmd/book.md`

**Format:**
```markdown
---
title: "<Book Title>"
author: "<Author Name>"
version: "<Version>"
compiled: "<ISO timestamp>"
---

# <Book Title>

By <Author Name>

---

## Table of Contents

- [Preface](#preface)
- [Chapter 1: Introduction](#chapter-1-introduction)
- [Chapter 2: ...](#chapter-2-...)
...

---

# Preface

[Preface content]

---

# Chapter 1: Introduction

[Chapter content with internal links preserved]

---

# Chapter 2: ...

[Content continues]

---

# Appendix

[Back matter]

---

*Compiled with Writer Plugin v1.0.0*
```

**Process:**
1. Concatenate all content with section breaks
2. Convert internal links to anchor references
3. Generate table of contents
4. Add YAML frontmatter
5. Write to dist/specmd/book.md

### Step 5B: Compile to LaTeX

LaTeX compilation produces print-ready PDF.

**Output:**
- `book/dist/latex/book.tex` (LaTeX source)
- `book/dist/latex/book.pdf` (compiled PDF, if pdflatex available)

**LaTeX Template:**
```latex
\documentclass[12pt,a4paper]{book}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=1in}

\title{<Book Title>}
\author{<Author Name>}
\date{}

\begin{document}

\maketitle
\tableofcontents

\chapter*{Preface}
\addcontentsline{toc}{chapter}{Preface}
[Converted preface content]

\chapter{Introduction}
[Converted chapter content]

\chapter{...}
[Content continues]

\appendix
\chapter{Appendix}
[Back matter]

\end{document}
```

**Markdown to LaTeX Conversion:**

| Markdown | LaTeX |
|----------|-------|
| `# Heading` | `\chapter{Heading}` |
| `## Subheading` | `\section{Subheading}` |
| `**bold**` | `\textbf{bold}` |
| `*italic*` | `\textit{italic}` |
| `- list item` | `\item list item` |
| `[link](url)` | `\href{url}{link}` |
| `![image](path)` | `\includegraphics{path}` |
| `> quote` | `\begin{quote}...\end{quote}` |
| `` `code` `` | `\texttt{code}` |

**Process:**
1. Create `book/dist/latex/` directory if it doesn't exist
2. Convert all Markdown content to LaTeX using the conversion table above
3. Generate the LaTeX document using the template structure
4. Write LaTeX source to `book/dist/latex/book.tex`
5. Check if pdflatex is available:
   ```bash
   which pdflatex >/dev/null 2>&1 && echo "available" || echo "missing"
   ```
6. **If pdflatex is available:** Execute PDF compilation:
   ```bash
   cd book/dist/latex && pdflatex -interaction=nonstopmode book.tex
   ```
   - Run pdflatex twice if document has table of contents (for proper TOC generation)
   - Report: `✔ book/dist/latex/book.pdf` in output summary
7. **If pdflatex is NOT available:** Report fallback message:
   ```
   ✔ LaTeX source generated: book/dist/latex/book.tex

   ⚠ pdflatex not found. To generate PDF:
     1. Install TeX distribution (MacTeX, TeX Live, MiKTeX)
     2. Run: cd book/dist/latex && pdflatex book.tex
   ```

**IMPORTANT:** The PDF is the primary deliverable for the LaTeX target. LaTeX source (.tex) is an intermediate format, not a final output. Always attempt PDF generation when pdflatex is available.

### Step 5C: Compile to Markdown Bundle

Markdown bundle is a directory of linked files for documentation sites.

**Output:** `book/dist/markdown/`

**Structure:**
```
book/dist/markdown/
├── index.md           # Table of contents with links
├── 00-preface.md      # Linked preface
├── 01-introduction.md # Linked chapter
├── 02-...md           # More chapters
└── appendix.md        # Back matter
```

**Index file:**
```markdown
# <Book Title>

By <Author Name>

## Contents

1. [Preface](./00-preface.md)
2. [Introduction](./01-introduction.md)
3. [...](./02-....md)

---

*Compiled with Writer Plugin v1.0.0*
```

Each chapter file includes:
- Navigation links (previous/next)
- Back to index link

### Step 6: Display Summary

Show only the outputs that were actually generated. For LaTeX target:
- Show `book.pdf` line only if PDF was successfully generated
- Show `book.tex` line only if pdflatex was unavailable (fallback case)
- Never show both .tex and .pdf in outputs (PDF supersedes .tex)

```
╔════════════════════════════════════════════════════════════════╗
║  COMPILATION COMPLETE                                           ║
╠════════════════════════════════════════════════════════════════╣
║                                                                 ║
║  Book: <Title>                                                  ║
║  Chapters: 12                                                   ║
║  Total words: 45,230                                            ║
║                                                                 ║
║  Outputs:                                                       ║
║  ✔ book/dist/specmd/book.md (142 KB)                            ║
║  ✔ book/dist/latex/book.pdf (1.2 MB)                            ║
║  ✔ book/dist/markdown/ (14 files)                               ║
║                                                                 ║
║  Next steps:                                                    ║
║  - Preview: open book/dist/specmd/book.md                       ║
║  - Print: open book/dist/latex/book.pdf                         ║
║                                                                 ║
╚════════════════════════════════════════════════════════════════╝
```

## Validation Rules

| Check | Severity | Action |
|-------|----------|--------|
| No chapters | Error | Block compilation |
| Empty chapter | Warning | Include placeholder |
| Missing front matter | Warning | Generate minimal |
| Broken internal links | Warning | Report but continue |
| Invalid Markdown | Error | Report location |

## Edge Cases

- **No pdflatex:** Generate .tex only, provide instructions
- **Large manuscript:** Show progress indicator
- **Images referenced:** Copy to dist directories
- **Special characters:** Escape for LaTeX target
- **Code blocks:** Use appropriate formatting per target
