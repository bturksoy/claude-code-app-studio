---
name: estimate
description: Produces effort estimates for an epic or story list. States the uncertainty band, the assumptions, and the factors that inflate the estimate.
---

# /estimate [scope]

Owner: `delivery-manager`. Scope: an epic slug, a story list, or empty (→ the current backlog).

---

## 1. Input

Story/epic header blocks + type + dependencies + modules touched.
If historical data exists (estimate vs actual for completed stories), **embed it too** —
it is the most valuable input for calibration.

## 2. Invoke `delivery-manager`

```
Scope: <epic/story list>
| # | Title | Type | Owner | AC count | Depends on | Modules |

Historical calibration (if available):
| Story | Estimate | Actual | Variance |

Project context: <stack, roster, current code maturity>

Task: produce effort estimates.

1. A t-shirt size per story (XS/S/M/L/XL) with rationale
   XS: <2 hours | S: half a day | M: 1 day | L: 2-3 days | XL: must be split
2. For anything that comes out XL, propose a SPLIT — XL is not an estimate, it is a warning
3. Uncertainty level per story: Low/Medium/High + why
   High uncertainty → propose a spike first (a timeboxed investigation)
4. Totals: optimistic / realistic / pessimistic band
5. Factors that inflate the estimate: dependency waits, integration surprises,
   unknown third parties, test data preparation
6. Calibration note: is there a systematic bias in the historical data

Rule: never give a single number, give a BAND. Do not hide uncertainty.
```

## 3. Present

```
## Effort Estimate — <scope>

| Story | Type | Size | Uncertainty | Note |
| 004 | Logic | M | Low | — |
| 007 | Integration | XL | High | ⚠ Must be split — third-party integration |

Totals
  Optimistic:  <N> days
  Realistic:   <M> days    ← use this for planning
  Pessimistic: <K> days

Spikes recommended: <list> — <timebox>
Must be split: <list>

Inflating factors
  - <factor> → <impact>

Calibration: historical estimates have run <n>% <low/high> on average
  → add/subtract <n>% from this estimate
```

## 4. Record

Update the `**Estimate:**` fields in the story files.
For anything needing a spike, suggest adding a spike story to the backlog.

---

## Token note

- **1 agent call.**
- Embed the story header blocks, not their full contents.
- Historical calibration data improves estimate quality the most — do not skip it.
