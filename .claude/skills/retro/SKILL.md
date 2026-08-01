---
name: retro
description: Runs a sprint or release retrospective. Produces what went well, what did not, root causes and owned action items. Where process improvement happens.
---

# /retro [sprint | release | "<incident>"]

Owner: `delivery-manager`.

---

## 1. Gather the data (free — the value of a retro lies in real numbers)

| Data | Source |
|---|---|
| Planned vs completed stories | The sprint file + story statuses |
| Estimate vs actual | Story estimates + completion order |
| Blocking events and their duration | Notes in the sprint file |
| Bugs opened/closed | `docs/qa/bugs/` |
| Gate verdicts | `.state/gates.jsonl` — how many REJECTED, how many CONDITIONAL |
| Agent call count | `.state/agent-log.jsonl` |
| Scope changes | `docs/DECISIONS.md` |
| Risks that materialized | `product/risks.md` |

## 2. Invoke `delivery-manager`

```
Sprint/Release: <NN>
Goal: <sprint goal>

DATA:
Planned stories: <N> | Completed: <M> | Carried over: <K>
Estimate variance: <per-story list>
Blocking events: <cause + duration>
Bugs: opened <a>, closed <b>, escaped to production <c>
Gate verdicts: APPROVED <x>, CONDITIONAL <y>, REJECTED <z>
  Which were REJECTED: <which gate, which story>
Agent calls: <N> | Gates: <M>
Scope changes: <list>
Risks that materialized: <list>

Task: run the retrospective.

1. Was the sprint goal met? If not, what is the actual reason?
   (Look for a root cause, not a symptom — "we ran out of time" is not a reason)
2. Three things that went well — the REPEATABLE ones (not luck)
3. Three things that went badly — drive each to a root cause with "5 whys"
4. Estimate accuracy: is there a systematic bias, and in which story types
5. Quality signals: do the REJECTED gates point to a pattern
6. Process cost: is the agent call count reasonable, where is the waste
   (>30 calls/sprint = a task-packet quality problem)
7. Action items — AT MOST 3, each:
   concrete, owned, measurable, verifiable in the next sprint
   ("let's be more careful" is not an action)

Were the previous retro's actions applied? If not, why?
```

## 3. Present

```
## Retrospective — Sprint <NN>
Goal: <goal> → <met/not met>

Numbers
  Stories: <M>/<N> completed | Carried over: <K>
  Estimate variance: <average %>
  Bugs: <a> opened, <b> closed, <c> escaped to production
  Gates: APPROVED <x> | CONDITIONAL <y> | REJECTED <z>
  Agent calls: <N> (target <30)

Went well (repeatable)
  - <item> — why it worked: <...>

Went badly (with root cause)
  - Symptom: <...> → Root cause: <...>

Actions (next sprint)
  | # | Action | Owner | How it will be verified |

Previous retro actions: <applied>/<total>
```

## 4. Write

- `product/sprints/retro-<NN>.md`
- **Carry** the action items into the next sprint file (so they are not forgotten)
- If an action is about process, propose a change to the relevant `.claude/` file
  (e.g. adding a field to the story template) — ask the user
- `docs/CONTEXT.md` → update "Known debt and risks"

## 5. Close

```
✓ Retro → product/sprints/retro-<NN>.md
  <N> action items with owners

▶ Next: /sprint-plan  (the actions have been carried into the new sprint)
```

---

## Token note

- **1 agent call.** Data gathering is free.
- A retro's value is in **real numbers** — extract them from files, never from memory.
- At most 3 actions: make them applicable, not a list.
