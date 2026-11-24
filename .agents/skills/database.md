# Database — PostgreSQL & SQLite

All engineering rules from `engineering.md` apply. This adds only what's specific to databases.

## Schema Design

- Name tables and columns clearly. No abbreviations. `user_id` not `uid`.
- Use `snake_case` for PostgreSQL, match existing conventions if the project already has them.
- Every table gets a primary key. Use `SERIAL` / `BIGSERIAL` for PostgreSQL, `INTEGER PRIMARY KEY` for SQLite. UUIDs only if you have a distributed reason.
- Use `NOT NULL` wherever the field must have a value. Do not allow nullable columns that should never be null.

## Constraints

- Use database constraints to enforce data integrity. Unique, check, foreign key — do it at the DB level, not just in app code.
- App code is the last line of defense, not the first.
- Use `CHECK` constraints for domain rules (e.g., `price > 0`). They're portable and self-documenting.

## Indexes

- Index columns used in `WHERE`, `JOIN`, and `ORDER BY` clauses.
- Do not index everything. Index the queries you actually run.
- Composite indexes: column order matters. Most selective first, match your query's `WHERE` order.

## Transactions

- Wrap multi-step writes in a transaction. Not doing so is a bug, not an optimization.
- Keep transactions short. Long transactions hold locks and block others.
- For SQLite: use `BEGIN IMMEDIATE` if you expect write contention to avoid `SQLITE_BUSY`.

## PostgreSQL vs SQLite — Know the Differences

- **SQLite is single-writer.** No concurrent writes. Fine for low-traffic, wrong for write-heavy workloads.
- **PostgreSQL has MVCC.** Concurrent reads and writes. Use it for anything with real concurrency needs.
- **SQLite has no `ALTER TABLE` for many operations** (e.g., drop column was added in 3.35). Plan migrations accordingly.
- **PostgreSQL has rich types:** `JSONB`, `ARRAY`, `ENUM`, `INET`, ranges. Use them when they fit.
- **SQLite is file-based.** No network access, no auth, no roles. Treat it as an embedded engine.
- **PostgreSQL handles timezones** with `TIMESTAMPTZ`. SQLite stores strings or integers. Be explicit about timezone handling in your app.

## Migrations

- Use a migration tool (Alembic for Python, whatever the project uses).
- Migrations must be reversible or have a clear down path.
- Never modify a migration that's been applied to production. Write a new one.
- Test migrations against a fresh database, not just the current state.

## Query Correctness

- Do not use `SELECT *` in application code. Specify columns.
- Use parameterized queries always. No string interpolation of values. This is non-negotiable for security.
- Check for `NULL` behavior. `NULL = NULL` is `NULL`, not `TRUE`. Use `IS NULL` / `IS NOT NULL`.
- Be explicit about `JOIN` types. An implicit join that accidentally produces a cross product is a data bug.

## Denormalization

- Normalize to 3NF by default. Denormalize when you have a concrete, measured performance need.
- Redundant data is fine if it solves a real read pattern. The key word is _real_, not _hypothetical_.
- Document denormalizations in schema comments so future maintainers know it's intentional.

## Data Integrity

- Use foreign keys with `ON DELETE` / `ON UPDATE` actions that match your domain rules. Do not leave them as the default.
- Timestamps: `created_at` with `DEFAULT NOW()` (PostgreSQL) or `DEFAULT CURRENT_TIMESTAMP` (SQLite) on every table that represents an entity. `updated_at` when stale data matters.
