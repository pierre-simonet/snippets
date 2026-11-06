---
name: ci-diag
description: Diagnose a failing GitLab CI job — classify the failure as branch-caused vs pre-existing-on-the-default-branch vs flaky, with evidence, then optionally trace the root cause and draft a fix. Use when the user asks "is this CI failure mine / related to my branch", "why is the pipeline red", "diagnose job 123", pastes a GitLab job/pipeline URL, or invokes "/ci-diag". Diagnosis-first: it answers the scope question before touching code, and never commits or pushes. For the apply-fix-then-run-the-suite-then-commit flow, use `fix-ci` instead.
---

# CI Failure Diagnosis

Answer *whose fault is this* first, with evidence. Only then look at fixing.

## Scope boundary

- This skill: fetch log → classify → evidence → (optional) root cause + proposed
  minimal fix + drafted commit message. **Never** runs `git commit`, `git push`,
  or any `glab` write command.
- `fix-ci`: the apply-and-verify flow (fix → run tests → commit). Hand off there
  if the user wants the fix landed, don't duplicate it here.

## Input

Arguments are free text — parse intent, there are no positional `$1`/`$2` slots:

- A numeric job id (or a GitLab job URL ending `/jobs/<id>`) → use it directly.
- A branch name, an MR iid, or nothing → resolve the job in step 0.
- The user asking only whether the failure is theirs ("is this mine?", "related
  to my branch?", "verdict only") → **stop after step 4.** No root cause, no fix.
  This is also the default when the ask is ambiguous.

## Step 0 — Resolve the failing job(s)

Skip if given a job id.

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)   # or the branch the user named
BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's#^origin/##')   # main or master

# Failed jobs of that branch's latest pipeline
glab ci get -b "$BRANCH" -F json --jq \
  '[.jobs[] | select(.status=="failed") | {id, name, stage, web_url}]'
```

For an MR instead of a branch: `glab ci get --merge-request <iid> -F json --jq '…'`.

Nothing failed → say the pipeline is green and stop. More than ~3 failed jobs →
list them, diagnose the earliest-stage one first (later stages are usually
downstream of it), and say that's what you did.

## Step 1 — Fetch the log

```bash
glab api "projects/:id/jobs/<JOB_ID>/trace" | tail -2000
```

- `:id` resolves to the current repo — run from inside the repo.
- `glab api` has **no** `--jq` flag; pipe to `jq` / `tail` / `grep`.
- Drop the `| tail -2000` only when the whole trace is small. For a big trace,
  narrow instead of dumping: `| grep -nE 'FAILED|FAILURE|error:|Caused by|✗' | tail -50`.
- Do **not** use `glab ci trace` as the default — it streams in real time and
  hangs on a still-running job.

Never ask the user to paste a log.

## Step 2 — What this branch changed

```bash
git log --oneline "origin/${BASE}..HEAD"
git diff --stat "origin/${BASE}...HEAD"
```

Fetch first if local refs may be stale: `git fetch origin "${BASE}"`.

## Step 3 — Baseline: is the default branch already red?

Required before claiming "pre-existing" — don't assert it from intuition.

```bash
# Latest default-branch pipeline + its failed jobs
glab ci get -b "${BASE}" -F json --jq \
  '{pipeline: .id, status: .status, failed: [.jobs[] | select(.status=="failed") | .name]}'
```

If the same job name is failing on `BASE` → category (b), and cite that pipeline
id. If `BASE` is green, (b) is ruled out.

For (c), evidence means one of: the job passes on retry, the failure names a
network/timeout/port/container issue, or the same job flips state across
pipelines on the same SHA.

## Step 4 — Verdict, ≤3 lines

State, in this order:

1. Category — **(a) branch-caused** / **(b) pre-existing on the default branch** / **(c) flaky
   or transient**.
2. The evidence (default-branch pipeline id, retry result, or the offending commit SHA +
   author for (a)).
3. Whether anything is expected of the user.

Then **stop and ask** before going further, unless the user already asked for a
fix in their original message.

## Step 5 — Root cause + proposed fix — category (a) only

Trace the failure into the code (the trace's file/line, then the actual source),
state the root cause in plain language first, then propose the **minimal** fix.
Justify why before editing anything.

Scope rule: if the failure is a failing test, change only test files — unless
the classification shows the implementation is genuinely wrong, in which case say
so explicitly and let the user decide.

For (b) and (c): summarise with the evidence and stop. No fix.

## Step 6 — Draft the commit message

Draft only — never run `git commit`.

```
type(scope): short description   # ≤50 chars

Why: <root cause, one or two lines>
```

## Rules

- `glab` read-only here: `ci get`, `api …/trace`, `ci list`. Never `mr note`,
  `mr update`, `ci retry`, or any POST.
- No `git commit`, no `git push`. Draft and wait for explicit approval.
- Evidence before verdict; verdict before fix.
- Only category (a) gets a proposed fix.
- Full test-suite runs are `fix-ci`'s job, not this skill's.
