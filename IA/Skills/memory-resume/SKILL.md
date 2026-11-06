---
name: memory-resume
description: Use at the start of a session to resume work on an existing plan — e.g. "resume the plan", "continue PROJ-123", "pick up where we left off". Loads the plan's Goal, Context, and remaining tasks from Obsidian vault folder "Work" so a session with zero prior context can continue it. Companion to memory-plan (create/execute), memory-plan-status (view), memory-skip-task (skip).
---

# Memory Resume (Obsidian)

Loads an existing plan into a session that has no memory of it — this may be
a brand new Claude Code session.

## 1. Locate the plan file

Follow the lookup table in
`~/.claude/skills/memory-plan/references/plan-conventions.md`. If no ticket can
be resolved, list `Work/` and look for `* - Plan.md` files.

If none found: say so — this skill does not create plans (`memory-plan`
does).

## 2. Load it

`mcp__obsidian__read_note(path)`. Surface to the session:

- **`status:`** — check it first, before anything else. See step 3.
- **Goal** — the objective, verbatim.
- **Context** (and **Decisions**, if present) — repo path, branch/worktree,
  key files, prior decisions. Before acting on any of it, spot-check that it
  still holds (files still exist, branch/worktree still there) — context notes
  are a snapshot from whenever the plan was written, not live state. Compare
  `updated:` against how stale that snapshot might be.
- **Pending tasks** (`- [ ]`) under the plain `## Tasks` heading, in order —
  this is the actual work left. Bullets under `## Tasks — Phase N` are **not
  in scope** until `## Tasks` is fully cleared; mention they exist, nothing
  more.
- **Skipped tasks** (`- [-]`) — mention briefly so they aren't redone.
- **Done tasks** (`- [x]`) — mention briefly, for orientation. Their
  `→ <branch>@<sha>` suffixes tell you what already landed and where; check
  those commits/branches exist before building on them.
- **`## Log`**, if present — deviations and follow-ups from earlier tasks.

## 3. Confirm and continue

**Gate on `status:`** (lifecycle in `references/plan-conventions.md`):

- `approved` → proceed.
- `awaiting-approval` or `draft` → **do not execute anything.** Show the plan
  (and any unresolved `## Open Questions`), and ask the user to approve it.
  Approval, question-resolution, and the flip to `status: approved` are
  `memory-plan`'s step 2 — hand off there.
- `done` → say so; ask whether the user wants a new plan instead.

Once approved: ask which pending task to start next (default: the first
pending one under `## Tasks`). From there, follow `memory-plan`'s step 4 —
scoped Context-plus-one-task prompt, sequential unless the bullet is tagged
`(par)`, a code-review subagent on the diff, and hold the checkbox until the user
confirms the review passed.
