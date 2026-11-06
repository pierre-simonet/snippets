---
name: no-prod-db-access
description: Never connect to production databases or warehouses (not even read-only, metadata or dry-run); answer from code or hand the query to the user
metadata:
  type: feedback
---

Never connect to production data: prod DB tunnels, prod data sources in the IDE, or the production BigQuery project. That holds even read-only, even when a tunnel is already running, and even for metadata (`bq ls`, `bq show --schema`, `bq query --dry_run`). Write the query and give it to the user to run (skill [[prod-query]]). Local and staging are fine.

**Why:** a read-only count once ran on prod to answer "is this data used in prod", and `bq` metadata reads and dry runs hit the production project. The user said "no prod access, just check in codebase". `~/.claude/hooks/guard.sh` blocks these paths once configured with the new job's prod ports and names.

**How to apply:** answer "is X used in prod / which store holds X" from code: repository implementations, DI wiring, migrations, generated DB code, migrations merged to the default branch. Say which assumptions you couldn't verify. Ask first if prod data seems truly necessary.
