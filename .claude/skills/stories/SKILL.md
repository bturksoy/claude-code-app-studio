---
name: stories
description: Breaks an epic into stories. Each story is written as a self-sufficient TASK PACKET so the developer agent can implement it without opening any other file. Story types and test scenarios are assigned by the QA Lead. The heart of token optimization.
---

# /stories <epic-slug>

Owner: `business-analyst` + `qa-lead`, review: `solution-architect` (full mode).
Output: `product/backlog/epics/<slug>/story-NNN-<slug>.md`

**This skill is the most critical part of the system.** The quality of the story file
determines the token cost of every development step that follows. A good story = 1 file
read. A bad story = 8 file reads plus round-trips.

---

## 1. Load the input

Without an argument, suggest the first epic in `product/backlog/index.md` that has no stories.

Read:
- `product/backlog/epics/<slug>/EPIC.md`
- The REQs covered by the epic — **full text** from `FRD.md` (behaviour, business rules,
  acceptance criteria, error table)
- The **"Implementation guidance"** sections of the ADRs the epic lists
- The relevant `openapi.yaml` endpoint definitions
- The relevant `ER.md` table definitions
- The relevant wireframe specifications

**ADR validation:** does every ADR file listed in the epic actually exist? If not, stop:
> "The epic references ADR-NNNN but the file was not found. Run `/adr` or fix the
> reference in the epic. Stories cannot be written."

If a governing ADR has status `Proposed`, the related story is written with status `Blocked`.

## 2. Story type classification

| Type | When | Required evidence |
|---|---|---|
| **Logic** | Business rule, calculation, state transition, validation | Unit test |
| **Integration** | 2+ components, API call, queue, external service | Integration test |
| **Data** | Schema, migration, index, data transformation | Migration up/down + schema current |
| **UI** | Screen, component, form, navigation | Component test or evidence file |
| **Infra** | CI/CD, environment, IaC, monitoring | Pipeline output + written rollback |
| **Config** | Settings/data only, no new logic | Smoke record |

For mixed stories, the **highest-risk type** applies.

## 3. Invoke `business-analyst` — the breakdown

```
<EPIC INFORMATION>
<FULL TEXT OF THE REQs: behaviour, BR-*, acceptance criteria, error table>
<RELEVANT ADR IMPLEMENTATION GUIDANCE>
<RELEVANT API ENDPOINTS>
<RELEVANT TABLES>
<RELEVANT SCREEN SPECIFICATIONS>
<MODULE LIST and DEPENDENCY DIRECTION RULE>

Task: break this epic into stories.

Rules:
1. One story = work finishable in one focused session (1-3 days / 2-4 hours of focus)
2. One story = one owner = one main module. If it spans two modules, SPLIT IT.
3. Ordering: contract/schema → core behaviour → edge cases → interface → polish
4. Each acceptance criterion (AC) belongs to exactly one story — never split one
5. Assign a type to each story (Logic/Integration/Data/UI/Infra/Config)
6. Assign an owner role to each story (frontend-developer, backend-developer,
   sql-developer, devops-engineer, data-engineer, test-engineer)
7. State the dependencies: "X must finish first", "Y is waiting on this"

Give ONLY the story list first:
| # | Title | Type | Owner | REQ | AC | Depends on | Estimate |

Do not write the details yet.
```

## 4. Invoke `qa-lead` — test scenarios

After the BA's list arrives (sequential, not parallel):

```
<STORY LIST>
<RELEVANT ACCEPTANCE CRITERIA — Given/When/Then>

Task:
1. Validate the story types. Correct any that are wrong and justify it.
2. For every Logic and Integration story, produce concrete test scenario specifications:
   TC-<REQ-ID>-NN: <title>
     Given: <precondition>  When: <action>  Then: <concrete assertion>
     Edge cases: <list>  Priority: P0|P1|P2
3. For every UI story, manual verification steps:
   Setup: <how to reach this state>  Verify: <what to look for>  Pass condition: <unambiguous>
4. If an acceptance criterion is not testable, SAY SO and propose a rewritten version.

The developer will code against these scenarios — they will not invent tests from scratch.
```

## 5. `solution-architect` review (full mode)

