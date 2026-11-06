---
name: memory-plan
description: Use when starting multi-step work that should be tracked as a persisted checkbox plan — creating a new plan, updating one, or executing approved tasks one at a time via subagents. Persists to Obsidian vault folder "Work". This note is read/updated by Claude Code only, not a human-facing doc. Related tools — memory-plan-status (view progress), memory-skip-task (skip a task), memory-resume (resume a plan in a fresh session).
---

# Memory Plan (Obsidian)

A plan is a small checkbox to-do list stored in Obsidian, plus enough context that
a *fresh* Claude Code session (no prior conversation) could pick it up and finish it.

Plan lookup, the `status:` lifecycle, and patching rules are shared with the
companion skills and live in
`~/.claude/skills/memory-plan/references/plan-conventions.md`. **Read that file
before step 1.**

## 0. Get title and branch first

Before any lookup, research, or drafting: confirm you have both of these for
this feature/task, from this conversation —

1. A short **title** (feeds the note slug when there's no ticket, and the
   `## Goal` line).
2. The **git branch** to work on — existing or the name of a new one.

If either is missing, **stop and ask the user for it** — do not infer the
branch silently from `git rev-parse --abbrev-ref HEAD` and do not start step 1
until both are known. If the user's opening message already named both (e.g.
a ticket ID doubling as title, plus "on branch X"), that counts as given —
state back what you understood instead of silently assuming, but don't
re-ask.

## 1. Locate or create the plan file

Follow the lookup table in `references/plan-conventions.md`.

- `Work/<TICKET-or-slug> - Plan.md` found → this is the active plan, go to
  step 3 (update) or step 4 (execute).
- A ticket-prefixed note found that is *not* a plan note → ask the user before
  creating anything (see the lookup table).
- Nothing found → step 1a if the work spans more than one domain, else step 2.

## 1a. Research fan-out (multi-domain plans only)

Skip this for small/single-domain work — go straight to step 2. Use it when
the task visibly spans multiple concerns (e.g. API contract + backend +
frontend + tests).

1. Identify the concerns in play (typical set: contract/OpenAPI, backend,
   frontend, tests/coverage — adjust to what the ticket actually touches).
   **Cap at 4 agents**; merge concerns to fit rather than adding a fifth.
2. Launch one `Explore` agent per concern **in parallel** (single message,
   multiple tool calls). Each agent's brief must state: **read-only — do not
   edit, create, move, or delete any file, and do not run commands that
   mutate the tree.** Its job: find what changes, and **cite real file paths
   and line numbers** — no guesses, no invented paths.
3. Once all report back, synthesize before drafting the plan:
   - Tag each resulting task **S/M/L** effort.
   - Note any **contradiction** between what the ticket asks for and what the
     code actually does/contains.
   - Draft **3-5 decision questions** the user must answer before any code
     gets written (ambiguities, conflicting approaches, missing info).

Carry the effort tags, contradictions, and decision questions into step 2's
template.

## 2. Create a new plan

Write it with `mcp__obsidian__write_note` to `Work/<TICKET-or-slug> - Plan.md`.

```markdown
---
status: awaiting-approval
created: <today>
updated: <today>
ticket: <PROJ-123 or none>
---

## Goal

<1-2 sentence objective>

## Context

<everything a new session needs to resume cold: repo path, branch/worktree,
key files/packages, decisions already made, constraints, links. Terse bullets.
If step 1a ran, include the contradictions found (ticket vs actual code).>

## Open Questions

<only if step 1a ran, or ambiguity surfaced otherwise: 3-5 decision questions
blocking start. Delete this section if there are none.>

- <question 1>

## Tasks

- [ ] (S) <small task 1>
- [ ] (M) <small task 2> — done when: <e.g. tests green + coverage ≥80% on touched classes>
- [ ] (S) (par) <small task 3>
```

Use `status: draft` only if you are saving a knowingly incomplete plan;
a plan you are about to show the user is written as `awaiting-approval`.

Effort tags `(S)`/`(M)`/`(L)` are optional for trivial single-domain plans,
required when step 1a ran.

Add a `— done when: <criteria>` suffix on any task with a verifiable bar
(tests passing, coverage threshold, specific behavior) — it's what lets the
executing agent iterate on its own instead of stopping after one attempt or
asking mid-task.

Add a `(par)` tag to a bullet only when it is genuinely independent of every
other unfinished bullet — no shared files, and no ordering dependency (a
contract → codegen → impl → test chain is *not* parallel even when the files
are disjoint). Untagged means sequential. See step 4.

