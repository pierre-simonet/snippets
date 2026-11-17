# Snippet

## Bash

- [Activate completion on aliases](Bash/Completion_alias.md)

## Git

- [Aliases](Git/Aliases.md)

## Gradle

- [Use MavenLocal](Gradle/MavenLocal/mavenlocal.md)

## Java

- [Setup Logback](Java/Logback/logback.md)
- [Get current version](Java/Version/Version.java)
- [Use Gradle Dependencies offline](Java/Offline/offline.md)

## Docker

- [Aliases](Docker/Aliases.md)
- [Systemd in container](Docker/Use_systemd/Makefile)
- DB2
  - [DB2 client in container](Docker/DB2/DB2_client_in_container/Dockerfile)
  - [DB2 server in container](Docker/DB2/DB2_server_in_container/Dockerfile)
  - [DB2 server in IBMCOM container](Docker/DB2/DB2_server_in_ibmcom_db2_container/Makefile)
- Oracle
  - [Oracle client in container](Docker/Oracle/Oracle_client_in_container/Dockerfile)
  - [Oracle server in container](Docker/Oracle/Oracle_server_in_container/Dockerfile)
- Sql Server
  - [Sql Server in container](Docker/Sql_Server/Makefile)

## Linux

- Ubuntu
  - [Clean snap cache](Linux/Ubuntu/clean-snap-cache.sh)
  
## IA
- Skills
  - [anti-ai-slop](IA/Skills/anti-ai-slop/SKILL.md) — Copyediting filter to strip "AI feel" from prose
  - [ci-diag](IA/Skills/ci-diag/SKILL.md) — Diagnose a failing GitLab CI job (branch-caused vs pre-existing vs flaky)
  - [datadog-analyzer](IA/Skills/datadog-analyzer/SKILL.md) — Analyze a Datadog Error Tracking issue for the current repo
  - [expand-contract-migration](IA/Skills/expand-contract-migration/SKILL.md) — Zero-downtime column rename/migration pattern on live Postgres
  - [fix-ci](IA/Skills/fix-ci/SKILL.md) — Fix a CI failure attributed to the current branch
  - [judge-review-branch](IA/Skills/judge-review-branch/SKILL.md) — Dual-reviewer branch review (Claude Opus + opencode in parallel)
  - [memory-plan](IA/Skills/memory-plan/SKILL.md) — Multi-step persisted checkbox plan management (Obsidian vault)
  - [memory-plan-status](IA/Skills/memory-plan-status/SKILL.md) — View progress on the active plan
  - [memory-resume](IA/Skills/memory-resume/SKILL.md) — Resume an existing plan in a fresh session
  - [memory-skip-task](IA/Skills/memory-skip-task/SKILL.md) — Skip/cancel a pending task on the active plan
  - [mr-comment-fix](IA/Skills/mr-comment-fix/SKILL.md) — Handle a GitLab MR review comment: analyze, fix, draft reply
  - [my-writing-style](IA/Skills/my-writing-style/SKILL.md) — Write in Pierre's voice (Slack / Jira / MR messages)
  - [prod-query](IA/Skills/prod-query/SKILL.md) — Write a read-only production query (Postgres / MongoDB / BigQuery)
  - [pup](IA/Skills/pup/SKILL.md) — Datadog CLI reference and query helper
  - [remember-project](IA/Skills/remember-project/SKILL.md) — Record a durable team convention in repo agent instructions
  - [remember-user](IA/Skills/remember-user/SKILL.md) — Record a personal preference in ~/.claude/CLAUDE.md
- Agents
  - [Grumpy Reviewer](https://github.com/sinedied/genaiscript/blob/bc4456d2afa94f843172041aad76990054312d05/genaisrc/linters/grumpy-dev.md)
  - [SubAgents list](https://github.com/andlaf-ak/claude-code-agents)
- Claude
  - [CLAUDE.md for Java projects](IA/Claude/CLAUDE.md)
  - [Plugins](IA/Claude/plugins.md) — You should know (side agent that flags what you might have missed)
  - Config templates
    - [User CLAUDE.md template](IA/Claude/CLAUDE-user-template.md)
    - [guard.sh hook](IA/Claude/hooks/guard.sh) · [settings-snippet.json](IA/Claude/hooks/settings-snippet.json)
    - Memory: [external-reply-tone](IA/Claude/memory/external-reply-tone.md) · [jira-exact-scope](IA/Claude/memory/jira-exact-scope.md) · [no-prod-db-access](IA/Claude/memory/no-prod-db-access.md) · [no-remote-writes](IA/Claude/memory/no-remote-writes.md) · [worktree-merge](IA/Claude/memory/worktree-merge.md) · [subagent-scope-creep](IA/Claude/memory/subagent-scope-creep.md) · [explain-before-edit](IA/Claude/memory/explain-before-edit.md) · [no-confirmation](IA/Claude/memory/no-confirmation.md)