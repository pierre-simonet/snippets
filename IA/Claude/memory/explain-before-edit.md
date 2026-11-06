---
name: explain-before-edit
description: Before editing any file, explain root cause and proposed fix, then wait for explicit user OK
metadata:
  type: feedback
---

Before making any code changes: explain the root cause and the proposed fix, then wait for the user to approve before applying anything.

**Why:** User explicitly requested this workflow — avoids wasted edits and gives user control over approach before code is touched.

**How to apply:** On any task involving file edits — bug fixes, refactors, CI fixes, renames — state diagnosis + plan first, then pause. Plan format (user's words): list the exact file paths with app name and a one-line change for each, then wait for OK. Scope: only the element the user named; never extend the change to similar components unless told.

Related: [[no-confirmation]] (no approval prompts mid-task for already-approved changes — this rule governs the *initial* approval gate).
