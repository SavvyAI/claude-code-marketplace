---
description: "Want questions on clipboard? → Retrieves recent clarifying questions → Copies as Markdown"
allowed-tools: ["Bash"]
---

## Your Task

Copy the most recent clarifying questions from this conversation to the clipboard.

### Step 1: Identify Questions

Look back through the recent conversation for clarifying questions you presented to the user. This includes:
- Questions shown in `AskUserQuestion` dialogs
- Questions asked in numbered or bulleted lists
- Any prompts seeking user input or clarification

### Step 2: Format and Copy

Format the questions as a Markdown list and copy to clipboard:

```bash
echo "## Clarifying Questions

- Question 1?
- Question 2?
- Question 3?
..." | pbcopy
```

### Step 3: Confirm

Tell the user: "Clarifying questions copied to clipboard."

If no recent clarifying questions are found, inform the user.
