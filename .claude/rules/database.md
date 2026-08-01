# Database Rules

**Scope:** `db/**`, `**/migrations/**`, `**/*.sql`, `**/entities/**`, `**/models/**`

---

## Naming

| Object | Convention | Example |
|---|---|---|
| Table | plural, snake_case | `order_items` |
| Column | singular, snake_case | `unit_price` |
| Primary key | `id` | `id` |
| Foreign key | `<singular>_id` | `order_id` |
| Index | `ix_<table>_<columns>` | `ix_orders_customer_id_created_at` |
| Unique | `uq_<table>_<columns>` | `uq_users_email` |
| Check | `ck_<table>_<rule>` | `ck_orders_total_positive` |
| Foreign key constraint | `fk_<table>_<target>` | `fk_order_items_order` |
| Migration | `NNNN_<snake_name>.sql` | `0012_add_user_roles.sql` |

No abbreviations (`usr`, `ord` are forbidden). No reserved words.

## Mandatory columns

On every table:
```sql
id           <uuid|bigint>  PRIMARY KEY
created_at   timestamptz    NOT NULL DEFAULT now()
updated_at   timestamptz    NOT NULL DEFAULT now()
```
If soft delete is used: `deleted_at timestamptz NULL` + a partial index.

## Constraints

**Constraints > application code.** The database must not accept corrupt data.

- `NOT NULL` by default; nullability requires justification
- Every foreign key defines its `ON DELETE` behaviour (`RESTRICT` by default)
- Business keys are protected by `UNIQUE` constraints
- Value ranges are protected by `CHECK` (`ck_orders_total_positive`)
- Enums: rarely changing and known to code → DB enum/CHECK; managed by the business →
  reference table

## Types

- Money: `numeric(precision, scale)` or minor-unit `bigint` — `float`/`real` **forbidden**
- Time: `timestamptz` (UTC). Naive `timestamp` is forbidden
- Text: `text` + `CHECK (length(...))` — a real limit instead of an arbitrary `varchar(255)`
- Boolean: `boolean`, not nullable (give it a default)
- JSON: `jsonb`; but any field that will be queried becomes a column, not a JSON key

## Indexes

Every index is tied to a query and its rationale is written down:

```sql
-- Query: orders by customer, sorted by date (REQ-ORD-004)
-- Before: Seq Scan 340ms → After: Index Scan 12ms
CREATE INDEX CONCURRENTLY ix_orders_customer_id_created_at
  ON orders (customer_id, created_at DESC);
```

- Foreign keys are indexed (delete and join performance)
- Column order in a composite index: equality → range → sort
- An unnecessary index is a write cost; remove unused ones

## Migrations

- Every migration has `-- +up` and `-- +down` sections
- **An applied migration is never edited** — write a new one
- Schema changes and data changes go in **separate files**
- Safe ordering on a live system:
  ```
  1. Add a nullable column
  2. Backfill the data (separate migration)
  3. Add the NOT NULL constraint
  4. Drop the old column (in a later release)
  ```
- Never rename a column in a single migration — spread it across two releases
- On large tables use `CREATE INDEX CONCURRENTLY`; check whether `ALTER TABLE` rewrites
  the table
- A migration is not DONE until `up → down → up` has been tested

## Queries

- `SELECT *` is forbidden — list the columns explicitly
- No unbounded result sets — `LIMIT` is mandatory
- Business logic lives in the domain layer, not in SQL (simple derivations excepted)
- Triggers are a last resort; using one requires an ADR
- Stored procedures require an ADR

## Prohibitions

- Proposing or running `DROP TABLE` / `DROP DATABASE` / `TRUNCATE`
- Direct `UPDATE`/`DELETE` against production (go through a migration or the runbook)
- Keeping personal data unmasked in an index or a log
- Saying "the application already checks it" instead of adding a constraint
