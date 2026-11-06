---
name: fix-ci
description: Fix a CI failure that has already been attributed to the current branch — apply the code change, verify it with the narrowest useful test command, then draft a commit for approval. Use when the user says "fix the CI failure", "make the pipeline green", "fix job 123", or asks for a fix after a diagnosis. For "is this failure mine / why is CI red" (classification only), use `ci-diag` instead — this skill assumes that question is already answered and never pushes or posts to GitLab.
---

# Fix CI Failure

Applies and verifies a fix. Classification is `ci-diag`'s job, not this skill's.

## Scope boundary

- `ci-diag`: resolve job → fetch log → classify (branch-caused / pre-existing on
  the default branch / flaky) → evidence → propose a fix. Read-only.
- This skill: take a **branch-caused** failure and land it — edit, verify, draft
  the commit.

Only fix category (a), branch-caused. Pre-existing-on-default-branch and flaky failures
get reported, not patched — patching them silently expands the branch's diff
into unrelated territory.

## Step 1 — Get the failure, classified

If the failure is not already classified in this conversation, run `ci-diag`'s
steps 0-4 first and stop at its verdict. Do not start editing on an unclassified
failure.

Log fetching is `glab`:

```bash
# Failed jobs of the current branch's latest pipeline
glab ci get -b "$(git rev-parse --abbrev-ref HEAD)" -F json --jq \
  '[.jobs[] | select(.status=="failed") | {id, name, stage}]'

# The log ( `glab api` has no --jq; pipe to jq/tail/grep )
glab api "projects/:id/jobs/<JOB_ID>/trace" | tail -2000
```

Never ask the user to paste a log.

## Step 2 — Fix

- State the root cause in plain language, and **why** the change is needed,
  before editing. Non-obvious changes get a one-line justification each.
- Minimal diff. No blind replace-all — see the repo's refactoring rules.
- **Scope rule:** if the failing job is a test, change only test files. Touch the
  implementation only when the diagnosis shows the implementation is genuinely
  wrong — and say so explicitly first, since that widens the branch's blast
  radius.
- Multiple failing jobs: fix the earliest-stage one first and re-check; later
  stages are often downstream of it.

## Step 3 — Verify, narrowest first

Start at the tightest command that can prove the fix, widen only on evidence.
Never open at the repo root — `pnpm test` / `./gradlew test` across the whole
repo takes tens of minutes and usually times out before telling you anything.

**Backend (Gradle):**

```bash
./gradlew :<project>:test --tests '*<TestClassOrPattern>*'   # 1. the failing test
./gradlew :<project>:test                                     # 2. the module
./gradlew :<project>:build                                    # 3. module + checks
```

**Frontend (pnpm/Turbo):**

```bash
pnpm test:ci   --filter=<package>
pnpm typecheck --filter=<package>
pnpm lint      --filter=<package>
```

Package name = the `name` field in that app's `package.json`.

Widen past the module only when the change is genuinely cross-module (a shared
lib, a contract, a shared translations file). Say so when you do, and prefer
letting CI cover the rest over running the root target locally.

Iterate: run → read the failure → fix → re-run, up to ~8 rounds. Still failing
after that, or the fix keeps growing beyond the original failure: stop and report
what's blocking rather than pushing on.

Report every command you ran and its actual result. A skipped verification gets
said out loud, never silently omitted.

## Step 4 — Draft the commit, then wait

Conventional Commits. Subject ≤50 chars. Body only when the why isn't obvious:

```
type(scope): short description

Why: <root cause, one or two lines>
```

**Show the diff and the drafted message, then wait for explicit approval before
running `git commit`.** Never `git push`. Never post to GitLab (`glab mr note`,
`mr update`, `ci retry` are all out).

## Known failure recipes

**Lint / format jobs** — reproduce with the exact script CI runs (read the job
definition in the CI config), not an approximation. Never reformat generated
sources.

**Architecture-rule tests** (ArchUnit and similar) — the fix is almost always in
the code under review, not in the rule.

**Kotlin `when` exhaustiveness / compile breaks after a refactor** —
`./gradlew :<project>:compileKotlin` before the test run.

## Rules

- Category (a) only. Pre-existing and flaky failures: report with evidence, stop.
- Never stop at compilation — a test must actually run and pass.
- Never the root test target as the first command.
- Draft the commit, wait for approval. No push, no GitLab writes.
- Report actual command output, including anything that still fails.
