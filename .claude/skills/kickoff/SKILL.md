---
name: kickoff
description: Starts a new project. Takes the project idea, works with the CEO to define business goals and success metrics, selects the agent roster and review mode based on project scale, and sets up the directory structure and state files.
---

# /kickoff "<project idea>"

Phase 0. Outputs: `product/00-brief.md`, `.state/project.json`, a `docs/CONTEXT.md`
skeleton, the directory structure and the selected roster.

---

## 1. Take the input

If there is no argument, ask: *"What do you want to build? One sentence is enough."*

Keep the argument **verbatim** — do not interpret or expand it.

## 2. Clarification round (no agents — cheap)

Ask **four questions in a single call** via `AskUserQuestion`. These determine the
roster and mode:

**Question 1 — Project type**
`Web application` / `Mobile application` / `API / backend service` / `Desktop or CLI`

**Question 2 — Scale and seriousness**
- `Prototype` — testing an idea, fast, one person
- `Standard product (Recommended)` — real users, will be maintained
- `Enterprise / regulated` — compliance, audit, multiple teams

**Question 3 — Who is the user**
- `Myself / internal team` / `Small businesses` / `General consumers` / `Another system (API consumer)`

**Question 4 — The most critical constraint**
- `Speed — make it work as soon as possible`
- `Correctness — errors are unacceptable (money/health/legal)`
- `Scale — there will be many users`
- `Cost — operating expense must stay low`

## 3. Derive the roster and mode from scale

| Scale | Mode | Active roles |
|---|---|---|
| Prototype | `solo` | product-owner, solution-architect, backend-developer, frontend-developer, test-engineer |
| Standard | `lean` | + business-analyst, ux-designer, ui-designer, sql-developer, devops-engineer, qa-lead, code-reviewer, delivery-manager |
| Enterprise | `full` | Full roster (19) |

The answer to question 4 adjusts the roster:
- `Correctness` → `security-engineer` + `qa-lead` active at every scale
- `Scale` → `performance-engineer` + `devops-engineer` active
- `Cost` → `devops-engineer` active; the `cto` records the cost constraint in TECH-STRATEGY

**Show and confirm** the selection with the user:
```
Roster: <list>
Mode: <mode> — <one sentence on what it means>
Disabled: <list> — <why>
These can be changed later (product/review-mode.txt).
```

## 4. Business framing with the CEO

Invoke the `ceo` agent. **Embed** the following in the prompt (do not have it read files):

```
Project idea: <argument>
Type: <answer 1> | Scale: <answer 2> | User: <answer 3> | Constraint: <answer 4>

Task:
1. Propose at most 3 measurable business goals (GOAL-01..03). For each:
   target value, measurement method, measurement time.
2. Produce a list of what will NOT be in the MVP (at least 5 items) — this protects scope.
3. Write the 3 riskiest assumptions and how each will be tested.
4. Write the failure scenario for this project in one paragraph.

Be brief. Begin your reply with "CEO-VISION: APPROVED|CONDITIONAL|REJECTED".
If something is unclear, do not assume — open a "QUESTION:" line.
```

If the CEO returns `QUESTION:` lines, ask the user via `AskUserQuestion`, then send the
answers back to the CEO **in a single follow-up** (second round, at most once).

## 5. Present the brief and get approval

Show a summary before writing:

```
## <Project name>
<one-sentence description>

Goals
  GOAL-01: <measurable goal>
  GOAL-02: ...

Not in the MVP
  - <item>

Risky assumptions
  - <assumption> → <how it is tested>

Roster: <list>  |  Mode: <mode>
```

`AskUserQuestion`:
- `Approve and set up (Recommended)`
- `I want to change the goals`
- `I want to change the roster/mode`

## 6. Create the files

After approval:

**Directories** (`.gitkeep` in empty ones):
```
product/{prd,requirements,roadmap/phases,backlog/epics,sprints}
docs/{architecture/adr,api,data,design/{ux/flows,ux/wireframes,system/components},qa/{test-cases,evidence,performance,bugs},security,ops,guides}
src tests/{unit,integration,e2e,performance} db/{migrations,seeds} infra .state
```

**`product/00-brief.md`**
```markdown
# <Project> — Business Brief
**Date:** <today> | **Scale:** <scale> | **Type:** <type>

## In one sentence
<description>

## Problem
<from the CEO output>

## Target user
<answer 3 + detail>

## Business goals
| ID | Goal | Target value | Measurement | When |
|---|---|---|---|---|
| GOAL-01 | | | | |

## Not in the MVP
- <item> — <why>

## Risky assumptions
| # | Assumption | How it is tested | What if it is wrong |

## Constraints
<critical constraint + any budget/schedule/technology constraint>

## Failure scenario
<the paragraph written by the CEO>
```

**`product/review-mode.txt`** → a single line: `<mode>`

**`.state/project.json`**
```json
{
  "project": "<name>",
  "phase": "discovery",
  "reviewMode": "<mode>",
  "scale": "<scale>",
  "activeRoles": [...],
  "currentSprint": null,
  "openGateConditions": 0,
  "stack": {},
  "counters": {"epics":0,"stories":0,"done":0,"bugs":0},
  "lastUpdated": "<today>"
}
```

**`docs/CONTEXT.md`** — fill in the template from `.claude/docs/context-protocol.md`
(unknown fields become `<not yet determined>`).

**`docs/DECISIONS.md`**
```markdown
# Decision Log
| Date | Decision | By | Rationale | Reference |
|---|---|---|---|---|
| <today> | scale=<scale>, mode=<mode> | user | /kickoff | — |
```

**`product/risks.md`** — turn the CEO's risky assumptions into risk-register entries.

**`.state/gates.jsonl`** — write the CEO-VISION verdict as the first line.

## 7. Close

```
✓ <Project> is set up.

Goals: GOAL-01..NN  |  Roster: <N> roles  |  Mode: <mode>

▶ Next: /discovery
   The Product Owner and Business Analyst will work through the project together.
```

`AskUserQuestion`: `Run /discovery now (Recommended)` / `I'll read the brief first`

---

## Token note

- This skill invokes **one agent** (`ceo`), at most two rounds.
- Clarification questions go to the user, not to an agent — that is free.
- Create the directories in a single Bash call.
