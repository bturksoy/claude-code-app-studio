# Directory Structure

```
.
├── CLAUDE.md                    System constitution (loaded every session — keep it short)
├── README.md                    Human-facing introduction
│
├── .claude/
│   ├── settings.json            Models, permissions, hooks
│   ├── agents/*.md              19 role definitions
│   ├── skills/*/SKILL.md        Slash commands (workflows)
│   ├── rules/*.md               Path-scoped coding rules
│   ├── hooks/*.ps1              Automated checks
│   ├── templates/*.md           Document templates
│   └── docs/*.md                System documentation, including this file
│
├── product/                     PRODUCT LAYER (business language)
│   ├── 00-brief.md              Business summary, goals (GOAL-*), success metrics
│   ├── vision.md                Long-term product vision
│   ├── review-mode.txt          full | lean | solo
│   ├── risks.md                 Risk register
│   ├── prd/PRD.md               Product requirements document
│   ├── requirements/
│   │   ├── FRD.md               Functional requirements (REQ-*)
│   │   ├── NFR.md               Non-functional requirements (NFR-*)
│   │   └── data-dictionary.md   Domain terms and data definitions
│   ├── roadmap/
│   │   ├── ROADMAP.md           Phases, releases, milestones
│   │   └── phases/phase-N.md    Phase detail and exit criteria
│   ├── backlog/
│   │   ├── index.md             Table of all epics
│   │   └── epics/<slug>/
│   │       ├── EPIC.md
│   │       └── story-NNN-<slug>.md
│   └── sprints/
│       ├── index.md
│       └── sprint-NN.md         Sprint goal, assignments, capacity
│
├── docs/                        TECHNICAL LAYER
│   ├── CONTEXT.md               ★ Project brain — every agent reads this first (≤200 lines)
│   ├── DECISIONS.md             Decision log (append-only)
│   ├── architecture/
│   │   ├── ARCHITECTURE.md      Components, boundaries, data flow, deployment topology
│   │   ├── TECH-STRATEGY.md     The CTO's technology stance
│   │   └── adr/
│   │       ├── index.md
│   │       └── ADR-NNNN-<slug>.md
│   ├── api/
│   │   ├── openapi.yaml         ★ Single source of truth for the API
│   │   └── events.md            Asynchronous message/event contracts
│   ├── data/
│   │   ├── ER.md                Entity-relationship model
│   │   └── migrations.md        Migration strategy and ordering
│   ├── design/
│   │   ├── ux/                  Personas, flows, IA, wireframes
│   │   └── system/              Design tokens, component specifications
│   ├── qa/
│   │   ├── strategy.md          Test strategy and pyramid
│   │   ├── test-plan.md         Release-scoped test plan
│   │   ├── test-cases/          Scenarios (Given/When/Then)
│   │   ├── evidence/            Manual verification evidence
│   │   ├── performance/         Load test results and budgets
│   │   └── bugs/BUG-NNN.md      Bug reports
│   ├── security/
│   │   ├── threat-model.md      STRIDE threat model
│   │   └── checklist.md         OWASP checklist results
│   ├── ops/
│   │   ├── environments.md      Environments, variables, access
│   │   ├── runbook.md           Operational procedures, incident response
│   │   └── release-NNN.md       Release plan and rollback
│   └── guides/                  User and developer guides
│
├── src/                         SOURCE CODE
│   ├── frontend/
│   ├── backend/
│   ├── shared/                  Shared types, contract derivatives
│   └── data/                    ETL / analytics jobs
│
├── db/
│   ├── schema.sql               ★ Single source of truth for the schema
│   ├── migrations/NNNN_*.sql
│   └── seeds/
│
├── tests/
│   ├── unit/  integration/  e2e/  performance/
│
├── infra/                       IaC, containers, pipeline definitions
│
└── .state/
    ├── project.json             Phase, sprint, active roles, counters
    ├── gates.jsonl              Gate history (append-only)
    └── agent-log.jsonl          Agent invocation log (for token analysis)
```

Files marked ★ are **single sources of truth** — they are referenced, never copied.

---

## Naming conventions

| Item | Format | Example |
|---|---|---|
| Business goal | `GOAL-NN` | `GOAL-01` |
| Functional requirement | `REQ-<AREA>-NNN` | `REQ-AUTH-003` |
| NFR | `NFR-<CATEGORY>-NN` | `NFR-PERF-02` |
| Architecture decision | `ADR-NNNN-<slug>.md` | `ADR-0007-event-bus.md` |
| Epic directory | `<kebab-slug>/` | `user-management/` |
| Story | `story-NNN-<kebab-slug>.md` | `story-004-password-reset.md` |
| Sprint | `sprint-NN.md` | `sprint-03.md` |
| Bug | `BUG-NNN.md` | `BUG-021.md` |
| Test case | `TC-<REQ-ID>-NN` | `TC-AUTH-003-01` |
| Migration | `NNNN_<snake_name>.sql` | `0012_add_user_roles.sql` |

---

## `.state/project.json` schema

```json
{
  "project": "<name>",
  "phase": "discovery|design|build|hardening|release|operate",
  "reviewMode": "lean",
  "scale": "prototype|standard|enterprise",
  "activeRoles": ["product-owner", "solution-architect", "..."],
  "currentSprint": 3,
  "openGateConditions": 0,
  "stack": { "frontend": "", "backend": "", "db": "", "infra": "" },
  "counters": { "epics": 4, "stories": 27, "done": 12, "bugs": 3 },
  "lastUpdated": "YYYY-MM-DD"
}
```
