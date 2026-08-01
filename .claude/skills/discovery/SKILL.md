---
name: discovery
description: Runs the Product Owner and Business Analyst in parallel to flesh out the project. Looks through two different lenses, separates agreement from contradiction, and presents contradictions to the user as decisions. A mandatory step before the PRD.
---

# /discovery

The first step of Phase 1 — where the **PO and BA put their heads together**.
Output: `product/discovery.md` plus a clarified scope and an open-questions list.

Prerequisite: `product/00-brief.md` must exist. If not, suggest `/kickoff` and stop.

---

## 1. Prepare the input

Read `product/00-brief.md`. Build this **context block** (both agents receive an
identical copy — do not have them read files, embed the content):

```
PROJECT: <name> — <one sentence>
GOALS: GOAL-01 <...> | GOAL-02 <...>
USER: <persona summary>
CONSTRAINT: <critical constraint>
NOT IN MVP: <list>
RISKY ASSUMPTIONS: <list>
```

## 2. Parallel round-table (two Agent calls in one message)

The two agents receive **the same context through different lenses** and **cannot see
each other**. This is deliberate — it prevents groupthink.

### Call A — `product-owner`

```
<CONTEXT BLOCK>

Lens: VALUE and PRIORITY.

Produce:
1. Problem statement — whose pain, in what situation, what it costs them.
   Mark each claim as evidence or assumption.
2. At most 3 personas: role, goal, how they solve it today, why that is inadequate.
3. Capability list: things the user must be able to do.
   Each with MoSCoW: Must / Should / Could / Won't.
   Every "Must" must map to a GOAL — if it cannot, move it to "Won't".
4. Minimum usable product: which 3-5 capabilities, without which this product is pointless?
5. Competition/alternatives: what does the user use today, why are we better?
6. Measurement: for each GOAL, which in-product event will be measured.

Write short and in bullets. If something is unclear, open a "QUESTION:" line; do not assume.
```

### Call B — `business-analyst`

```
<CONTEXT BLOCK>

Lens: GAPS, CONTRADICTIONS and AMBIGUITY.

Produce:
1. Could two different systems be built from this definition? Where? (ambiguity list)
2. Actors and permissions: who exists, who can do what, who cannot.
3. Main business processes: end-to-end flows (Mermaid). Mark every decision point.
4. Data concepts: which entities exist, their relationships, ownership.
   Catch any concept that has been given two names.
5. Unasked questions — at least 10. Example categories:
   permissions/roles, multi-user, concurrency, deletion/archiving, historical data,
   notifications, offline, currency/tax/localization, files/attachments,
   external system integration, audit trail, data retention.
6. Missed edge cases: empty, too many, concurrent, undo, failure.

Write short and in bullets. Do not decide — make the ambiguity visible.
```

## 3. Synthesis (you do this — invoke no agents)

Compare the two outputs and sort into three buckets:

**AGREEMENT** — what both saw the same way. Goes straight into the document.

**CONTRADICTION** — one says X, the other implies Y. For each:
```
C-N: <topic>
  PO view: <...>
  BA view / implication: <...>
  Why it matters: <which decision it affects>
  Options: A) <...>  B) <...>
```

**OPEN QUESTION** — what neither knows; information that must come from the user.
Mark the blocking ones (these must be answered before `/requirements` can run).

## 4. Present to the user

First write the synthesis in prose (the three headings above).

Then collect **decisions** via `AskUserQuestion`. Rules:
- At most 4 questions per call
- Blocking contradictions first, then open questions
- Each option states its consequence in one sentence
- The recommended option comes first, labelled "(Recommended)"
- If there are more than 4, do a second round; but never exceed 8 in total —
  the rest are asked during `/requirements`

## 5. Write the file

After approval, `product/discovery.md`:

```markdown
# Discovery — <project>
**Date:** <today> | **Participants:** product-owner, business-analyst

## Problem
<the agreed definition> (evidence: <yes/assumption>)

## Personas
### <name> — <role>
Goal: | How they solve it today: | Pain point: | Success:

## Capabilities (MoSCoW)
| # | Capability | Priority | GOAL | Note |

## Minimum usable product
<3-5 capabilities>

## Actors and permissions
| Actor | Can | Cannot |

## Main processes
<Mermaid flows>

## Data concepts
| Concept | Definition | Related to | Owner |

## Decisions made
| # | Topic | Options | Decision | Rationale |

## Open questions
| # | Question | Blocking? | Owner | Status |

## Out of scope (clarified this round)
- <item> — <why>
```

Also:
- Append the decisions to `docs/DECISIONS.md` as single lines
- Update the "What we are building" and "Deliberately out of scope" sections of `docs/CONTEXT.md`
- `.state/project.json` → `phase: "discovery"` (unchanged; the next step is the PRD)

## 6. Close

```
✓ Discovery complete.
  <N> capabilities | <M> decisions made | <K> open questions (<B> blocking)

<if blocking:>
⚠ Requirements cannot be written until these are answered:
  - <question>

▶ Next: /prd
```

---

## Token note

- **2 agent calls** (parallel, single message). No second round.
- The synthesis is done by the model, not delegated to an agent.
- The context block is ≤ 40 lines. Do not embed the entire brief.
- Ask user questions in batches; never open a round per question.
