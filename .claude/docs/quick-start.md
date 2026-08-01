# Quick Start

## 1. Start a project

```bash
git init
```

In Claude Code:

```
/kickoff "Inventory and invoicing app for small businesses"
```

The CEO asks about business goals, you pick the project scale, and the roster plus
review mode are set. About 5 minutes.

## 2. Flesh out the project

```
/discovery
```

Product Owner and Business Analyst work **in parallel**, each through a different lens.
Disagreements and open questions are surfaced to you as decisions.

```
/prd            → product requirements document
/requirements   → testable requirements (REQ-*, NFR-*)
/roadmap        → phasing: MVP → v1 → v2
```

## 3. Design

```
/architecture   → the CTO picks the stack, the architect designs the system
/adr "<topic>"  → record critical decisions
/data-model     → ER + schema + migrations
/api-contract   → OpenAPI contract
/ux-flow        → flows and screens
/design-system  → tokens + components
```

## 4. Plan and build

```
/epics                  → value-based epic breakdown
/stories <epic>         → task packets (the most critical step)
/sprint-plan            → assignments, parallel lanes
/dev-task <story>       → implement a single story
/team-feature <epic>    → full-team vertical slice
```

## 5. Quality and release

```
/code-review
/qa-run
/dod-check
/security-review
/release v1.0.0
/retro
```

---

## Start every session like this

```
/status
```

It tells you where you left off, what is blocked, and the single next step.
It invokes no agents — it is free.

---

## What to expect in the first sprint

| Step | Duration | Agent calls |
|---|---|---|
| `/kickoff` | ~5 min | 1 |
| `/discovery` | ~5 min | 2 |
| `/prd` | ~5 min | 1 |
| `/requirements` | ~10 min | 1-2 |
| `/roadmap` | ~5 min | 1-2 |
| `/architecture` | ~10 min | 2-3 |
| `/epics` + `/stories` | ~15 min | 4-5 |
| `/sprint-plan` | ~5 min | 1 |

Phases 1-3 total roughly **15 agent calls**.
During development, expect 1-2 calls per story.

---

## Lowering the cost

1. Set `product/review-mode.txt` to `solo` (gates turn off)
2. Choose the `Prototype` scale in `/kickoff` (roster narrows)
3. Keep phases small — run `/requirements` and `/stories` per phase
4. Run `/context-compact` at the end of each sprint
5. Run one phase per session, then start a fresh session

## Raising the quality

1. Set `product/review-mode.txt` to `full`
2. Add `/threat-model`, `/perf-check`, `/security-review`
3. Use `/roundtable` to put hard decisions through multiple lenses
4. Actually read the evidence in the `/dod-check` output

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| The developer agent reads too many files | The story task packet is incomplete | Complete it with `/assign <story>` |
| A story takes 3+ rounds | Acceptance criteria are ambiguous | Clarify with `/requirements` |
| Sprints keep slipping | Dependency chain is too long | Review the lanes in `/sprint-plan` |
| Token usage is high | Gate mode is `full` | Drop to `lean` |
| Agents drift out of scope | The story's "Out of scope" section is empty | Re-run `/stories` |
| I don't know what to do next | — | `/status` |
