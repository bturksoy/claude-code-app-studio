---
name: bug
description: Creates a bug record and triages it — priority, owner, root-cause hypothesis and regression test plan. Without arguments, prioritizes the open bugs.
---

# /bug ["<description>" | triage]

Owner: `test-engineer`, prioritization: `qa-lead` (for P0/P1).

---

## Mode A — New bug record: `/bug "<description>"`

### 1. Gather information

Ask for the gaps via `AskUserQuestion` (in a single round):
- **Where was it seen:** `Local development` / `Test environment` / `Staging` / `Production`
- **How often:** `Every time` / `Sometimes` / `Saw it once`
- **Impact:** `Data loss/security` / `Main flow broken` / `Secondary flow` / `Cosmetic`

### 2. Number and context

Find the highest number under `docs/qa/bugs/` and add 1.
Find the related REQ and story via Grep (using keywords from the bug description).

### 3. Invoke `test-engineer`

```
Bug description: <argument>
Environment: <answer> | Frequency: <answer> | Impact: <answer>
Related REQ/story: <what was found>
Related code: <the relevant section found via Grep>

Task: produce the BUG-<NNN> record.
1. A one-sentence title — the OBSERVED behaviour (not an interpretation)
2. Reproduction steps — numbered, precise, with preconditions
3. Expected vs observed
4. Root-cause hypotheses (at most 2) + how each would be confirmed
5. Scope: how many users/scenarios are affected, is there a workaround
6. Priority proposal (P0-P3) + rationale
7. Regression test: the name of the test to add after the fix and what it will assert
8. Owner proposal (which developer role)
```

### 4. `qa-lead` approval for P0/P1

```
<THE BUG RECORD>
Task: is the priority right? P0 stops the sprint — are you sure?
One line: "Priority: P<n> — <rationale>"
```

### 5. Write

`docs/qa/bugs/BUG-NNN.md` (format: the template in `.claude/templates/bug.md`)
`.state/project.json` → `counters.bugs++`

If it is P0: notify `delivery-manager` — an urgent row must be added to the current sprint plan.

---

## Mode B — Triage: `/bug triage`

### 1. Collect the open bugs

Read the ones with `Status: Open|Confirmed` under `docs/qa/bugs/` (header blocks only).

### 2. Invoke `qa-lead`

```
Open bugs:
| ID | Title | Current priority | Environment | Impact | Age |

Current sprint goal: <goal>
Remaining capacity: <information>

Task: triage.
1. Review the priorities — correct any that are wrong and justify it
2. What gets fixed this sprint (P0 + P1)
3. What goes to the backlog (P2) — for which sprint
4. What gets closed (P3, duplicate, invalid) — with rationale
5. Cluster detection: do any bugs point to the same root cause
   (if so, one fix closes several — say so)
```

### 3. Present and apply

```
## Bug Triage — <N> open bugs
P0: <a> | P1: <b> | P2: <c> | P3: <d>

This sprint: BUG-021, BUG-023
To the backlog: BUG-019, BUG-020
To be closed: BUG-015 (duplicate — same as BUG-012)

Cluster detection: BUG-021 and BUG-023 point to the same root cause
  → a single fix could close both
```

Confirm via `AskUserQuestion`, update the bug files' statuses, and notify
`delivery-manager` about the ones pulled into the sprint.

---

## Token note

- New record: **1-2 agent calls**. Triage: **1 call**.
- In triage, embed the bug files' **header blocks**, not their full contents.
- Cluster detection closes many bugs with one fix — the highest-leverage QA move.
