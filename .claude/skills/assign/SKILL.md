---
name: assign
description: Routes a story to the right agent. Runs a readiness check, detects missing context and completes the story if needed. A preparation step before /dev-task.
---

# /assign <story-path>

Owner: `delivery-manager`. Runs without invoking agents (unless the story is incomplete).

---

## 1. Read the story and determine the owner

If the `Owner` field is filled, use it. If empty, derive it from the type and content:

| Signal | Owner |
|---|---|
| Screen, component, form, route, CSS | `frontend-developer` |
| Endpoint, service, business rule, integration | `backend-developer` |
| Table, migration, index, query | `sql-developer` |
| Pipeline, environment, IaC, monitoring, deploy | `devops-engineer` |
| ETL, report, event schema | `data-engineer` |
| Test case, automation, regression | `test-engineer` |
| Screen flow, IA, wireframe | `ux-designer` |
| Token, component spec | `ui-designer` |

**If more than one signal is present, the story must be split** — report this:
```
⚠ story-007 contains both backend and frontend work.
   Suggestion: split into two stories → re-run /stories <epic>
   or: split at the contract boundary (BE first, FE second)
```

## 2. Readiness check

```
[ ] Is the status "Ready" (not Blocked)
[ ] Are the stories it depends on DONE
[ ] Are the acceptance criteria in Given/When/Then form
[ ] Is "Architecture decisions to apply" filled in (or a justified N/A)
[ ] Is the "Contract" section filled in (for types that need API/data)
[ ] Is there a "Files to touch" list
[ ] Is "Test scenarios" filled in (for Logic/Integration)
[ ] Is the "Out of scope" section filled in
```

## 3. Fill the gaps

If something is missing, **find the source and copy it into the story** (no agent needed):

| Missing | Source |
|---|---|
| Acceptance criteria | `FRD.md` → the relevant REQ |
| ADR implementation guidance | `adr/ADR-NNNN-*.md` → the "Implementation guidance" section |
| Contract | The relevant endpoint in `openapi.yaml` / the relevant table in `ER.md` |
| Files to touch | Identify them via Grep in the relevant module |
| Test scenarios | If missing, invoke `qa-lead` (only if this is the sole gap) |

This step **completes the task packet** and lowers the cost of `/dev-task`.

## 4. Present

```
## Task Assignment

Story <NNN>: <title>
Owner: <agent>   Type: <type>   Estimate: <size>

Readiness: <a>/<b> ✓
Gaps filled:
  ✓ Contract added (openapi.yaml → POST /orders)
  ✓ ADR-0007 implementation guidance copied
  ✓ Files to touch identified (<n> files)

Remaining gaps: <if any>

Dependencies: <status>

▶ Ready: /dev-task <path>
```

## 5. If blocked

```
⚠ Story blocked: <reason>
   Depends on: story-003 (status: In progress)

   What you can do now:
     /dev-task <path to an independent story>
```

---

## Token note

- **Usually 0 agent calls** — just file reads and copying.
- This skill exists to lower the cost of `/dev-task`: an incomplete task packet means the
  developer agent has to search, which costs 3-5× more.
- Can be run in bulk for every story at the start of a sprint.
