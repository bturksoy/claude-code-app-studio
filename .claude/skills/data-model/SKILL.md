---
name: data-model
description: Designs the data model — ER diagram, table schema, constraints, indexes and migration plan. Treats the data dictionary as the canonical source. Produces db/schema.sql and docs/data/ER.md.
---

# /data-model [scope]

Owner: `sql-developer`, consulted: `solution-architect`.
Outputs: `docs/data/ER.md`, `db/schema.sql`, `db/migrations/NNNN_*.sql`

---

## 1. Input

- `product/requirements/data-dictionary.md` — **the canonical term source**
- The data-related parts of the relevant REQs
- `docs/architecture/ARCHITECTURE.md` — database choice, transaction boundaries
- The existing `db/schema.sql` and the last migration number

## 2. Invoke `sql-developer`

```
Database: <choice + version>
Data dictionary: <the full term table>
Related requirements: <REQ id + data-related behaviour summary>
Existing schema: <table + column list, not DDL>
Last migration: <number>
Transaction boundaries: <from the architecture>

Task: produce the data model.

1. ER diagram (Mermaid erDiagram) — correct relationship cardinalities
2. For each table:
   - Purpose (one sentence)
   - Columns: name, type, nullability, default, description
   - Primary key, foreign keys (with ON DELETE behaviour)
   - Uniqueness constraints (business keys)
   - CHECK constraints (the database counterpart of business rules)
   - Deletion strategy: hard / soft (deleted_at) / archive
3. Indexes — for each, WRITE DOWN which query it speeds up
4. Migration files: NNNN_<name>.sql, each with -- +up / -- +down sections
5. The full schema.sql (the target state after migration)
6. If you denormalized, give the rationale and state whether an ADR is needed

Mandatory rules:
- Naming: tables plural snake_case, FK <singular>_id, indexes ix_/uq_/ck_/fk_
- created_at, updated_at on every table as timestamptz (UTC)
- Money: numeric or minor-unit bigint — float FORBIDDEN
- Constraints > application code: the database must not accept corrupt data
- Use the terms from the data dictionary; do not invent new ones
- Safe migration ordering on a live system (add nullable → backfill → constrain → drop old)
```

## 3. `solution-architect` cross-check (full mode)

```
<ER SUMMARY: tables, relationships, critical constraints>

Task: does this model fit the architecture?
1. Are transaction boundaries compatible with the model
2. Does table ownership conflict with module boundaries
3. Do the query patterns force N+1 or complex joins
4. Will the scale NFR hold with this model
At most 10 lines. Begin with "APPROVED|CONDITIONAL|REJECTED".
```

## 4. Verification

If you can actually run the migrations (a local database exists), test them in
`up → down → up` order and report the output.
If you cannot run them, **say so explicitly** — write "not tested", never "it works".

## 5. Present

```
## Data Model
Tables: <N> | Relationships: <M> | Indexes: <K>

| Table | Purpose | Row estimate | Deletion strategy |

Migrations: <files>
Constraints: <important CHECK/UNIQUE list>
⚠ New terms not in the data dictionary: <if any>
```

Get approval via `AskUserQuestion`.

## 6. Write

- `docs/data/ER.md`, `db/schema.sql`, `db/migrations/*.sql`
- If new terms were added, report them as a **proposal to `business-analyst`**
  (you do not modify data-dictionary.md — the BA owns it)
- A model-decision line in `docs/DECISIONS.md`

## 7. Close

```
✓ Data model → docs/data/ER.md + db/schema.sql
  <N> tables | <M> migrations | up/down test: <result>

▶ Next: /api-contract (if not done) or /epics
```

---

## Token note

- The data dictionary is embedded **in full** (short and critical). REQs only as
  data-related summaries.
- The existing schema is embedded as a **table+column list**, not as DDL.
- The `solution-architect` cross-check runs only in `full` mode.
