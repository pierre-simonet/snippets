---
name: remember-project
description: Record a durable, team-shared convention in the current repo's agent instructions (AGENTS.md / CLAUDE.md, or a skill under .agents/skills). Use when the user says "#remember-project", "remember this for this repo", "add this to the project instructions", or "every agent working here should know X". These files are git-tracked and shared with the whole team, so this skill always shows a diff and waits for approval, and never commits. For a personal preference that shouldn't reach teammates, use `remember-user` instead.
---

# Remember (project level)

Appends a convention to the current repo's **agent instruction files**. These are
committed files other developers and their agents load — treat every edit as a
change to shared team documentation, not a private note.

## 1. Decide whether it belongs here at all

| The thing to remember | Goes to |
|---|---|
| A convention every agent working in this repo must follow | this skill → `AGENTS.md` |
| A detailed, repeatable workflow (commands, step order, gotchas) | a skill under `.agents/skills/<name>/SKILL.md`, referenced from `AGENTS.md` in one line |
| How *you personally* want Claude to behave, in any repo | `remember-user` |
| A fact, decision, or piece of context Claude should recall — not an instruction | the auto-memory dir (`~/.claude/projects/<slug>/memory/`) |
| Something already true in the code, git history, or an existing skill | nowhere — don't record it |

Rule of thumb: an **imperative rule** that must hold for everyone → project
instructions. An **observation** → memory. A **preference** → user level.

If the request is really one of the other three, say so and route it there
instead of appending to a shared file.

## 2. Find the right target file

```bash
git rev-parse --show-toplevel        # repo root
ls CLAUDE.md AGENTS.md .agents/skills 2>/dev/null
git ls-files CLAUDE.md AGENTS.md     # tracked? → shared
```

- If `CLAUDE.md` is only an `@AGENTS.md` include, do **not** write into it:
  `AGENTS.md` is the real file. If that file asks to stay short, anything longer
  than a few lines belongs in a skill (e.g. `.agents/skills/<name>/SKILL.md`)
  with a one-line pointer from `AGENTS.md`.
- Otherwise: append to `CLAUDE.md` if present, else `AGENTS.md`. If neither
  exists, ask before creating one — a new always-loaded instruction file in
  someone else's repo is a bigger decision than the note itself.
- Never `.github/copilot-instructions.md` unless that file already exists in this
  repo and no `CLAUDE.md`/`AGENTS.md` does.

## 3. Check it isn't already covered

```bash
grep -rn "<key term>" AGENTS.md CLAUDE.md .agents/skills/*/SKILL.md
```

If an existing rule covers it → say so, propose sharpening that rule in place
rather than adding a near-duplicate. If it **contradicts** an existing rule → stop
and surface the conflict; the user picks which wins. Blind appending is how these
files rot into contradiction.

## 4. Write it

- Place it under the existing `##` section it belongs to. New section only when
  nothing fits.
- Imperative, specific, verifiable. Name real paths, commands, globs.
- Include the *why* in the same breath when the rule is non-obvious — a rule
  without a reason gets ignored or reverted by the next person.
- Match the file's existing voice and density. `AGENTS.md` is terse bullets; don't
  drop three paragraphs into it.
- Don't restate anything the repo already encodes.

## 5. Show the diff, then wait

```bash
git diff -- AGENTS.md CLAUDE.md .agents/skills
```

**Show the diff and stop.** These files are tracked and shared: the user approves
the wording before it stands. Never `git add`, never `git commit`, never push —
the user commits it with their own change, or asks explicitly.

State plainly that the edit lands in a team-shared, git-tracked file, and which
one.
