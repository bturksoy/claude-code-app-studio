# API Contract Rules

**Scope:** `docs/api/**`, `**/openapi.y*ml`, `**/*.proto`, `docs/api/events.md`

**Owner:** `solution-architect`. These files **cannot be changed unilaterally** —
frontend and backend developers consume them, they do not produce them.

---

## Path design

- Resource-oriented, plural nouns: `/orders`, `/orders/{id}`, `/orders/{id}/items`
- No verbs: `/getOrders`, `/createOrder` are **forbidden**
- Nesting depth at most 2 levels
- Lowercase, hyphen-separated: `/purchase-orders`
- If an action is genuinely not a resource, model it as a sub-resource:
  `POST /orders/{id}/cancellation`

## Status codes

| Code | When |
|---|---|
| 200 | Successful read/update |
| 201 | Creation (+ `Location` header) |
| 204 | Success, no body (deletion) |
| 400 | Malformed request |
| 401 | Not authenticated |
| 403 | Authenticated but not authorized |
| 404 | Resource missing (or unauthorized — to prevent leakage) |
| 409 | Conflict (uniqueness, state violation) |
| 422 | Structurally valid, business rule violated |
| 429 | Rate limited |
| 5xx | Server error (leaks no detail) |

Every endpoint **explicitly declares** which codes it can return.

## Error body — RFC 7807

**One shape**, defined under `components/responses`, referenced by every endpoint:

```json
{
  "type": "https://example.com/errors/insufficient-stock",
  "title": "Insufficient stock",
  "status": 409,
  "detail": "5 units requested for SKU-123, 2 available.",
  "instance": "/orders/9f3a",
  "errors": [{"field": "items[0].quantity", "message": "At most 2"}]
}
```

Internal detail (stack trace, SQL, file path) is **never** returned.

## Response envelope

Consistent, never varying per endpoint:

```json
{ "data": {...}, "meta": {...} }
```

List responses: `{"data": [...], "meta": {"cursor": "...", "hasMore": true}}`

## Pagination, sorting, filtering

- Pick **one pattern** (cursor or offset) and use it everywhere
- Default limit defined, maximum limit enforced
- Sorting: `?sort=created_at:desc` — a single format
- Filtering: `?status=paid&created_after=2026-01-01` — consistent naming
- Unbounded result sets are **forbidden**

## Authorization

- `securitySchemes` defined
- `security` specified on every endpoint
- Public endpoints explicitly declare `security: []` — so they are not mistaken for omissions

## Idempotency

Write operations must be repeatable:
- An `Idempotency-Key` header (for POST), or
- Conflict detection via a natural key (409)

## Schemas

- All schemas under `components/schemas`, no duplication
- Every field: type, format, example, requiredness, constraints (min/max/pattern/enum)
- Dates: `format: date-time` (ISO 8601, UTC)
- Money: minor-unit `integer` plus a separate `currency` field, or a decimal `string`
- Identifiers: `format: uuid` or explicitly specified

## Traceability

Every endpoint is bound to a requirement:
```yaml
paths:
  /orders:
    post:
      x-requirement: REQ-ORD-003
```

## Versioning and change

| Change | Breaking? | Allowed |
|---|---|---|
| New optional field (response) | No | ✓ |
| New optional parameter | No | ✓ |
| New endpoint | No | ✓ |
| Removing a field | **Yes** | New version + migration |
| Renaming a field | **Yes** | New version + migration |
| Changing a type | **Yes** | New version + migration |
| Adding a required parameter | **Yes** | New version + migration |
| Changing a status code | **Yes** | New version + migration |

A breaking change requires: a new version, a dual-publish period, a deprecation notice,
and a migration guide. The versioning strategy is recorded in an ADR.

## Event contracts (`docs/api/events.md`)

- Every event: name, version, publisher, trigger, key, ordering guarantee, field table
- Removing or renaming fields is **forbidden** — add new fields and deprecate old ones
- `event_id` for deduplication and `occurred_at` for time are mandatory
- Delivery semantics stated (at-least-once → consumers must be idempotent)

## Prohibitions

- A developer changing the contract unilaterally
- Two different schema names for the same concept
- An endpoint-specific error format
- Returning undocumented fields
- Silent divergence between the contract and the implementation
