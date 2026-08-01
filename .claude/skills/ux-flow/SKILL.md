---
name: ux-flow
description: Produces user flows, information architecture and wireframe specifications. Translates requirements into the language of screens and interactions. Operates the UX-FLOW gate.
---

# /ux-flow [scope]

Owner: `ux-designer`. Outputs: files under `docs/design/ux/`.

Prerequisite: `product/requirements/FRD.md`. Without a scope, use the current phase's REQs.

---

## 1. Input

Context block:
- Personas (from `product/discovery.md` or `PRD.md`)
- REQ list: id, title, actor, behaviour summary, **acceptance criteria**
  (the criteria determine screen behaviour — embed them in full)
- Usability-related NFRs
- Platform information (web/mobile, target devices)

## 2. Invoke `ux-designer`

```
<CONTEXT BLOCK>

Task: produce the UX design.

1. Information architecture — sections, hierarchy, navigation model (Mermaid)
   Naming must be in the user's language, not the system's.
2. Critical flows (at most 6) — for each:
   happy path steps, alternative paths, error cases,
   usability criteria (step-count target, reversibility)
3. Screen inventory — DERIVE it from the flows; do not invent screens:
   | Screen | Route | Purpose | REQs satisfied | Priority |
4. A wireframe specification per screen (text, not visuals):
   layout, states (empty/loading/error/unauthorized), interactions,
   accessibility (tab order, focus management, screen reader),
   responsiveness (mobile/tablet/desktop differences)
5. REQ coverage table: which screen(s) satisfy each REQ
   EXPLICITLY list any REQ that is not covered.

Rules:
- Reduce step count, not screen count
- Every screen must define its empty state
- An error message must say what to do — "An error occurred" is forbidden
- Accessibility is not bolted on; it is part of the specification
- Do not choose colours/fonts — that is the ui-designer's job

Give the screen inventory first, then the wireframe details.
Begin your reply with "UX-FLOW: APPROVED|CONDITIONAL|REJECTED" (evaluate your own
output: is every REQ covered, does every screen have its 4 states).
```

## 3. Screen count check

If the screen count exceeds 12, ask the user:

> "That produced <N> screens. Should we write wireframes for all of them, or start
> with the <M> screens in Phase 1?"

Wireframe specifications are long — writing them per phase saves substantially.

## 4. Present

```
## UX Design
Information architecture: <N> sections
Flows: <M> critical flows
Screens: <K>

| Screen | Route | REQ | Priority |

REQ coverage: <X>/<Y>
⚠ Not covered: <list>
⚠ REQs without a screen (may be background work): <list>

Gate: UX-FLOW <verdict>
```

## 5. Write

- `docs/design/ux/personas.md` (if missing)
- `docs/design/ux/information-architecture.md`
- `docs/design/ux/flows/<flow>.md`
- `docs/design/ux/wireframes/<screen>.md`
- `.state/gates.jsonl`

## 6. Close

```
✓ UX design → docs/design/ux/
  <M> flows | <K> screens | REQ coverage <X>/<Y>

▶ Next: /design-system
   The UI Designer will define the tokens and components these screens will use.
```

---

## Token note

- **1 agent call.** The gate verdict comes from the same call.
- Acceptance criteria are embedded in full (they determine screen behaviour);
  the REQ body is not.
- Writing wireframes per phase is the biggest saving.
- Never print wireframes on screen — write the files, show the inventory table.
