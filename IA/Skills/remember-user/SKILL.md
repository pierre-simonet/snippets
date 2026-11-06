---
name: remember-user
description: Record a personal, cross-project preference in the user's own instruction file (~/.claude/CLAUDE.md). Use when the user says "#remember-user", "remember this about me", "always do X from now on", or "add this to my global instructions". Private to this machine — never touches a repo file. For a convention the whole team should follow, use `remember-project`; for a fact to recall rather than an instruction to obey, use the auto-memory directory.
---

# Remember (user level)

Appends a standing preference to `~/.claude/CLAUDE.md` — the user's own
instructions, loaded in every project, on this machine only. Nothing here reaches
a repo or a teammate.

## 1. Decide whether it belongs here at all

| The thing to remember | Goes to |
|---|---|
| How the user wants Claude to behave, across repos | this skill → `~/.claude/CLAUDE.md` |
| A convention every agent in one repo must follow | `remember-project` |
| A fact, decision, or context to recall — not an instruction to obey | the auto-memory dir (`~/.claude/projects/<slug>/memory/` + `MEMORY.md`) |
| An automated behaviour ("whenever X happens, do Y") | a **hook** in `settings.json` — instructions can't fire on events. Load the `update-config` skill |
| A permission, env var, or model setting | `settings.json` — `update-config` skill, not this file |

Rule of thumb: an **imperative preference** the user states about their own
workflow → here. An **observation about the user or the work** → memory dir. A
**mechanical trigger** → hook.

Say which one you picked and why, in one line, before writing.

## 2. Check it isn't already covered

`~/.claude/CLAUDE.md` is organised into `##` sections.

```bash
grep -n "^##" ~/.claude/CLAUDE.md          # current sections
grep -rni "<key term>" ~/.claude/CLAUDE.md
grep -rni "<key term>" ~/.claude/projects/*/memory/ 2>/dev/null
```

Check the memory dir too — the same preference living in both places means one
copy silently goes stale.

- Already covered → say so, propose sharpening the existing line instead of adding
  a near-duplicate.
- Contradicts an existing rule → stop, show both, let the user choose. Two
  opposing rules in an always-loaded file are worse than neither.

## 3. Write it

- Append **under the existing `##` section it belongs to**, not at the end of the
  file. New section only when nothing fits.
- Imperative and specific: "After any refactor, run `./gradlew compileKotlin`"
  beats "be careful with refactors".
- One rule per bullet. Include the *why* when it isn't self-evident.
- Keep it short — this file is loaded on every single turn in every project. Long
  entries cost context forever.
- Never write Windows-style paths or Copilot targets; the file is
  `~/.claude/CLAUDE.md` on this machine.

## 4. Confirm

Show the added lines and which section they went under. No approval gate needed —
it's the user's own private file and they asked for it — but never rewrite or
reorder unrelated content while you're in there, and never `git`-anything: this
file is outside any repo.
