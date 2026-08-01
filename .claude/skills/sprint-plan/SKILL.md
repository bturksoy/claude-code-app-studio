---
name: sprint-plan
description: Sets the sprint goal, assigns stories to agents, orders dependencies, sets up parallel work lanes and flags risks. Where task assignment happens. Operates the DM-PLAN gate.
---

# /sprint-plan [new | status]

Owner: `delivery-manager`. Output: `product/sprints/sprint-NN.md`

---

## 1. Input

- `product/backlog/index.md` — epic statuses
- The **heading table** of ready stories (Glob + the first 8 lines of each story —
  do not read full story files)
- `product/roadmap/ROADMAP.md` — the current phase goal
- `product/risks.md`
- `.state/project.json` — active roles, last sprint number

## 2. Sprint parameters from the user

`AskUserQuestion`:
- **Sprint length:** `1 week` / `2 weeks (Recommended)` / `No timebox — proceed story by story`
- **Focus this sprint:** `Walking skeleton` / `<epic name>` / `Mixed — highest-priority stories`

## 3. Invoke `delivery-manager`

```
Phase: <name> — <hypothesis and exit criterion>
Active roles: <list>
Sprint length: <answer> | Focus: <answer>
Last sprint: <NN> — <any carried-over stories>

Ready stories:
| # | Epic | Title | Type | Owner | Estimate | Depends on | Modules touched |

Open risks: <summary from risks.md>

Task: produce the plan for sprint <NN+1>.

1. Sprint goal — ONE sentence, must contain user value
   ("Finish N stories" is not a goal)
2. Story selection: what fits capacity, has dependencies resolved, and serves the goal
3. Assignment table: | # | Story | Type | Owner | Estimate | Depends on | Day | Status |
4. Critical path: the ordered chain — if one slips, the sprint slips
5. Parallel lanes: which work can run concurrently
   Lane format: "Lane A (contract) → Lane B (data+service) ‖ Lane C (interface)"
   State the integration point (mid-sprint, not the end)
6. Risks: | Risk | Probability | Impact | Owner | Early warning | Mitigation |
7. What was left out and why

MANDATORY RULES (fix the plan if any is violated):
- One story = one owner
- Two agents cannot write to the same file/module in one sprint → sequence them
- Contract-producing work (API/schema) finishes the DAY BEFORE consuming work
- 20% of capacity is buffer (bugs + unplanned work)
- A dependency chain may not exceed 3
- Blocked stories are not pulled into the sprint

Begin your reply with "DM-PLAN: APPROVED|CONDITIONAL|REJECTED" (review your own plan).
```

## 4. Conflict audit (you do this)

When the plan arrives, check:
- Are two stories with the same `Modules touched` value in the same lane → warn
- Is the owner of a dependent story the same as the owner of the story it depends on →
  bottleneck warning
- Does the total estimate exceed capacity

## 5. Present

```
## Sprint <NN> — <date range>
Goal: <one sentence>

Assignments
| # | Story | Owner | Estimate | Day | Depends on |

Parallel lanes
  Lane A (contract) : story-003 → sql-developer         [Day 1]
  Lane B (service)  : story-004, story-005 → backend    [Day 2-4]
  Lane C (interface): story-006 → frontend (mocks)      [Day 2-4]
  Integration       : Day 4
  Lane D (testing)  : story-007 → test-engineer         [Day 5]

Critical path: story-003 → story-004 → story-006
Capacity: <used>/<total> (buffer <n>%)
Risks: <top 3>
Left out: <list>

Gate: DM-PLAN <verdict>
⚠ Conflict warning: <if any>
```

`AskUserQuestion`: `Approve the plan (Recommended)` / `I want to narrow the scope` /
`I want to change the owner assignments`

## 6. Write

- `product/sprints/sprint-NN.md`
- A row in `product/sprints/index.md`
- Update the `**Sprint:**` field in the header of each selected story file
- `.state/project.json` → `currentSprint`, `phase: "build"`
- `docs/CONTEXT.md` → the "Current work" section
- `.state/gates.jsonl` → DM-PLAN

## 7. Close

```
✓ Sprint <NN> planned — <N> stories, <M> roles

▶ Next: /dev-task <first-story-path>
   First story on the critical path: <name> (<owner>)

   Alternative: /team-feature <epic>  — runs the whole lane in a coordinated way
```

---

## `/sprint-plan status` mode

If the argument is `status`, do not plan a new sprint; show the current sprint's state:

```
## Sprint <NN> — Day <X>/<Y>
| Story | Owner | Status | Note |
Completed: <a>/<b> | Blocked: <c>
Critical path: <on track | at risk | slipped>
Remaining capacity: <...>
▶ Do now: <story>
```

This mode **invokes no agents** — it only reads files.

---

## Token note

- **1 agent call.**
- Do **not** read story files in full — the header block (first 8 lines) is enough.
- `status` mode is entirely free (file reads only).
- The conflict audit is done by the model.
