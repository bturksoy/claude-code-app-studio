---
name: test-plan
description: Produces the test strategy and a release-scoped test plan. Sets risk-based coverage, defines the test pyramid, and decides how much of each area gets tested.
---

# /test-plan [scope]

Owner: `qa-lead`. Outputs: `docs/qa/strategy.md` (once) + `docs/qa/test-plan.md` (per release)

---

## 1. Input

- `FRD.md` — the REQ heading table + priorities
- `NFR.md` — in full (performance, security and accessibility targets get tested)
- `ARCHITECTURE.md` — components and integration points
- The existing `docs/qa/strategy.md` (if present — it gets updated, not rewritten)
- Open bugs (`docs/qa/bugs/`) — an indicator of regression risk

## 2. Invoke `qa-lead`

```
<CONTEXT BLOCK>

Task: produce the test strategy and plan.

A) STRATEGY (if this is the first run)
1. Test pyramid: the target unit/integration/e2e split for this project, with rationale
2. Risk-based coverage matrix:
   | Area | Business impact | Change frequency | Complexity | Risk | Test intensity |
   Concentrate on high-risk areas; smoke tests suffice for low-risk ones.
3. Coverage thresholds (critical modules / overall)
4. Test data strategy: fixture management, fake data, anonymization
5. Environment strategy: which test runs where, isolation, parallel execution
6. What will NOT be automated and why (areas that stay manual)

B) TEST PLAN (for this release)
1. Scope: which REQs will be tested
2. Test types and who owns each:
   functional, integration, end-to-end, performance, security,
   accessibility, regression, smoke
3. End-to-end scenarios (AT MOST 8 — only journeys that touch money)
4. NFR verification: how each measurable NFR will be tested
5. Entry criteria (what must be ready before testing starts)
6. Exit criteria (what must hold to call testing finished)
7. What will not be tested, and the accepted risk

Rule: coverage percentage is an indicator, not a goal. A test without assertions is worthless.
```

## 3. Present

```
## Test Plan — <release/phase>
Pyramid: unit <a>% | integration <b>% | e2e <c>%

Risk matrix (high-risk areas)
| Area | Risk | Test intensity |

End-to-end scenarios: <N>
NFR verification: <M> NFRs → <K> tests
Not tested: <list> — accepted risk

Entry criteria: <list>
Exit criteria: <list>
```

## 4. Write

- `docs/qa/strategy.md` (create if missing, update if present)
- `docs/qa/test-plan.md`
- Write the end-to-end scenarios as skeletons under `docs/qa/test-cases/e2e/`

## 5. Close

```
✓ Test plan → docs/qa/test-plan.md
  <N> e2e scenarios | <M> NFR verifications

▶ Next: /qa-run  (run the tests)
   Note: per-story test scenarios were already written during /stories —
   this plan defines coverage at the release level.
```

---

## Token note

- **1 agent call.**
- The strategy is written once; later releases only update the test plan.
- REQs go in as headings, NFRs in full.
