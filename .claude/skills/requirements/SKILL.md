---
name: requirements
description: Turns PRD capabilities into testable functional requirements (REQ), measurable non-functional requirements (NFR) and a data dictionary. Operates the BA-REQ and QA-TESTABLE gates.
---

# /requirements

Owner: `business-analyst`, reviewer: `qa-lead`.
Outputs: `product/requirements/{FRD.md, NFR.md, data-dictionary.md}`

Prerequisite: `product/prd/PRD.md`.

---

## 1. Determine the scope

Take the "Must" + "Should" capabilities from the PRD. **Do not include** "Could" ones —
they get written in a later phase. If there are more than 12 capabilities, ask the user:

> "There are <N> capabilities. Should we write them all at once, or start with the
> <M> in the MVP phase?"

Writing per phase is both cheaper and produces less waste.

## 2. Invoke `business-analyst`

Embed in the context block: goals, personas, the selected capability list (id + definition
+ user value), the actor/permission table, data concepts, decisions from discovery, constraints.

```
<CONTEXT BLOCK>

Task: produce the functional requirements (FRD), the NFRs and the data dictionary.

FRD rules:
- Each capability splits into 1-5 REQs. Id format: REQ-<AREA>-<NNN>
- Each REQ: source (FEAT/GOAL), priority, actor, trigger, behaviour,
  business rules (BR-N), acceptance criteria (Given/When/Then), error/edge table,
  dependencies, assumptions
- Acceptance criteria must be observable and specific. Never write an unmeasurable phrase.
- AT LEAST 2 error/edge scenarios per REQ. Never write the happy path alone.
- For every REQ that requires authorization, also state "who cannot".

NFR rules:
- Categories: performance, scale, availability, security, accessibility,
  observability, compliance, maintainability, recovery
- Each NFR has a numeric target + measurement method + source GOAL
- Do not write an unmeasurable NFR — if you cannot, skip that line and add it
  to the "OPEN QUESTION" list

Data dictionary:
- Each domain term: definition, type/format, requiredness, source, example, synonyms
- If one concept has two names, choose a canonical one

If something is ambiguous, DO NOT INVENT IT. Open an "OPEN QUESTION:" line and state
whether it is blocking.
Give only the REQ heading list first (id + title + source capability), then the details.
```

## 3. Resolve open questions

Collect the BA's `OPEN QUESTION` lines. Ask the blocking ones via `AskUserQuestion`
(4 per round, never more than 8 total).

Send the answers back to the BA **in a single message**:
```
These questions have been answered: <question → answer list>
Update the affected REQs. Return only the changed REQs, not the whole set.
```

## 4. QA-TESTABLE gate (full mode)

If `product/review-mode.txt` is `full`, invoke `qa-lead`:

```
Evaluate the following acceptance criteria for testability.
<REQ id + AC list — acceptance criteria only, not the full REQ text>

Put each criterion through: observability, determinism, boundaries,
error path, measurability.

For those that fail, propose a CONCRETE fix (the rewritten criterion text).
Begin your reply with "QA-TESTABLE: APPROVED|CONDITIONAL|REJECTED".
```

Fold the `CONDITIONAL` items into the criteria. Do not re-invoke the gate.

## 5. BA-REQ gate

Ask the `business-analyst` for a verdict. **Preferably at the end of the step-2 call** —
do not open a separate round. Append this to that prompt:

```
Finally, review your own output and end your reply with
"BA-REQ: APPROVED|CONDITIONAL|REJECTED".

Criteria:
- Is every REQ tied to a GOAL?
- Does every REQ have at least one Given/When/Then acceptance criterion?
- Is the error/edge table populated for every REQ (at least 2 scenarios)?
- Do any two requirements contradict each other?
- Is every term in the data dictionary used in at least one REQ (and vice versa)?
- Is it stated which open questions are blocking?

If CONDITIONAL, list at most 5 actionable items.
```

Skip this gate in `solo` mode.

## 6. Present and write

Print a **coverage table**:

```
## Requirements Summary
| Capability | REQ count | AC count | Priority |
|---|---|---|---|
| FEAT-01 | 4 | 11 | Must |

NFRs: <N> (<category distribution>)
Data dictionary: <N> terms
Open questions: <N> (<B> blocking)
Gates: BA-REQ <verdict> | QA-TESTABLE <verdict/skipped>

⚠ REQs not tied to a GOAL: <list, if any>
⚠ REQs without acceptance criteria: <list, if any>
```

Get approval via `AskUserQuestion`, then write the three files.

Also:
- `docs/CONTEXT.md` → fill in "Critical NFRs" (at most 5 lines)
- `.state/gates.jsonl` → gate lines
- `.state/project.json` → `phase: "design"`

## 7. Close

```
✓ Requirements written.
  FRD: <N> REQs | NFR: <M> | Data dictionary: <K> terms

▶ Next: /roadmap  (phasing)
   or straight to /architecture if the roadmap is already clear
```

---

## Token note

- **1-2 agent calls** (BA + qa-lead in full mode). They cannot run in parallel —
  QA reviews the BA's output.
- Writing per phase is the biggest saving: 12 REQs instead of 30.
- Ask open questions **in batches** and send answers back **in one message**.
- On the update round, ask the BA for **only the changed REQs**.
