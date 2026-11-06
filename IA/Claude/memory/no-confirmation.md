---
name: no-confirmation
description: Once the file list is approved, proceed without asking for confirmation mid-task
metadata:
  type: feedback
---

Do not ask for confirmation before making code changes. Just do the work.

**Why:** User explicitly stated "do not ask me again for this kind of thing, just do it."

**How to apply:** On any coding task (renaming, refactoring, editing files, etc.), proceed directly without asking "should I continue?" or "is this okay?". Only pause for genuinely destructive/irreversible actions (force-push to main, dropping production data, etc.). Applies only after the user has OK'd the file list from [[explain-before-edit]]; never skip that initial gate.
