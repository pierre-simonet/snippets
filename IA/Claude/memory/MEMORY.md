# Memory Index

- [Explain before editing](explain-before-edit.md) — State root cause + proposed fix, wait for OK before touching any file
- [No confirmation for code changes](no-confirmation.md) — After the file list is OK'd, proceed without asking mid-task
- [No remote writes](no-remote-writes.md) — Never post GitLab/GitHub comments or git push; draft and wait for approval
- [External reply tone](external-reply-tone.md) — MR/Jira/Figma drafted replies: short, concise, kind, no em dash
- [Jira exact scope](jira-exact-scope.md) — Jira writes: only the tickets named; ambiguous wording => ask first
- [No prod DB access](no-prod-db-access.md) — Never connect to prod DBs/warehouse, not even dry-run; hand queries to user
- [Subagent scope creep](subagent-scope-creep.md) — Read-only lookup agents must not edit files; verify after they report back
- [Worktree merge policy](worktree-merge.md) — After work in a worktree, merge into the decided target branch; the user pushes
