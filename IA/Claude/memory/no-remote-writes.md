---
name: no-remote-writes
description: Never post GitLab/GitHub comments or git push; draft and wait for explicit approval
metadata:
  type: feedback
---

Never post comments on GitLab/GitHub (MR/PR notes, issue comments, etc.) and never push to git without explicit instruction.

**Why:** A reply was once posted on an MR without permission. These are irreversible actions visible to others.

**How to apply:** Always stop before `glab api --method POST` (discussions, notes), `glab mr note`, `gh pr comment`, `git push`, or any equivalent. Draft the content and ask the user to confirm before executing. Even when "proposing" a reply, only show the text — do not post it.
