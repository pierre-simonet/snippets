---
name: expand-contract-migration
description: Use when renaming a column, changing a column's semantic meaning, or migrating a field to a new type/name on a live Postgres table that's read/written by backend code, JOOQ, API/WS contracts, and/or frontend. Covers the zero-downtime "expand-contract" pattern — add column, backfill, dual-write trigger, staged consumer cutover, cleanup.
---

# Expand-Contract Column Migration

A live column can't be renamed in one `ALTER TABLE RENAME COLUMN` when it's consumed by
backend code, JOOQ generated code, API/WS contracts, and frontend — those all deploy
independently (rolling deploys, no flag-day). Use the 5-phase expand-contract pattern instead.

## The 5 phases (one MR each, shipped in order)

1. **Add new column + backfill + concurrent index** — this skill's focus below.
2. **Backend internal rename to the new field name + dual-write** (app writes both old and new columns).
3. **API/WS contract expand + consumer compile updates** (widen contract, don't remove old field yet).
4. **Frontend cut-over** to the new field.
5. **Contract & DB cleanup** — drop old field from contracts, drop DB trigger/function/column.

Each phase is a separate MR/deploy. Don't skip ahead — phase 3 needs phase 2 live everywhere,
phase 5 needs phase 4 live everywhere.

## Phase 1: the SQL, in order, in one changeset

```sql
--liquibase formatted sql
--changeset <you>:xxxxx-add-new-col logicalFilePath:fixed splitStatements:false

ALTER TABLE schema.table
    ADD COLUMN IF NOT EXISTS new_col TEXT;

UPDATE schema.table
SET new_col = old_col
WHERE new_col IS NULL;

ALTER TABLE schema.table
    ALTER COLUMN new_col SET NOT NULL;

COMMENT ON COLUMN schema.table.new_col IS 'description';

-- Keeps new_col populated for rows inserted by app instances still running pre-dual-write code
-- (old_col is written, new_col is not yet). Safe no-op once every writer dual-writes both columns.
-- To be dropped in the phase-5 MR that drops old_col.
CREATE OR REPLACE FUNCTION schema.sync_table_new_col()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.new_col IS NULL THEN
        NEW.new_col := NEW.old_col;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_sync_table_new_col
    BEFORE INSERT
    ON schema.table
    FOR EACH ROW
EXECUTE FUNCTION schema.sync_table_new_col();
```

Index goes in a **separate** changeset with `runInTransaction:false`, `CREATE INDEX CONCURRENTLY`.

### Why this exact order

- **Nullable add → backfill → `SET NOT NULL`**, never `NOT NULL` directly on `ADD COLUMN`:
  a non-empty table has no value to put in existing rows, the statement fails immediately
  (or forces a full-table default-rewrite pre-PG11).
- **Everything (except the index) in one transaction**: the `ALTER TABLE` holds a lock for the
  whole block, so no concurrent INSERT can sneak a NULL row in between the backfill `UPDATE`
  and the `SET NOT NULL`. That's what makes the backfill-then-constrain sequence safe rather
  than racy.
- **Trigger fires only `BEFORE INSERT`**, not `UPDATE` — it's a forward-compat shim for old
  app code, not a general sync mechanism.

### Why the trigger, given phase 2 (dual-write) comes later

Phase 1 sets `NOT NULL` immediately, but phase 2 (the app code that writes `new_col`) ships in
a *separate* deploy, possibly days later, with a rolling-deploy window of mixed old/new code.
Without the trigger, any INSERT from an old app instance during that gap has no value for
`new_col` → constraint violation → crashes. The trigger is the DB-level bridge across that gap.

Alternative (no trigger): leave the column nullable through phase 1, add `SET NOT NULL` in a
*separate* migration once phase 2 is fully rolled out everywhere. Weaker guarantee, one more
migration to remember. The trigger trades a temporary shim for enforcing the constraint from
day one.

### Trigger caveats

- It **can't distinguish** "old code didn't set new_col" (expected, desired) from "new
  dual-write code has a bug and explicitly passed NULL" (a real bug) — both look identical as
  `NEW.new_col IS NULL`. Don't try to make the trigger `RAISE EXCEPTION` on this — that breaks
  the exact case it exists to support (every insert from not-yet-updated app instances would
  start failing). Catch dual-write bugs with app-layer validation/tests in phase 2 instead.
- Backfill copying `old_col` straight into `new_col` is only correct if they're the same value
  *today* (e.g. one is a `typealias` of the other, or a 1:1 relationship that hasn't diverged
  yet). If the new column requires a real transformation/lookup, the backfill needs that join,
  not a straight copy.

### Lock-duration risk on large tables

Backfill `UPDATE` + `SET NOT NULL` in one transaction scans the whole table while holding the
lock from the `ALTER TABLE`. Fine for small/medium tables. For a large, high-traffic table,
consider the `ADD CONSTRAINT ... NOT NULL NOT VALID` + `VALIDATE CONSTRAINT` split (validates
without blocking writes) instead of a straight `SET NOT NULL`. Check row count first.

## Phase 5: cleanup order matters

`DROP COLUMN` does **not** cascade to a trigger/function that merely references the column
inside its body — Postgres only tracks `pg_depend` for views, generated columns, defaults,
FKs, CHECK constraints, not for arbitrary plpgsql body text. Drop explicitly, in this order
(trigger depends on function, function is dropped before the column it reads):

```sql
DROP TRIGGER IF EXISTS trg_sync_table_new_col ON schema.table;
DROP FUNCTION IF EXISTS schema.sync_table_new_col();
ALTER TABLE schema.table DROP COLUMN old_col;
```

Put all three in the same changelog file so cleanup can't be half-done.

## See also

The repo's own migration guide for Liquibase changeset mechanics (naming, idempotency, grants).
This skill is the higher-level pattern for the column-rename use case specifically.
