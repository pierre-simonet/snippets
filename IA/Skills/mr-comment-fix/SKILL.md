---
name: mr-comment-fix
description: Analyze one GitLab MR review comment/thread from a link — decide if it's correct and needs a code fix, implement the fix if so, then draft (never post) a reply comment and a commit message for approval. Use when the user pastes a GitLab MR comment/thread URL (containing `#note_<id>`) and asks to check, handle, or resolve it. Never posts to GitLab and never runs `git commit` — output is a working-tree diff plus drafted text, or a question if anything is unsure.
---

# MR Comment Fix

Turn one review comment into: verdict → (maybe) fix → drafted reply + drafted
commit message. Never touches GitLab, never commits.

## Scope boundary

- `glab` is read-only here: `api .../discussions`, `api .../merge_requests/<iid>`,
  `mr diff`. Never `mr note`, never POST to `discussions/.../notes`, never
  `mr update`, never `ci retry`.
- Never `git commit`, never `git push`.
- Unsure whether the comment is correct, whether a fix is needed, which of
  several fixes is right, or which branch/worktree to edit in → **stop and
  ask**. Do not guess and do not silently pick one.

## Step 0 — Parse the link

Expected shape: `https://<gitlab-host>/<group>/<...>/<project>/-/merge_requests/<iid>#note_<note_id>`
(the fragment may also be a reply note inside a thread — that's fine, see step 1).

```bash
URL="<the link>"
NOTE_ID=$(grep -oE 'note_[0-9]+' <<<"$URL" | grep -oE '[0-9]+')
IID=$(grep -oE 'merge_requests/[0-9]+' <<<"$URL" | grep -oE '[0-9]+')
PROJECT_PATH=$(sed -E 's#https?://[^/]+/(.*)/-/merge_requests/.*#\1#' <<<"$URL")
```

No `#note_...` fragment → the link points at the whole MR, not one comment. Ask
which comment/thread to handle instead of guessing.

If `PROJECT_PATH` isn't the repo in the current directory (check `git remote -v`),
`:id` won't resolve — use the URL-encoded path instead:
`glab api "projects/$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=''))" "$PROJECT_PATH")/..."`.

## Step 1 — Fetch the thread + MR metadata

```bash
# Full thread containing that note (handles the fragment pointing at a reply, not just the root)
glab api "projects/:id/merge_requests/$IID/discussions?per_page=100" --paginate \
  | jq --arg nid "$NOTE_ID" '.[] | select(.notes[].id == ($nid|tonumber))'

# MR branch info
glab api "projects/:id/merge_requests/$IID" --jq '{source_branch, target_branch, sha}'
```

The discussion payload gives the full back-and-forth, resolved status, and for
inline comments `notes[].position.{new_path,new_line,old_path,old_line}`.

## Step 2 — Get to the right code

Check `git branch --show-current` (and any worktrees) against `source_branch`.
Per the repo's worktree convention: don't create a new branch for this. If the
MR's branch isn't already checked out somewhere obvious, tell the user and ask
where to apply the fix rather than fetching/checking out unprompted.

## Step 3 — Read the real code, not just the comment

Using `position.new_path`/`new_line` (or `old_path`/`old_line` for a comment on
now-changed/removed code), read the file at that location and the MR's diff for
it:

```bash
glab mr diff "$IID" -- <path>
# or, once on the source branch:
git diff "$(git merge-base HEAD origin/<target_branch>)"...HEAD -- <path>
```

Never evaluate the comment against your assumption of the code — read it.

## Step 4 — Analyze

Answer, in order, from the code + thread (not from the comment's framing alone):

1. Is the comment's claim actually correct?
2. If correct: does it call for a code change, or is it already handled /
   a question / a style opinion / not actionable?
3. If a change is warranted: is there one clearly-right minimal fix?

Any point you can't resolve with confidence → stop and ask, stating the exact
uncertainty (what the comment claims vs. what you read in the code, or the
specific fork between candidate fixes). This is the default outcome for
anything ambiguous — don't force a verdict.

## Step 5 — Fix (only if Step 4 fully resolved to "yes, and here's how")

- State why the comment is right and what the fix is, in plain language, before
  editing.
- Minimal diff scoped to exactly what the comment flags. No unrelated cleanup,
  no blind replace-all (see the repo's rename/refactor rules for renames).
- Check the repo's agent instructions (`AGENTS.md` / `CLAUDE.md` and any
  project skill) for the touched area first (i18n keys, tests, frontend, API
  contracts, etc.) and follow them.
- Run the narrowest relevant check (lint/typecheck/test for the touched
  file/module) — don't run a full-repo build for a one-line fix.
- Leave the change **uncommitted** in the working tree.

## Step 6 — Output

Always end with these, as chat output — never executed:

1. **Verdict** (1-3 lines): comment correct? fix needed? why.
2. **If fixed:** the diff (already in the working tree) + a drafted commit
   message:
   ```
   [PROJ-123] Short description   # ticket from the branch name, ≤50 chars; the repo's convention wins if it differs
   ```
   Add a body only when the why isn't obvious from the subject.
3. **Drafted reply** — the literal text the user could post to that thread
   (either what was fixed, or why nothing needed to change), plus the
   `discussion_id`/`note_id` so they can paste it themselves. Do not post it.
   Write it with the `my-writing-style` and `anti-ai-slop` skills: one
   sentence by default, two at most, longer only when the user asks.

## Rules

- Read-only `glab`, no `git commit`/`push`, no GitLab writes — always draft,
  always wait for the user to act.
- No new branches; use the MR's existing source branch/worktree, and ask first
  if it isn't already checked out.
- Ambiguous validity, ambiguous fix, or ambiguous branch/location → ask, don't
  guess.
