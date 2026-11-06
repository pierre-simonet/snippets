---
name: memory-skip-task
description: Use when the user wants to skip or cancel a specific pending task on the active plan without doing it (e.g. "skip task 3", "we don't need that last bullet", "drop the migration step"). Marks it cancelled, not done. Companion to memory-plan (create/execute), memory-plan-status (view), memory-resume (resume in fresh session).
---

# Memory Skip Task (Obsidian)

Marks one pending task on the active plan as **skipped** — distinct from
done. Never use `- [x]` for a skipped task.

## 1. Locate the plan file

Follow the lookup table in
`~/.claude/skills/memory-plan/references/plan-conventions.md`. If ambiguous,
ask which plan.

## 2. Identify the target task

Match by position (task number as the user said it) or by text similarity
against the pending (`- [ ]`) bullets. Bullets under `## Tasks — Phase N`
count too — the user can skip a not-yet-active one. If the match is unclear,
show the candidates and ask.

If the task is already `[x]` or `[-]`: tell the user, don't touch it.

## 3. Mark it skipped

`mcp__obsidian__patch_note`, replacing:

```
- [ ] <task text>
```

with:

```
- [-] <task text> (skipped: <reason if the user gave one>)
```

Omit the `(skipped: ...)` suffix if no reason was given.

Per the patching rules in `references/plan-conventions.md`: never
`replaceAll: true` here. If the patch fails on a multi-match, re-read the note,
widen `oldString` with the neighbouring line, retry once.

Then `mcp__obsidian__update_frontmatter` → `updated: <today>`. If this skip
means every bullet in every Tasks section is now `[x]` or `[-]`, also set
`status: done` and say the plan is complete.

## 4. Confirm

Tell the user which exact task got skipped.
