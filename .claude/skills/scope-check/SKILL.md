---
name: scope-check
description: Detects scope creep. Compares the current backlog against the original goals, finds work not tied to a goal, and produces cut recommendations.
---

# /scope-check

Owner: `product-owner`. When: before sprint planning, under schedule pressure, or when
a new request arrives.

---

## 1. Traceability audit (free)

Check the chain: `story → REQ → GOAL`

Collect with Grep:
- The `Traceability` lines of every story
- The REQ → GOAL mappings in `FRD.md`
- The GOAL list in `00-brief.md`

Find the breaks:
```
⚠ REQs not tied to a GOAL: <list>
⚠ Stories not tied to a REQ: <list>
⚠ REQs not covered by any story: <list>
⚠ Anything from the "not in the MVP" list that has entered the backlog: <list>
```

## 2. Growth measurement (free)

```
Original PRD capability count : <N>   (from the first version of the PRD)
Current backlog story count   : <M>
REQs in the phase scope       : <K>   (from the roadmap)
Added to the backlog since    : <L>   (scope changes in DECISIONS.md)
```

## 3. Invoke `product-owner` (if there are breaks or growth)

```
Original goals: <GOAL list>
Not in the MVP (original): <list>

Traceability breaks:
<the list above>

Growth: PRD <N> capabilities → backlog <M> stories (phase scope <K> REQs)
Added later: <list + date + rationale>

Current sprint capacity: <information>

Task: a scope audit.
1. Is the disconnected work actually needed? For each: KEEP / CUT / DEFER + rationale
2. Is anything violating the "Won't" list
3. Is the growth justified? (legitimate expansion from learning vs indiscipline)
4. Cut order: if the schedule tightens, which work is removed IN WHAT ORDER
   For each cut: which GOAL suffers, and how much
5. Minimum valuable release: which <n> stories from today's backlog would
   produce a shippable product
```

## 4. Present

```
## Scope Audit

Growth: <N> → <M>  (<increase>%)
Traceability: <a> broken links

Disconnected work
| Story/REQ | Not tied to | Recommendation | Rationale |
| story-012 | no GOAL | CUT | Serves no goal |

"Won't" violations: <list>

Cut order (if the schedule tightens)
1. <story> — GOAL-02 partially affected
2. <story> — no impact

Minimum valuable release: <n> stories
  <list>
```

`AskUserQuestion`:
- `Apply the recommended cuts (Recommended)`
- `Cut only the disconnected work`
- `Cut nothing — I will increase capacity`
- `Narrow down to the minimum valuable release`

## 5. Apply

Cut stories are **not deleted** — they move under `product/backlog/deferred/`, their
status becomes `Deferred`, and the rationale is recorded.
Decisions are appended to `docs/DECISIONS.md`.

---

## Token note

- The traceability audit and growth measurement are **free**.
- If there are no breaks and growth is under 20%, report a clean result **without
  invoking an agent**.
- **1 agent call** (only when needed).
