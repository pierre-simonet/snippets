# Plan conventions (shared)

Single source of truth for plan **lookup**, the `status:` **lifecycle**, and
**patching** rules. Read by `memory-plan`, `memory-plan-status`,
`memory-resume`, `memory-skip-task` — do not duplicate these rules in those
skills.

## 1. Lookup

Resolve the ticket-or-slug, then find the note.

**Ticket:**

1. `git rev-parse --abbrev-ref HEAD`, match case-insensitively `^([a-z][a-z0-9]*-\d+)`,
   uppercase it (`proj-916-foo` → `PROJ-916`).
2. Fallback order: Jira URL in the conversation → explicit user mention → ask
   the user for a short slug.

**Note:**

```
mcp__obsidian__list_directory("Work")
```

Match case-insensitively against every filename, in this order:

| What you find | Meaning | Action |
|---|---|---|
| `<TICKET-or-slug> - Plan.md` | the plan note | use it |
| filename *starts with* the ticket-or-slug but has no `- Plan` suffix (e.g. `PROJ-837 - Checkout redesign.md`) | a pre-existing note about the same ticket — probably human-written | **do not silently create a second note.** Show the filename to the user and ask: adopt it as the plan, or create `<TICKET> - Plan.md` alongside it |
| more than one plausible match | ambiguous | list candidates, ask which |
| nothing | no plan yet | caller decides: `memory-plan` creates one; `memory-plan-status` / `memory-resume` / `memory-skip-task` say so and stop |

## 2. `status:` lifecycle

```
draft  →  awaiting-approval  →  approved  →  done
```

- `draft` — knowingly incomplete; written mid-drafting, not yet shown.
- `awaiting-approval` — full plan written and shown to the user; **not
  executable**.
- `approved` — user gave explicit approval and all Open Questions are
  resolved. Only state in which tasks may be executed.
- `done` — every bullet in every `## Tasks` / `## Tasks — Phase N` section is
  `[x]` or `[-]`.

Any skill about to execute a task MUST check `status == approved` first. If it
is `draft` or `awaiting-approval`: stop, show the plan, ask for approval.

Flip status with `mcp__obsidian__update_frontmatter` (not `patch_note` — YAML
string-replacement is fragile). Bump `updated: <today>` in the same call on
every write to the note.

## 3. Patching rules

- Content edits: `mcp__obsidian__patch_note`.
- Frontmatter: `mcp__obsidian__update_frontmatter`.
- Never touch the checkbox state of items you were not asked to change.
- Never delete `[x]` or `[-]` bullets — they are the history.
- **Never** pass `replaceAll: true` on a checkbox line.

`patch_note` with `replaceAll: false` hard-fails when `oldString` matches more
than once (e.g. two bullets both reading `- [ ] Add tests`). On failure:

1. `mcp__obsidian__read_note(path)`.
2. Rebuild `oldString` with the preceding and/or following line included so it
   is unique.
3. Retry once. If it still fails, show the user the ambiguous lines and ask.
