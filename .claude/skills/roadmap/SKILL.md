---
name: roadmap
description: Splits the project into phases that each deliver value independently, assigns scope and exit criteria to each, and produces the release plan. The phasing step — decides which requirement ships in which release.
---

# /roadmap

Owner: `product-owner`, consulted: `delivery-manager`.
Outputs: `product/roadmap/ROADMAP.md` + `product/roadmap/phases/phase-N.md`

Prerequisite: `product/requirements/FRD.md`

---

## 1. Input

Extract **only the REQ heading table** from the FRD (id, title, priority, source GOAL,
dependencies). Do not embed the full requirement text — it is unnecessary for this step.

From the NFRs, take only those that affect phasing (scale, security, compliance).

## 2. Phasing principles (give these to the agent)

1. **Every phase is independently shippable and delivers value.** "Backend phase first"
   is not a phase — nobody can use it.
2. **Phase 1 tests the riskiest assumption.** Pull the most uncertain thing forward,
   not the easiest.
3. **Phase size:** 1-3 sprints. Split anything larger.
4. **Dependencies point forward.** Phase 2 may use Phase 1; never the reverse.
5. **Every phase has a measurable exit criterion.** Not "when it's finished", but
   "when this metric reaches this value".
6. **Technical foundation work is distributed across phases**, never a separate
   "infrastructure phase" — but Phase 1 must contain a **walking skeleton**.

## 3. Invoke `product-owner`

```
<REQ TABLE> + <GOAL list> + <critical NFRs> + <constraints>

Task: produce the roadmap.

1. Phases (at most 4). For each:
   - Name and a one-sentence hypothesis ("If we ship this phase we will learn/enable X")
   - Scope: REQ-* list
   - Exit criterion: measurable (which GOAL metric, which value)
   - NOT doing in this phase: list
   - Walking skeleton: for Phase 1, what is the thinnest end-to-end working slice?
2. Phase dependency graph (Mermaid)
3. Release mapping: which phase maps to which version (v0.1, v1.0, ...)
4. For each phase, the biggest risk and its early-warning signal
5. Cut order: if the schedule tightens, which REQs get removed and in what order

Rule: every REQ must be assigned to exactly one phase. List any unassigned REQ and
ask "is this out of scope?".
```

## 4. Reality check with `delivery-manager` (lean+ mode)

Cannot be called in parallel (it reviews the PO's output). After the PO responds:

```
<PHASE TABLE — with scope and REQ counts>

Task: is this phasing deliverable?
1. A rough sprint estimate per phase (t-shirt: S/M/L + rationale)
2. Dependency problems: is there a chain inside a phase that waits on itself
3. Any work that cannot proceed concurrently (same file/module)
4. Critical path: which REQs shift the whole plan if delayed
5. The 3 biggest delivery risks

Be brief. Begin your reply with "DM-PLAN: APPROVED|CONDITIONAL|REJECTED".
```

Skip this step in `solo` mode.

## 5. Present

```
## Roadmap

Phase 1 — <name>  (v0.1, ~<N> sprints)
  Hypothesis: <...>
  Scope: <N> REQs — <id list>
  Exit: <measurable criterion>
  Not doing: <list>

Phase 2 — ...

Unassigned REQs: <list, if any> ⚠
Delivery risk: <the DM's top 3>
Cut order: <what goes first if the schedule tightens>
```

`AskUserQuestion`: `Approve and write (Recommended)` / `I want to narrow Phase 1` /
`I want to reorder the phases`

## 6. Write

- `product/roadmap/ROADMAP.md` — top-level table + dependency graph + cut order
- `product/roadmap/phases/phase-N.md` — detail per phase
- `docs/CONTEXT.md` → update "Release target"
- `.state/project.json` → `phase: "design"`, `.state/gates.jsonl` → DM-PLAN

## 7. Close

```
✓ Roadmap: <N> phases, <M> releases
  Phase 1: <name> — <K> REQs

▶ Next: /architecture
   The architecture and stack will be determined for the Phase 1 scope.
```

---

## Token note

- The REQ **heading table** is embedded, not the full text. That is the biggest saving here.
- One agent call in `solo` mode; two (sequential) in `lean+`.
- The detail of later phases is **not written now** — `/requirements` and `/epics`
  run again when those phases arrive.
