---
name: architecture
description: Determines the system architecture and technology stack. The Solution Architect designs, the CTO approves. Produces component boundaries, data flow, NFR mechanisms and initial ADRs. Operates the CTO-STACK and ARCH-DESIGN gates.
---

# /architecture

Owner: `solution-architect`, approval: `cto`.
Outputs: `docs/architecture/ARCHITECTURE.md`, `TECH-STRATEGY.md`, initial ADRs.

Prerequisite: `product/requirements/FRD.md` + `NFR.md`

---

## 1. Prepare the input

Context block:
- Project description, scale, critical constraint (from `docs/CONTEXT.md`)
- REQ heading table (Phase 1 scope — not the full text)
- **All NFRs** (these drive the architecture; embed them in full)
- Any known user preferences (from `docs/DECISIONS.md`)

Also ask the user via `AskUserQuestion` (this largely determines the architecture):

**Question 1 — Technology preference**
`Use the stack I know (I'll specify)` / `You recommend (Recommended)` /
`Must be compatible with an existing system`

**Question 2 — Hosting**
`Cloud (managed services)` / `My own server / VPS` / `On-premises` / `Not decided yet`

**Question 3 — Expected scale (first year)**
`< 100 users` / `100 - 10,000` / `10,000+` / `Unknown`

## 2. `solution-architect` and `cto` — parallel call

These two are invoked **in parallel in the same message**; they answer different questions.

### Call A — `solution-architect`

```
<CONTEXT BLOCK + user answers>

Task: produce the architecture design.

1. Context diagram (C4-1): system, actors, external systems — Mermaid
2. Containers (C4-2): responsibility + NFRs satisfied for each
3. Component boundaries and the dependency direction rule
4. Data flow for critical scenarios (at most 3 sequence diagrams)
5. Cross-cutting concerns: identity/authorization, error handling, logging,
   configuration, caching, transaction boundaries
6. NFR mechanism table: | NFR | mechanism | verification method |
   EVERY NFR gets a row. If there is no mechanism, write "OPEN".
7. What we deliberately did not do (eliminated approaches + why)
8. List of decisions that require an ADR (title + why an ADR is needed)

Rule: the simplest thing that works. Choices like distributed systems, microservices
or event sourcing must rest on a concrete NFR — if they do not, do not propose them.
Do not begin your reply with "ARCH-DESIGN: ..." — this is the first, design round.
```

### Call B — `cto`

```
<CONTEXT BLOCK + user answers>

Task: determine the technology stack and produce the TECH-STRATEGY content.

1. Layer-by-layer stack proposal (frontend, backend, database, infrastructure, CI,
   monitoring). For each choice: why this, which alternative was eliminated, exit cost.
2. Allowed / disallowed technology policy
3. Dependency policy: when a library is added, and the criteria
4. Technical debt stance: what we will not pay for now, and when we will
5. Operating cost estimate (rough: low/medium/high + monthly order of magnitude)
6. What this stack will prevent us from doing six months from now

Rule: boring and mature > new and exciting. What the team knows > theoretically best.
Minimize the number of moving parts.
Begin your reply with "CTO-STACK: APPROVED|CONDITIONAL|REJECTED".
```

## 3. Conflict check (you do this)

If the two outputs are inconsistent (the architecture assumes X, the CTO chose Y),
make the conflict **visible** and resolve it via `AskUserQuestion`. Do not ask the
agents again.

## 4. NFR gap audit

For the `ARCH-DESIGN` verdict, **you** check the NFR mechanism table:
- Any NFR whose mechanism is `OPEN` → list them
- Any NFR without a verification method → list them

If there are gaps, send `solution-architect` **one short** second round:
```
The architectural mechanism is missing for these NFRs: <list>
Fill in only those rows. Do not rewrite the whole architecture.
Then give "ARCH-DESIGN: APPROVED|CONDITIONAL|REJECTED".
```

## 5. Present

```
## Architecture Summary
Approach: <one sentence — e.g. "Single service (modular monolith) + PostgreSQL + SPA">

Stack
| Layer | Choice | Why | Eliminated alternative |

Containers
| Name | Responsibility | NFR |

NFR mechanisms: <N>/<M> covered  ⚠ Open: <list>

ADRs required: <title list>

Gates: CTO-STACK <verdict> | ARCH-DESIGN <verdict>
```

`AskUserQuestion`: `Approve and write (Recommended)` / `I want to change the stack` /
`I want a simpler architecture`

## 6. Write

- `docs/architecture/ARCHITECTURE.md`
- `docs/architecture/TECH-STRATEGY.md`
- `docs/architecture/adr/index.md` — the list of required ADRs (not yet written,
  status `Proposed`)
- `docs/CONTEXT.md` → fill in the "Technology stack" table
- `.state/project.json` → the `stack` field + `phase: "design"`
- `.state/gates.jsonl` → two gate lines
- `docs/DECISIONS.md` → the stack decision as one line

## 7. Close

```
✓ Architecture determined.
  Stack: <summary> | ADRs required: <N> decisions

▶ Next steps (in order):
   /adr "<first critical decision>"  — record the critical decisions
   /data-model                        — ER + schema
   /api-contract                      — OpenAPI contract
   /ux-flow                           — user flows  (can run in parallel)
```

---

## Token note

- **2 parallel agent calls** + at most 1 short correction round.
- NFRs are embedded in full (they drive the architecture); REQs only as headings.
- Conflict resolution is done by the model — do not spawn a third agent.
- Do not write all the ADRs here — only produce the list. `/adr` writes them one by one.
