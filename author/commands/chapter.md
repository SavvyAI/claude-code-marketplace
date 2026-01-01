## Context

Create or edit chapters in a book project.

## Purpose

Add new chapters or modify existing chapters using voice-first prompts.

**US-002:** Given an initialized project, when `/author:chapter` is invoked with a title, then a new Markdown file is created in `/chapters`.

**US-003:** Given an existing chapter, when append or revise mode is selected, then content is updated without deleting unrelated sections.

## Arguments

- `<title or chapter reference>` - Chapter title (new) or number/slug (existing)

## Examples

```
/author:chapter "The Journey Begins"        # Create new chapter
/author:chapter 01                          # Edit chapter 01
/author:chapter introduction                # Edit by slug
/author:chapter                             # Interactive mode
```

## Your Task

### Step 1: Verify Project Exists

```bash
test -f book/book.json && echo "exists" || echo "missing"
```

If missing:
- Display: "No book project found. Run `/author:init` first."
- Exit

### Step 2: Determine Mode

Parse the argument to determine:

| Input | Mode | Action |
|-------|------|--------|
| No argument | Interactive | Show chapter list, ask what to do |
| Quoted string | Create | Create new chapter with title |
| Number (01, 1, etc) | Edit | Open existing chapter by number |
| Slug text | Edit | Open existing chapter by slug |

### Step 3A: Create New Chapter

If creating a new chapter:

1. Read `book/book.json` to get current chapters
2. Determine next chapter number:
   ```bash
   ls book/chapters/*.md 2>/dev/null | wc -l
   ```
3. Generate filename: `{NN}-{slugified-title}.md`
4. Write chapter file:

```markdown
# <Chapter Title>

[Begin writing your chapter here. Use natural voice input or type directly.]
```

5. Update `book/book.json`:
   - Add to `chapters` array: `{ "number": NN, "title": "...", "file": "..." }`

6. Display confirmation:
```
[ author:chapter ]
------------------
Created: book/chapters/{NN}-{slug}.md
Title: <Chapter Title>

The chapter is ready for content. Use voice input or type directly.
```

### Step 3B: Edit Existing Chapter (Interactive)

If editing an existing chapter:

1. Read the chapter file
2. Display current content summary (first 200 chars)
3. Use `AskUserQuestion`:

```
question: "What would you like to do with this chapter?"
header: "Edit mode"
options:
  - "Append content" (add to the end)
  - "Revise section" (edit specific part)
  - "Rewrite chapter" (replace all content)
  - "View full content" (just display)
```

### Step 4: Append Mode

If appending:

1. Use `AskUserQuestion`:
```
question: "What content should I add to this chapter?"
header: "Content"
freeform: true
```

2. Append content to chapter file (preserve existing content)
3. Display:
```
[ author:chapter ]
------------------
Title: <Chapter Title>
Mode: Append

✔ Content appended successfully
Word count: {new total}
```

### Step 5: Revise Section Mode

If revising a section:

1. Display chapter with section markers
2. Use `AskUserQuestion`:
```
question: "Which section should I revise?"
header: "Section"
options: [list of H2/H3 headings in chapter]
```

3. Display selected section
4. Ask for revision instructions:
```
question: "How should I revise this section?"
header: "Instructions"
freeform: true
```

5. Apply revisions (preserve unrelated sections)
6. Display diff summary

## Chapter File Format

```markdown
# Chapter Title

[Main content goes here]

## Section Heading

[Section content]

## Another Section

[More content]
```

## Manifest Updates

When creating/modifying chapters, update `book/book.json`:

```json
{
  "chapters": [
    {
      "number": 1,
      "title": "Introduction",
      "file": "01-introduction.md",
      "wordCount": 1234,
      "lastModified": "2025-12-30T12:00:00Z"
    }
  ]
}
```

## Edge Cases

- **No argument, no chapters:** Guide user to create first chapter
- **Chapter not found:** Suggest similar chapters or create new
- **Filename collision:** Append suffix (-1, -2) if slug exists
- **Empty content:** Warn but allow (placeholder chapter)
