---
name: prd
description: Produces the Product Requirements Document (PRD). Turns the discovery output into a structured, prioritized and measurable product definition. Operates the PO-SCOPE gate.
---

# /prd

Owner: `product-owner`. Output: `product/prd/PRD.md`.

Prerequisite: `product/discovery.md` (if missing, suggest `/discovery` and stop).
If there are blocking open questions, resolve them first.

---

## 1. Prepare the input

Read `product/00-brief.md` + `product/discovery.md`. Context block (≤ 60 lines):
goals, personas, capability list (MoSCoW), decisions made, out of scope.

## 2. Invoke `product-owner`

```
<CONTEXT BLOCK>

Task: produce the PRD. Sections:

1. Summary — 3 sentences: what, for whom, why now
2. Goals and metrics — GOAL table, each bound to an in-product measurement event
3. Personas — from discovery, condensed
4. Scope
   4.1 Capabilities: each gets a FEAT-NN id
       | ID | Capability | User value | Priority | GOAL | Phase |
   4.2 User journeys: one end-to-end scenario per persona
   4.3 Out of scope: item + why + when it will be revisited
5. Assumptions and dependencies
6. Constraints (technical, legal, commercial, schedule)
7. Risks — probability/impact/mitigation
8. Open questions — owner and whether blocking

Rules:
- Every "Must" capability must map to a GOAL. If it cannot, lower its priority.
- Do not write technical solutions (which database, which framework) — that is architecture's job.
- Do not design screens — that is UX's job.
- Express each capability in one sentence of user value.
- Give a draft phasing but leave the detail to /roadmap.

Then begin your reply with "PO-SCOPE: APPROVED|CONDITIONAL|REJECTED" and evaluate:
- Is the MVP scope something one team can finish in a reasonable time?
- Is the "Won't" list populated?
- Are the metrics measurable?
- Is the riskiest assumption tested in the first phase?
```

## 3. Handle the gate

Read `product/review-mode.txt`:
- `solo` → skip PO-SCOPE, note it
- `lean` / `full` → process the verdict

| Verdict | Action |
|---|---|
| `APPROVED` | Continue |
| `CONDITIONAL` | Show the items to the user, fold the fixes into the PRD, **do not re-invoke the gate** |
| `REJECTED` | Show the user why, suggest `/discovery` or narrowing scope, stop |

## 4. Present and get approval

Print a **summary** on screen (never the full PRD):

```
## PRD Summary
Capabilities: <N> (Must: <a>, Should: <b>, Could: <c>, Won't: <d>)

MVP (Phase 1)
  FEAT-01 <name> → GOAL-01
  ...

Deferred to later phases: <N> capabilities
Open questions: <N> (<B> blocking)
Gate: PO-SCOPE <verdict>
```

`AskUserQuestion`: `Write the PRD (Recommended)` / `I want to narrow the scope` /
`I want to add a capability`

## 5. Write and update

- `product/prd/PRD.md`
- `docs/CONTEXT.md` → update "What we are building" from the PRD summary
- `.state/project.json` → `phase` stays `discovery`, counters unchanged
- `.state/gates.jsonl` → append the PO-SCOPE line
- Open questions are synced into the table in `product/discovery.md` (one home only)

## 6. Close

```
✓ PRD written → product/prd/PRD.md
  <N> capabilities | MVP: <M> capabilities | Gate: PO-SCOPE <verdict>

▶ Next: /requirements
   The Business Analyst will turn each capability into testable requirements.
```

---

## Token note

- **1 agent call.** The PO both writes the PRD and issues the gate verdict — do not split them.
- Context block ≤ 60 lines; do not embed all of discovery.md.
- Never print the PRD on screen — write the file, show the summary.
