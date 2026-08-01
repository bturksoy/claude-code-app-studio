# Backend Code Rules

**Scope:** `src/backend/**`, `src/api/**`, `src/services/**`, `src/domain/**`

---

## Layers

```
domain          → depends on nothing (knows no framework, ORM or HTTP)
application     → depends on domain (use cases, orchestration)
infrastructure  → depends on application + domain (DB, HTTP, queues, external services)
interface       → HTTP/CLI/queue entry points
```

Reverse dependencies are **forbidden**. Business rules live in `domain` — not in a
controller, an ORM model, or SQL.

## Contract

- Response bodies and status codes match `docs/api/openapi.yaml` **exactly**
- If the contract is wrong, do not change it — escalate to `solution-architect`
- The response envelope is consistent: `{data, meta}` — it does not vary per endpoint

## Security (on every endpoint)

- **Default deny.** Authorization is written explicitly at every entry point
- **Resource ownership checks are mandatory** (IDOR) — "can this user see/modify this record"
- Input validation at the boundary (schema), business validation in the domain
- Parameterized queries — building SQL by string concatenation is **forbidden**
- No internal detail in error responses: stack traces, SQL, file paths, version info
- Secrets masked in logs: passwords, tokens, cards, identity numbers, emails (partial)
- Anywhere an external URL is accepted is protected by an allowlist (SSRF)

## Transactions and consistency

- One use case = one transaction boundary
- **Never** make an external call (HTTP, email, queue publish) inside a transaction —
  defer it
- Write operations must be idempotent: idempotency key or natural-key check
- Where races are possible, use optimistic locking (version column) or a DB constraint

## Error handling

- Error responses follow RFC 7807 `problem+json`: `{type, title, status, detail, instance, errors[]}`
- Domain errors ≠ infrastructure errors. Separate types, separate handling
- A `catch` block never swallows an error — it handles, rethrows, or logs
- Retries: only for transient errors, exponential backoff, with an upper bound

## Performance

- No N+1 queries — use batch loading or joins
- No unbounded result sets — every list is paginated with a default limit
- Expensive work is not done in a synchronous request — queue it
- Timeouts are **mandatory** on external service calls

## Data

- Time is stored in UTC and converted at the boundary (`timestamptz`)
- Money: integer minor units or decimal — `float` is **forbidden**
- Schema changes belong to `sql-developer`; do not write migrations here

## Observability

- Structured logs (JSON) with a correlation id on every line
- Log levels: ERROR (action required), WARN (attention), INFO (business event), DEBUG (development)
- Critical business events are emitted as metrics

## Tests

- At least one test per `AC-N`, with `AC-N` in the test name
- An edge-case test per business rule (`BR-N`): empty, zero, negative, maximum
- Per endpoint, whichever apply: 200/201, 400, 401, 403 (another user's resource), 404, 409
- Integration tests run against a real (ephemeral, isolated) database, not against mocks

## Prohibitions

- Adding a new library (requires an ADR)
- Hardcoded secrets, URLs or credentials
- Empty `catch (e) {}`
- Unowned `TODO`
- Commented-out code
- Duplicating a business rule in two places
