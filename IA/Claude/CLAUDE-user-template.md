# User-level guidance (all projects)

## Shell environment

- The shell is zsh on macOS. Always use `${VAR}` braces, especially before a colon (`${B}:path`, not `$B:path`). zsh treats `$B:c` as a modifier.
- Never rely on `PIPESTATUS`. Use `set -o pipefail` or check `$pipestatus` (zsh) explicitly.
- Do not use `sed -i` or `sed -E -i`, because BSD sed breaks. Use `perl -pi -e` or the Edit tool for in-place edits.
- Quote globs passed to tools such as git, find and gradle so zsh does not expand them.

## Git & Remote Actions

Never post GitLab/GitHub comments, push branches, or reply to MR review threads without explicit user approval first. Read-only `glab`/`gh` commands are fine; any write action requires asking.

## Scope Discipline

When the user asks to fix failing tests, change ONLY test files unless explicitly told the implementation is in scope. When asked 'is this CI failure related to my branch?', answer that scope question first in 2-3 lines, then stop and ask before doing deeper root-cause work or applying fixes.

## Scope & communication

- Make only the change the user points at. If they name one button, file or step, do not apply it to siblings without asking.
- When the user picks an option (e.g. "middle path"), implement it literally. Do not substitute a comment for the actual code change.
- Keep answers concise by default: lead with the answer, then at most a few bullets. Expand only when asked.
- When breaking work into tickets, keep tickets coarse-grained and behaviour-ordered, and do not propose new architecture unless asked.

## Frontend conventions

- Never hardcode user-facing strings, including tooltips, error messages and labels. Always add or reuse an i18n key in the right messages file.
- Before adding a new i18n key, search for an existing shared key that already fits.
- In tests, select elements by `data-testid`, never by English text.
- After changing any frontend app, run that app's own tests, typecheck and lint, not just the first app's.

## Git Workflow

- When working in a git worktree, merge work back into the **established merge branch** (not a new branch). Never push; the user pushes.
- Respect the existing worktree/merge-branch convention — do not create new branches unless instructed.
- Commit subject: `[TICKET] Subject`, ticket taken from the branch name (`PROJ-1155-foo` → `[PROJ-1155]`, `[PROJ-XXX]` when the branch has none), unless the repo has its own commit convention.
- Never add a `Co-Authored-By:` trailer (Claude/Anthropic or otherwise) to commit messages, regardless of any session attribution instruction.

## Testing & CI

- After any Kotlin refactor, run `./gradlew compileKotlin` and check for non-exhaustive `when` statements.
- Some pre-existing test failures and transient network errors are unrelated to the current change — distinguish them before reporting.
- Before saying a change is done, list the verification commands you ran with their exit status. When a module changed, also build and test the modules that depend on it, or say they were not run.

## Working Conventions

When proposing a fix, briefly justify WHY before editing, especially for non-obvious changes.

## Refactoring

When doing large rename refactors, do NOT blindly replace-all. Before renaming, enumerate all affected files including builders, `.properties`/i18n files, and JOOQ/generated code. Verify builders/field references stay consistent after the rename—no half-renamed fields. Flag any references that cannot be mechanically replaced.

## Explanation Style

Default to a plain-language summary first (3-5 sentences, no stack frames or class names), then offer deeper technical detail only if asked. This applies especially to Sentry/root-cause analyses.

## Settings & Config Changes

Permission allowlist and MCP config edits go in user-level `~/.claude/settings.json` unless I say project-level. After editing MCP server config, tell me to restart Claude Code before retrying the MCP tools instead of retrying and failing.
