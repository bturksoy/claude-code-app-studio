---
name: perf-check
description: Verifies the performance budgets. Runs load tests, compares measurements against targets, analyses bottlenecks and detects regressions. Operates the PERF-BUDGET gate.
---

# /perf-check [scope]

Owner: `performance-engineer`. No verdict without measurement.

---

## 1. Load the budgets

If `docs/qa/performance/budgets.md` does not exist, **create it first**:

Invoke `performance-engineer`:
```
NFRs: <all performance/scale-related NFRs>
Architecture: <containers, data layer>
Critical flows: <the most-used ones from the UX flows>

Task: produce the performance budget table.
| ID | Metric | Target | Condition | Tool | Source NFR |
Every budget must be measurable and contextual. Pick a measurement tool suited to
this project's stack. Also provide the test scenario skeletons.
```

## 2. Measure

Try these in order (run what exists; **report what you skipped**):

```
Load test  : scenarios under tests/performance/ (k6, artillery, locust)
Frontend   : lighthouse CI, bundle analyzer
Database   : EXPLAIN ANALYZE on critical queries
Memory/CPU : container/process metrics, if available
```

State explicitly what you could not run. Never write "it is probably fine".

## 3. Invoke `performance-engineer`

```
Budgets: <the budgets.md table>
Previous run: <the last run under docs/qa/performance/ — the comparison baseline>

THIS RUN'S MEASUREMENTS:
<the real output — do not truncate>

Not measured: <list + why>

Related code (suspect areas):
<found via Grep: N+1 patterns, queries inside loops, synchronous external calls,
 unbounded result sets>

Task: the PERF-BUDGET gate.
1. Budget comparison table: | ID | Target | Measured | Status | Previous | Change |
2. Is there a regression (a degradation since the previous run)
3. Bottleneck analysis for exceeded budgets:
   where, evidence (the measurement line), why, proposed fix, estimated gain
4. For unmeasured budgets: how to measure them (a concrete command/tool)

Rule: do not propose optimization without measurement. Apply Amdahl's law — do not
propose changes to something that takes 5% of total time.
Begin your reply with "PERF-BUDGET: APPROVED|CONDITIONAL|REJECTED".
If no measurement was taken, that is an automatic REJECTED.
```

## 4. Present

```
## Performance — <date> — <build>
Verdict: PERF-BUDGET <verdict>

| Budget | Target | Measured | Status | Previous | Change |
| PB-01 | <300ms | 245ms | ✓ | 260ms | -6% |
| PB-03 | <200KB | 340KB | ✗ | 310KB | +10% ⚠ |

Regression: <if any>
Not measured: <list>

Bottlenecks
| # | Where | Evidence | Recommendation | Estimated gain |
```

## 5. Action

For exceeded budgets, `AskUserQuestion`:
- `Fix the bottlenecks (open stories)`
- `Revisit the budget — the target was unrealistic`
- `Accept as risk`

If a fix is chosen, add it to the backlog as a story (notify `delivery-manager`).

## 6. Record

- `docs/qa/performance/run-<date>.md`
- `.state/gates.jsonl` → PERF-BUDGET
- Accepted overruns → `product/risks.md`

---

## Token note

- Measurement is **free** (Bash). The agent is invoked only for the analysis.
- If every budget passes and there is no regression, report `APPROVED` **without
  invoking an agent**.
- Embed measurement output without truncating — the analysis is only as good as the data.
