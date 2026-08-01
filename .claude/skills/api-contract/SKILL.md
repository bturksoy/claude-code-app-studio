---
name: api-contract
description: Produces or updates the OpenAPI contract. Endpoints, schemas, error format, pagination and authorization are defined in one place. Frontend and backend consume this contract and cannot change it.
---

# /api-contract [scope]

Owner: `solution-architect`. Output: `docs/api/openapi.yaml`

Prerequisite: `ARCHITECTURE.md` + `FRD.md`. Without a scope argument, use the Phase 1 REQs.

---

## 1. Determine the scope

Argument: an epic slug, a REQ list, or empty (→ the current phase).
If `openapi.yaml` already exists, read it — this is an **addition**, not a rewrite.

## 2. Invoke `solution-architect`

```
Existing contract: <if any, the endpoint list — path+method+summary only, not the full YAML>
Scope: <REQ list — id + title + actor + behaviour summary>
Architecture: <relevant container and layer information>
Relevant ADRs: <implementation guidance summaries — auth, versioning, error format>
Data model: <relevant entities and their fields — from ER.md>

Task: produce an OpenAPI 3.1 contract.

Mandatory rules:
1. Every endpoint carries an `x-requirement: REQ-*` tag
2. Resource-oriented paths: /orders, /orders/{id}, /orders/{id}/items
   No verbs (/getOrders is forbidden)
3. Status codes: 200/201/204, 400, 401, 403, 404, 409, 422, 429, 500
   Declare which ones are valid on each endpoint
4. ONE error shape — RFC 7807:
   {type, title, status, detail, instance, errors[]}
   Define it under components/responses; every endpoint references it
5. ONE pagination pattern: cursor or offset — pick one and use it everywhere
   Response envelope: {data: [...], meta: {...}}
6. Filtering and sorting parameters are named consistently
7. Authentication: securitySchemes defined, `security` specified on every endpoint
   Public endpoints explicitly declare `security: []`
8. An idempotency header for write operations (where applicable)
9. All schemas under components/schemas, no duplication
10. Every field: type, format, example, requiredness, constraints (min/max/pattern)
11. If you are making a breaking change, SAY SO and propose a migration plan

Output valid YAML. Explain the REQ mapping with comments.
```

## 3. Consistency audit (you do this, no agent)

Check the produced contract against these:
- Is every REQ covered → produce a **coverage table**
- Is the error format identical on every endpoint
- Is the pagination pattern consistent
- Is authorization defined on every endpoint
- Does the same concept appear under two different schema names
- Do field names match `ER.md` (on a mismatch, **the data dictionary wins**)

If there are gaps, send one short correction round.

## 4. Present

```
## API Contract
| REQ | Endpoint | Method | Auth | Status codes |

New: <N> endpoints | Changed: <M> | Breaking change: <yes/no>
⚠ Uncovered REQs: <if any>
```

If there is a breaking change, get explicit approval via `AskUserQuestion` and show the
migration plan.

## 5. Write and notify

- `docs/api/openapi.yaml`
- One line summarizing the change in `docs/DECISIONS.md`
- **Notification:** if the contract changed, open stories owned by `frontend-developer`
  and `backend-developer` are affected — list them in the report

## 6. Close

```
✓ Contract updated → docs/api/openapi.yaml
  <N> endpoints | REQs covered: <M>

▶ Next: /data-model (if not done) or /epics
```

---

## Token note

- **1 agent call** + at most 1 correction round.
- Do not embed the whole existing YAML — a `path + method + summary` list is enough.
- The consistency audit is done by the model; do not spawn a separate review agent.
