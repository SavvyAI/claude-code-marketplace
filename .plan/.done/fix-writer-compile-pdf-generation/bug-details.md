# Bug: Writer compile command not generating PDF

## Bug ID
41

## Summary
The `/writer:compile` command generates LaTeX `.tex` files but does not automatically compile them to PDF via pdflatex, even when pdflatex is installed.

## Steps to Reproduce
1. Run `/writer:compile all` on a book project
2. Compilation completes, outputs SpecMD, LaTeX, and Markdown Bundle

## Expected Behavior
- PDF generated at `book/dist/latex/book.pdf` via automatic pdflatex execution
- User Story US-007 states: "a print-ready PDF artifact is produced"

## Actual Behavior
- Only `.tex` file generated at `book/dist/latex/book.tex`
- Message says "Ready for PDF compilation with pdflatex" implying manual step needed
- LaTeX treated as final output instead of intermediate format

## Environment
- macOS Darwin 25.1.0
- pdflatex installed: `/opt/homebrew/bin/pdflatex`
- TeX Live 2025 (via Homebrew)
- Branch: main (before fix)

## Severity
**High** - Degraded experience. Workaround exists (manual pdflatex) but violates specification.

## Root Cause Analysis

The Writer plugin uses specification-based commands (markdown files in `writer/commands/`). The specification at `writer/commands/compile.md` clearly defines PDF compilation:

### Specification (compile.md lines 202-220):
```markdown
**PDF Compilation:**
```bash
# Check if pdflatex is available
which pdflatex >/dev/null 2>&1 && echo "available" || echo "missing"

# If available, compile
cd book/dist/latex && pdflatex -interaction=nonstopmode book.tex
```

If pdflatex not available:
```
[ writer:compile ]
------------------
✔ LaTeX source generated: book/dist/latex/book.tex

⚠ pdflatex not found. To generate PDF:
  1. Install TeX distribution (MacTeX, TeX Live, MiKTeX)
  2. Run: cd book/dist/latex && pdflatex book.tex
```
```

### Actual Issue:
The specification is **incomplete** in Step 5B. It only shows:
1. The LaTeX template
2. The conversion rules
3. The pdflatex check/compile commands

But it **does not explicitly instruct** Claude to:
1. First generate the `.tex` file
2. Then check for pdflatex
3. Then run pdflatex to generate PDF
4. Report appropriate success/fallback message

The specification shows the bash commands but doesn't clearly state "After generating book.tex, execute these commands to produce the PDF."

## Fix Strategy

Modify `writer/commands/compile.md` Step 5B to:
1. Make the PDF compilation step explicit and mandatory (not optional)
2. Clearly separate "Generate LaTeX source" from "Compile to PDF"
3. Add clear process steps that Claude must follow
4. Ensure the output summary lists book.pdf when generated

## Related ADRs
- ADR 023: Writer Plugin Multi-Plugin Architecture
- No ADR for PDF generation specifically

## Related Backlog Items
- US-007: Compile to LaTeX (status: resolved, but incompletely implemented)

---

## Fix Applied

### Root Cause
The specification in `writer/commands/compile.md` Step 5B was missing a clear **Process:** section. While it showed the pdflatex commands, it didn't explicitly instruct Claude to execute them. Step 5A (SpecMD) had a clear process flow, but Step 5B (LaTeX) did not.

### Changes Made

**File:** `writer/commands/compile.md`

1. **Added explicit Process section to Step 5B** (lines 202-226):
   - Step 1: Create output directory
   - Step 2: Convert Markdown to LaTeX
   - Step 3: Generate LaTeX document
   - Step 4: Write .tex file
   - Step 5: Check pdflatex availability
   - Step 6: If available, execute pdflatex (run twice for TOC)
   - Step 7: If not available, show fallback message
   - Added IMPORTANT note: PDF is primary deliverable, .tex is intermediate

2. **Updated Step 6 Display Summary** (lines 265-270):
   - Added guidance: Show .pdf only if generated, .tex only as fallback
   - Clarified: Never show both .tex and .pdf (PDF supersedes .tex)
   - Removed .tex from example output (PDF is the expected output)

### Verification Required
Run `/writer:compile all` or `/writer:compile latex` on a book project. Expected:
- pdflatex should be detected as available
- PDF should be generated at `book/dist/latex/book.pdf`
- Summary should show `✔ book/dist/latex/book.pdf` (not .tex)
