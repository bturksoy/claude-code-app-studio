---
name: release
description: Prepares the release plan, gathers all quality gates, validates the migration and rollback plan, and obtains the CEO go/no-go decision. Operates the OPS-READY and CEO-GONOGO gates.
---

# /release <version>

Owner: `devops-engineer` + `ceo`. Output: `docs/ops/release-<version>.md`

---

## 1. Collect the release scope (no agent)

- Stories in this release (`Status: DONE` + sprint filter)
- Open bugs: are there P0/P1 (if so, **warn**)
- Gate history (`.state/gates.jsonl`): open `CONDITIONAL` items
- Migrations: the new migrations that will run in this release
- Changed dependencies and configuration

**Pre-check — stop and report if any of these fail:**
```
[ ] Every story in the release scope is DONE (QA-DONE: APPROVED)
[ ] No open P0 bugs
[ ] No open CONDITIONAL gate items
[ ] The regression suite was green on the last run
```

## 2. Run the missing gates

Suggest any gates that have not run for this release:
- No `SEC-REVIEW` → suggest `/security-review`
- No `PERF-BUDGET` (and performance targets exist in the NFRs) → suggest `/perf-check`
- Regression not green → suggest `/qa-run regression`

`AskUserQuestion`: `Run the missing gates (Recommended)` /
`Skip and accept the risk` / `Postpone the release`

## 3. Invoke `devops-engineer` — OPS-READY

```
Release: <version>
Scope: <story list — titles>
Migrations: <file list + what each does>
Changed dependencies/config: <list>
Target environment: <staging → prod>
Current environment definition: <summary from docs/ops/environments.md>
NFRs — availability/recovery: <the relevant NFRs>

Task: the release plan and the OPS-READY gate.

1. Deployment steps — ordered, each with its verification
2. Migration plan: order, estimated duration, lock risk, reversibility
   If downtime is needed, its duration and the announcement plan
3. Rollback plan — STEP BY STEP, with the data-loss risk
   If a migration is not reversible, SAY SO and give a roll-forward plan
4. Pre-release checklist
5. Post-release verification: which metrics/logs/alerts to watch, and for how long
6. Is a staged rollout (canary/percentage) applicable

OPS-READY criteria:
- Can the environment be produced from IaC
- Is the rollback written down and tested
- Are secrets handled through a manager, is the leak scan clean
- Are logs/metrics/alerts defined with owners
- Does backup work, has restore been attempted
- Does capacity handle 2× the expected load

Begin your reply with "OPS-READY: APPROVED|CONDITIONAL|REJECTED".
```

## 4. Invoke `ceo` — CEO-GONOGO

```
Release: <version>
Scope (in terms of user value): <a business-language summary of the stories>
Which GOALs it serves: <list>

GATE STATUS:
  QA-DONE: <verdict>  |  SEC-REVIEW: <verdict>  |  PERF-BUDGET: <verdict>
  OPS-READY: <verdict>

Open risks: <list — including accepted ones>
Known limitations: <what does not work or is missing in this release>
Rollback: <is it possible, at what cost>

Task: the CEO-GONOGO decision.
Evaluate: is the cost of not shipping greater than the risk of shipping?
Be brief. Begin your reply with "CEO-GONOGO: APPROVED|CONDITIONAL|REJECTED".
```

## 5. Present

```
## Release <version>
Scope: <N> stories | <M> bug fixes

Gates
  QA-DONE      <verdict>
  SEC-REVIEW   <verdict>
  PERF-BUDGET  <verdict>
  OPS-READY    <verdict>
  CEO-GONOGO   <verdict>

Migrations: <N> — reversible: <yes/no>
Downtime: <none/duration>
Rollback: <summary>

Known limitations: <list>
Accepted risks: <list>

Post-release watch list: <metrics + duration>
```

## 6. Write — do NOT deploy

```
✓ Release plan → docs/ops/release-<version>.md

⚠ The deploy command was NOT run. Review the plan and run it yourself when ready:
```
Show the deploy command **as a code block**; do not execute it.
Only execute it if the user explicitly says "deploy" and `CEO-GONOGO: APPROVED`.

Also:
- Suggest running `/changelog`
- `.state/gates.jsonl` → the two gate lines
- `.state/project.json` → `phase: "release"`

## 7. After the release

When the user reports that they have deployed:
- Remind them of the verification list
- Add the actual release time and outcome to `docs/ops/release-<version>.md`
- `.state/project.json` → `phase: "operate"`
- Suggest `/retro`

---

## Token note

- **2 agent calls** (DevOps + CEO). Gate collection is free.
- Send the CEO a **business-language summary**, not technical detail.
- Run missing gates through their own skills — do not fold them into this one.
