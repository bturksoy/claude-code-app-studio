---
name: epics
description: Splits the phase's requirements into epics. Each epic carries a capability group, its requirements, the architectural layer and its dependencies. One level above the story breakdown.
---

# /epics [phase]

Owner: `product-owner` + `solution-architect` (in parallel).
Outputs: `product/backlog/epics/<slug>/EPIC.md` + `product/backlog/index.md`

Prerequisite: `FRD.md` + `ROADMAP.md` + `ARCHITECTURE.md`

---

## 1. Scope

Without an argument, take the current phase from `ROADMAP.md` and extract that phase's
REQ list.

## 2. Parallel call (one message)

### Call A — `product-owner`

```
Phase: <name> — <hypothesis>
REQ table: <id | title | priority | actor>
Capabilities: <FEAT table>

Task: split this phase into epics.
- Each epic groups around USER VALUE, not a technical layer
  ("User management" ✓ / "Backend APIs" ✗)
- Each epic should be sized to produce 3-8 stories
- Each epic carries a one-sentence value statement:
  "<actor> can <do X>, so that <benefit>"
- Epic ordering: earliest visible user value first
- Every REQ must be assigned to exactly one epic — list any that are not

Output: | Epic slug | Name | Value statement | REQ list | Priority |
```

### Call B — `solution-architect`

```
Phase: <name>
REQ table: <id | title>
Architecture: <container and module list + dependency direction rule>
ADR list: <id | title | area affected>
API endpoint list: <path + method>
Data model: <table list>

Task: derive the technical breakdown constraints.
1. Technical layer ordering: which work must finish before other work
   (contract → data → service → interface)
2. For each REQ: which modules it touches, which ADRs govern it
3. Walking skeleton: which REQs make up the thinnest end-to-end slice
4. Risky/uncertain REQs: which ones need a spike first
5. REQs that touch the same module (cannot be worked in parallel)

Output as tables, brief.
```

## 3. Merge (you do this)

Add the architect's technical constraints to the PO's value-based epics:
- Per epic: modules touched, governing ADRs, technical preconditions
- Correct the epic ordering for technical dependencies (if it conflicts with the value
  ordering, show the conflict to the user)
- Put the walking-skeleton epic **first**

## 4. Present

```
## Epic Breakdown — Phase <N>

| # | Epic | Value | REQs | Modules | ADR | Depends on |

Walking skeleton: <epic>
Ordering rationale: <one paragraph>
⚠ Unassigned REQs: <if any>
⚠ Value order ↔ technical order conflict: <if any>
```

Get approval via `AskUserQuestion`.

## 5. Write

`product/backlog/epics/<slug>/EPIC.md` for each epic:

```markdown
# Epic: <name>
> **Phase:** <N> | **Priority:** <n> | **Status:** Ready | **Order:** <n>

## Value
<actor> can <do X>, so that <benefit>.

## Requirements covered
| REQ | Title | Priority | AC count |

## Technical context
**Modules touched:** <list>
**Governing ADRs:** <ADR-NNNN: title — one-line decision summary>
**API endpoints:** <list>
**Data tables:** <list>
**Screens:** <from the UX inventory>

## Dependencies
Must finish first: <epic list or None>
Waiting on this: <epic list or None>

## Stories
*Not yet created — run `/stories <slug>`*

## Completion criterion
<when this epic is done — measurable>
```

Also `product/backlog/index.md`:

```markdown
# Backlog
| # | Epic | Phase | REQs | Stories | Status | Depends on |
```

Update `counters.epics` in `.state/project.json`.

## 6. Close

```
✓ <N> epics → product/backlog/epics/
  Phase <M> | <K> REQs covered

▶ Next: /stories <first-epic-slug>
   Break the first epic into stories. Work through them in order — dependency
   ordering matters.
```

---

## Token note

- **2 parallel agent calls**; the merge is done by the model.
- REQs are embedded as a **heading table**, not full text.
- ADRs only as **title + one-line decision**; the full ADR gets embedded in the story.
- Do not write epics for every phase at once — only the current one.
