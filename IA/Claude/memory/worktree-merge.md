---
name: worktree-merge
description: After completing work in a worktree, merge into the target branch decided at the start; the user pushes
metadata:
  type: feedback
---

After completing work in a worktree, always merge the worktree branch into the target branch decided at the start of the task (e.g., the user's current feature branch or the default branch).

**Why:** Work done in a worktree lands on a separate branch that isn't visible on the remote under the expected branch. The user wants to see the work on the intended branch, not on the ephemeral worktree branch.

**How to apply:** Before starting work in a worktree, confirm which branch the result should be merged into. After finishing, merge the worktree branch into that target branch. Never push: the user pushes ([[no-remote-writes]]).