```
<STORY LIST + module assignments>
Task: architectural fit. The ARCH-STORY gate.
- Does each story stay within one module?
- Do contract-producing stories come before consuming ones?
- Is any dependency chain longer than 3?
- Are there parallel stories that would write to the same file?
Begin your reply with "ARCH-STORY: APPROVED|CONDITIONAL|REJECTED". At most 10 lines.
```

## 6. Present to the user

```
## Story Breakdown — Epic: <name>

| # | Title | Type | Owner | REQ | Estimate | Depends on |
| 001 | ... | Data | sql-developer | REQ-X-001 | S | — |

Total: <N> stories  (Logic <a>, Integration <b>, Data <c>, UI <d>, Infra <e>)
ACs covered: <X>/<Y>
Blocked stories: <if any — with the reason>
Gate: ARCH-STORY <verdict/skipped>

⚠ Uncovered acceptance criteria: <list, if any>
```

`AskUserQuestion`: `Write the <N> stories (Recommended)` / `I want to change the breakdown` /
`Write only the first 3 for now`

## 7. Write the story files — TASK PACKET FORMAT

**The most critical section.** The story must be self-sufficient; the developer agent
must never need to open a file under `docs/`.

```markdown
# Story <NNN>: <title>

> **Epic:** <name> | **Type:** <type> | **Owner:** <agent> | **Status:** Ready
> **Estimate:** <S/M/L or hours> | **Sprint:** — | **Updated:** <date>

## What to build
<2-3 sentences. The first thing the developer reads. Concrete and technical.>

## Acceptance criteria
*Source: REQ-<ID> — COPIED here, not referenced*

- [ ] **AC-1:** <criterion text>
  - Given: <precondition>
  - When: <action>
  - Then: <observable result>
- [ ] **AC-2:** ...

## Business rules
*Source: REQ-<ID> — copied*
- **BR-1:** <rule>
- **BR-2:** <rule>

## Errors and edge cases
| Case | Expected behaviour | Message to user |
|---|---|---|

## Architecture decisions to apply
*ADR-<NNNN>: <title>*
<The ADR's "Implementation guidance" section is COPIED HERE.
The developer will not open the ADR file.>

**Required pattern:** <...>
**Forbidden pattern:** <...>

## Contract
*Relevant endpoint / table / component definitions — copied*

```yaml
POST /orders
  request: {...}
  responses: 201 {...}, 400 {...}, 409 {...}
```

```sql
-- relevant table structure
```

## Files to touch
*Identified paths — not guesses*
- `src/backend/orders/order.service.ts` — <what changes>
- `tests/backend/orders/create-order.test.ts` — new

## Out of scope
*Neighbouring stories handle these — do NOT do them here*
- Story <NNN+1>: <what>
- Story <NNN+2>: <what>

## Test scenarios
*Written by the QA Lead. Do not invent tests — code against these.*

**TC-<REQ>-01** — AC-1
- Given: <...> | When: <...> | Then: <...>
- Edge cases: <...>
- Priority: P0

## Required evidence
**Type:** <type>
**Required:** <the type's mandatory evidence, from the DoD>
**File:** `tests/<path>/<slug>.test.<ext>`
**Status:** [ ] Not yet created

## Dependencies
**Must finish first:** <story-NNN or None>
**Waiting on this:** <story-NNN or None>

## Traceability
REQ-<ID> → GOAL-<NN> | ADR-<NNNN> | Screen: <if any>
```

Also:
- Fill in the "Stories" table in `EPIC.md`
- Update the `Stories` column of the epic row in `product/backlog/index.md`
- `.state/project.json` → `counters.stories`
- `.state/gates.jsonl` → ARCH-STORY

## 8. Close

```
✓ <N> stories → product/backlog/epics/<slug>/
  Logic <a> | Integration <b> | Data <c> | UI <d>

The stories are in task-packet format — the developer agent will read one file.

▶ Next:
   /stories <next-epic>   (if another epic remains)
   /sprint-plan           (once every epic is broken down)
```

---

## Token note — why this skill is expensive but profitable

This skill **deliberately** loads a lot of context (full REQ text, ADR guidance,
contracts). It pays that cost **once** and in return turns every `/dev-task` call from
8 file reads into 1.

- 2-3 agent calls (BA → QA → [full: SA])
- Write stories **per epic**, never the whole backlog at once
- Copying is **correct** here — a deliberate exception to the SSoT rule.
  If a source changes, `/context-compact` reports the desynchronization.
