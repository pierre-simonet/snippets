---
name: memory-plan-status
description: Use when the user asks what's left on the plan, wants a progress report, or asks how far along a tracked feature is (e.g. "plan status", "what's done", "show progress on PROJ-123"). Read-only — reads the plan note in Obsidian vault folder "Work". Companion to memory-plan (create/execute), memory-skip-task (skip), memory-resume (resume in fresh session).
---

# Memory Plan Status (Obsidian)

Read-only report of a plan's progress. Never creates or modifies the note —
that's `memory-plan`'s job.

## 1. Locate the plan file

Follow the lookup table in
`~/.claude/skills/memory-plan/references/plan-conventions.md`.

If none found: say so, stop — do not offer to create one (that's
`memory-plan`).

## 2. Read and parse

`mcp__obsidian__read_note(path)`. Note the frontmatter `status:` and
`updated:`. Then walk every `## Tasks` (and `## Tasks — Phase N`) section and
classify each bullet:

- `- [x] ...` → done (the `→ <branch>@<sha>` suffix, if present, is the audit
  trail — carry it into the report)
- `- [-] ...` → skipped
- `- [ ] ...` → pending

## 3. Report

Terse, grouped:

```
<file name> — status: <status>, updated <date>
<done>/<total> done, <skipped> skipped, <pending> pending

Done:
  ✅ <task> (<branch>@<sha>)
Skipped:
  ⏭️ <task> (reason if present)
Pending:
  ◻️ <task>
```

Call out the frontmatter state when it blocks work: `awaiting-approval` or
`draft` means nothing is executable yet, whatever the checkboxes say.

If a `## Open Questions` section is still present, list it — those block
approval.

If there's a `## Tasks — Phase 2` (etc.) section, report it separately and
note whether phase 1 is fully cleared yet (phase 2 bullets are out of scope
until it is).

If a `## Log` section exists, surface any entries relevant to what's left.