Rules for the Tasks list:
- Each bullet is one small, independently-doable task — not a phase.
- Hard cap **7 bullets** (soft target 6) per Tasks list.
- If the work needs more than that, it means a task is too big — split it into
  smaller bullets first. If the *total* still exceeds 7, split the plan itself:
  keep the first 6-7 under `## Tasks`, and add the rest under
  `## Tasks — Phase 2` (left as `- [ ]`, not started until phase 1 clears).

Write it, then show the drafted plan to the user — **including Open
Questions** — and **wait for explicit approval** before doing anything else.
Do not start executing on your own.

On explicit approval:

1. If `## Open Questions` exists, it must be resolved first. Fold the answers
   into `## Context`, then **replace the whole `## Open Questions` section
   with a `## Decisions` section** holding each question and the answer
   given — one line each. Never leave answered questions sitting under
   `## Open Questions`; a resumed session reads them as still blocking.
2. `mcp__obsidian__update_frontmatter` → `status: approved`, `updated: <today>`.

## 3. Updating an existing plan

Use `mcp__obsidian__patch_note`, per the patching rules in
`references/plan-conventions.md` (never touch unrelated checkbox state, never
delete `[x]` / `[-]`, recover from a multi-match failure by widening
`oldString`). Bump `updated:` on every write.

## 4. Executing an approved plan

**Gate:** read the frontmatter first. Execute only when `status: approved`. If
it is `draft` or `awaiting-approval`, stop and ask for approval instead.

**Scope:** only bullets under the plain `## Tasks` heading. Bullets under
`## Tasks — Phase 2` (etc.) are **out of scope** — do not dispatch them. When
every bullet under `## Tasks` is `[x]` or `[-]`, rename the headings
(`## Tasks` → `## Tasks — Phase 1 (done)`, `## Tasks — Phase 2` → `## Tasks`)
and continue.

For each `- [ ]` task in that section, in order:

1. Build a **scoped prompt** = the `## Context` section (plus `## Decisions`
   if present) + that single task's line. Nothing else from the plan, and
   nothing from the wider conversation — the point is the subagent only sees
   what it needs for that one bullet.
2. Dispatch it with the `Agent` tool (pick the agent type that fits the task).
   **Sequential by default** — one task at a time. Dispatch in parallel only
   the bullets explicitly tagged `(par)`, and only with each other.
   If the task has a `— done when:` bar, tell the agent it may iterate
   (implement → run relevant tests → read failures → fix → repeat) on its own
   up to ~8 rounds to reach it, rather than reporting back after one pass or
   pausing to ask. If still short after that cap, or it suspects the ticket's
   ask conflicts with what's actually there, it stops and reports the
   conflict instead of pushing through.
3. When the agent reports back, run a code-review subagent (the repo's reviewer
   agent if one exists, else a general-purpose one) on its diff before
   showing anything to the user — catch architecture/correctness issues at
   this hop, not after the human review.
4. Present the (reviewed) result to the user for review, in this shape: a
   unified diff, a plain-language summary of what changed and why, a
   suggested branch name, and a suggested commit message. **Do not touch
   the checkbox yet.**
5. Only after the user explicitly confirms the review passed: patch the note,
   flipping that line from `- [ ]` to `- [x]` **with an audit suffix**:

   ```
   - [x] (M) <task text> → <branch>@<short-sha>
   ```

   Use `→ (uncommitted)` when the work is reviewed but not yet committed, and
   fix it up to the real sha on the next patch. If there's anything the suffix
   can't hold — a deviation from the plan, a follow-up discovered, a file
   touched outside the task's scope — append a dated bullet to a `## Log`
   section at the end of the note (create it on first use). Without this, a
   cold session resuming at task 4 has no idea what task 3 produced.

   Bump `updated:` in the same round of writes.

Never mark a task done because an agent finished — only because the user
confirmed the review. If the user wants to skip a task instead, that's
`memory-skip-task`, not this skill.

No task agent may `git push` or post to GitLab on its own — always stop at a
drafted commit/diff and wait for explicit user approval before either, per
standing rule.

## 5. Plan completion

After a checkbox flip, check whether every task across all `## Tasks` /
`## Tasks — Phase N` sections is now `[x]` or `[-]`. If so,
`mcp__obsidian__update_frontmatter` → `status: done`, `updated: <today>`, and
tell the user the plan is complete. Leave the note in `Work/` (don't move to
Archive) unless the user asks otherwise.
