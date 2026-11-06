Perform a code review of branch `{{BRANCH}}` at commit `{{SHA}}`
(cwd: {{REPO}}, base branch: `{{BASE}}`).

Read-only: never edit repository files, commit, push, or post to GitLab/GitHub.

## Prepared inputs

The branch is already fetched and the MR diff is already computed. Do NOT run `git fetch`,
`git log` or `git merge-base` yourself.

- `{{DIR}}/commits.txt`: commits specific to this branch ({{BASE}} commits already excluded)
- `{{DIR}}/stat.txt`: changed files with line counts
- `{{DIR}}/diff.patch`: full diff against the merge-base with {{BASE}}

## Steps

1. Read `commits.txt`, `stat.txt`, then `diff.patch`. If the diff is very large, read it per file with
   `git diff origin/{{BASE}}...origin/{{BRANCH}} -- <path>`.
2. Read the modified files in their branch version for full context:
   `git show origin/{{BRANCH}}:<path>`. The local working tree may be on another branch, so don't
   read these files from disk.
3. Produce the review in the structure below.

## Search guardrails

- Search inside the repo only. Prefer `git grep <pattern> origin/{{BRANCH}} -- <pathspec>`.
- Third-party library source (e.g. `@scope/ui-lib`) is at
  `node_modules/.pnpm/<scope>+<name>@<version>*/node_modules/<scope>/<name>/dist` in a pnpm repo.
  Locate it with `ls -d node_modules/.pnpm/<scope>+<name>@*`. The version in use is in the app's `package.json`.
- Never run `find /`, `find ~`, or search the pnpm store (`~/Library/pnpm`, `~/.pnpm-store`).
- Never print whole bundled/minified files. Grep for the symbol and print a narrow window around it.

## Review structure

### Context
Summary of what the MR does in one or two sentences.

### Positives
What is well done in the implementation.

### Points to discuss
For each point, include:
- The exact location (file:line)
- The problem or question
- A concrete suggestion if applicable

Classify points by severity:
- **Blocking**: bug, potential regression, security vulnerability, missing transaction
- **Important**: missing test, unhandled edge case, questionable design
- **Minor**: readability, naming, style

### Tests
Assess test coverage: are they sufficient? Do they assert concrete values or only structure?

### Overall verdict
A 2-3 sentence summary.

## Rules

- Only review commits specific to this branch.
- Always respond in English.
- Be concise and direct. No filler.
