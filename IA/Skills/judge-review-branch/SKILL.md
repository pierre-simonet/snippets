---
name: judge-review-branch
description: Review a remote git branch twice in parallel — once in a Claude Opus 5.5 sub-agent, once in the `opencode` CLI — from the same prepared diff and prompt, then display a consolidated comparison (agreements, disagreements, unique findings). Reviews are cached per branch commit, so re-running on an unchanged branch is instant. Use when the user invokes "/judge-review-branch <branch>" or asks for a "double review" / "second opinion review" / "LLM-as-judge review" of a branch. Report-only — never edits code, never posts to GitLab/GitHub, never pushes.
---

# Judge Review Branch

Two independent reviewers, same prompt and same prepared diff, then a comparison.

**Arguments:** `$ARGUMENTS` = `<branch> [--force] [--opencode-model <provider/model>]`.
If no branch, ask the user for it and stop.
- `--force`: ignore cached reviews for this commit and re-run both reviewers.
- `--opencode-model`: pass `-m <provider/model>` to opencode (cached separately).

## Scope boundary

- Read-only on the repo. No repo edits, no commits, no `git push`, no `glab` write commands.
  The only files written are the review cache under `~/.cache/judge-review/`.
- `review-prompt.md` in this skill dir is the shared review prompt. Edit it to match the team's
  review conventions.

## 1. Prepare (one Bash call, main thread)

```bash
~/.claude/skills/judge-review-branch/prepare.sh $ARGUMENTS
```

Run it from inside the repo. It detects the default branch (`BASE`, from `origin/HEAD`, else
`main`, else `master`), fetches it + the branch, computes the MR diff once, renders `prompt.md`, and prints
`KEY=value` lines: `STATUS`, `REPO`, `BASE`, `SHA`, `DIR`, `COMMITS`, `DIFF_LINES`, `OPUS_OUT`, `OPUS_CACHED`,
`OPENCODE_MODEL`, `OPENCODE_OUT`, `OPENCODE_CACHED`.

- `STATUS=not-a-repo` → say the current directory isn't a git repo and stop.
- `STATUS=missing-branch` → say the branch doesn't exist on origin and stop.
- `COMMITS=0` → say the branch has no commits beyond `BASE` and stop.
- Both `*_CACHED=yes` → skip to step 3 and tell the user the reviews came from the cache for `SHA`
  (mention `--force` to re-run).

## 2. Launch the non-cached reviewers in parallel (single message)

Skip each reviewer whose `*_CACHED=yes`.

### Reviewer A — Claude Opus 5.5

`Agent` tool, `subagent_type: "general-purpose"`, `model: "opus"`, prompt:

```
Read <DIR>/prompt.md and follow it exactly.
When done, Write the full review (markdown, structure from prompt.md) to <OPUS_OUT>.
That is the only file you may write. Do not edit repo files, commit, push, or post to GitLab/GitHub.
Final message: only the line "written <OPUS_OUT>".
```

### Reviewer B — opencode

`Bash` tool with `run_in_background: true`:

```bash
cd '<REPO>' && \
opencode run --auto [-m <provider/model>] "$(cat '<DIR>/prompt.md')" \
  > '<OPENCODE_OUT>.tmp' 2> '<DIR>/opencode.err' \
  && mv '<OPENCODE_OUT>.tmp' '<OPENCODE_OUT>'
```

- Add `-m` only when the user passed `--opencode-model`.
- The `.tmp` + `mv` means a failed run never gets cached.
- `--auto` auto-approves `ask` permissions; `deny` rules in `opencode.json` stay denied.
  Full-disk / pnpm-store searches are discouraged by the guardrails in `review-prompt.md`; a hard
  `deny` exists only if the user added `find / *`-style rules to `opencode.json`.

Wait for the completion notifications. Do not poll with sleep.

## 3. Gather

`Read` `<OPUS_OUT>` and `<OPENCODE_OUT>`. If a reviewer failed (empty or missing output, or
non-zero exit), show the tail of `<DIR>/opencode.err` (or the agent's message) and compare only
what exists.

## 4. Display to the user

Do NOT reprint the reviews verbatim. They are in the files. Output only:

```
Reviews for `<branch>` @ `<SHA short>` (<fresh | cached>):
- Claude Opus 5.5: `<OPUS_OUT>`
- opencode (<OPENCODE_MODEL>): `<OPENCODE_OUT>`

## Comparison
| Finding (file:line) | Severity A | Severity B | Status |
|---|---|---|---|
| ... | Blocking | — | Only A |
| ... | Important | Important | Both |

**Agreements:** points both flagged (these are highest-confidence).
**Disagreements:** same location, different severity or opposite verdict — state each side in one line.
**Unique to A / Unique to B:** list briefly.
**Verdicts:** A's overall verdict vs B's in one line each.
```

Rules for the comparison:
- Match findings by file + intent, not exact wording.
- Don't invent findings or re-rank them yourself; report what each reviewer said.
- If the user asks to see a full review, print that file then.
- If asked afterwards to adjudicate a disagreement, verify against `<DIR>/diff.patch` before answering.
