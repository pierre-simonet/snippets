---
name: prod-query
description: Write a read-only Postgres, MongoDB or BigQuery query that Pierre runs himself on production, test it on local or a staging environment first, then read back the results he pastes (counts, percentages). Use when he asks for "a query I'll run in prod", "give me a query to count / check / find ...", "in a single query", "here's the result", or "give me %". Never executes anything on production.
---

# Prod query hand-off

Pierre runs production queries himself. Claude writes them, proves them on a non-prod database, and interprets what he pastes back.

## Databases

Fill this table in for the current job before first use.

| Env | Postgres | Mongo | BigQuery |
|---|---|---|---|
| Local | `localhost:<port>` | `localhost:<port>` | n/a |
| Staging | `localhost:<port>` | `localhost:<port>` | project `<staging-project>` |
| Production | `localhost:<port>`: never | `localhost:<port>`: never | `<prod-project>`: never |

Never connect to the production row, not even read-only or dry-run. If a PreToolUse hook blocks it, don't look for another path to it.

## Steps

1. **Names from the repo, not from prod.** Tables and columns come from the migration changelogs, generated DB code (JOOQ, ORM entities) and `COMMENT ON` lines. Collections and fields come from the Mongo documents and repositories. Name any table, collection or field you couldn't confirm.
2. **One query, one statement.** No script, no temp table and no multi-step flow unless he asks. For Mongo, write a single `db.<coll>.find(...)`, `countDocuments(...)` or `aggregate([...])` in mongosh syntax, not a JS program.
3. **Read-only.** `SELECT` / `find` / `aggregate` without `$out` or `$merge`. Say in one line that it is read-only.
4. **Default filters come from the code.** When an entity has subtypes the business usually excludes from counts (test accounts, soft-deleted rows, a legacy kind), derive the filter from the code that already applies it, and state the filter you used.
5. **Breakdowns carry the total and the percentage** in the same result (`count`, `total`, `pct`).
6. **Test before handing over.** Run it on local or staging, fix it until it runs, then give it with one line: "tested on <env>: <n> rows".
7. **Pasted results:** answer with a small table of the numbers and %, then one or two lines on what it means. Don't re-explain the query.
