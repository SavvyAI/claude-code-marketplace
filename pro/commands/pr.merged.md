---
description: "PR successfully merged? → Cleans up planning artifacts and branches → Completes the development cycle"
allowed-tools: ["Bash"]
---

The pull request: $ARGUMENTS was successfully merged and closed...

### Your Task
- [ ] Clear the conversation
- [ ] Switch to the main branch

!git fetch origin main && git checkout main && git pull origin main
