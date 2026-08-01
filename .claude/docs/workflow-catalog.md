# Workflow Catalogue

38 skills across 6 phases. Each row: command, owning role, input, output.

---

## Phase 0 — Bootstrap

| Command | Owner | Input | Output |
|---|---|---|---|
| `/start` | — | — | State detection + next-step suggestion |
| `/help` | — | — | Command list, filtered by phase |
| `/kickoff "<idea>"` | `ceo` + `product-owner` | Project idea | `product/00-brief.md`, `.state/project.json`, roster selection |
| `/onboard` | `solution-architect` | Existing codebase | `docs/CONTEXT.md`, draft `ARCHITECTURE.md`, debt list |

## Phase 1 — Discovery & Requirements

| Command | Owner | Input | Output |
|---|---|---|---|
| `/discovery` | `product-owner` ‖ `business-analyst` | Brief | Problem statement, personas, scope boundary, open questions |
| `/roundtable "<topic>"` | caller | Any topic | Multi-lens analysis + decisions on disagreements |
| `/prd` | `product-owner` | Discovery output | `product/prd/PRD.md` |
| `/requirements` | `business-analyst` | PRD | `FRD.md`, `NFR.md`, `data-dictionary.md` |
| `/roadmap` | `product-owner` | PRD + FRD | `ROADMAP.md`, phase files, MVP boundary |
| `/estimate` | `delivery-manager` | Epic/story list | Effort estimate + uncertainty band |
| `/scope-check` | `product-owner` | Current backlog | Scope-creep report + cut recommendations |

## Phase 2 — Architecture & Design

| Command | Owner | Input | Output |
|---|---|---|---|
| `/architecture` | `solution-architect` + `cto` | FRD + NFR | `ARCHITECTURE.md`, stack selection, initial ADRs |
| `/adr "<topic>"` | `solution-architect` | Technical question | `ADR-NNNN-*.md` |
| `/api-contract` | `solution-architect` | FRD + architecture | `docs/api/openapi.yaml` |
| `/data-model` | `sql-developer` | FRD + data dictionary | `docs/data/ER.md`, `db/schema.sql`, migration plan |
| `/ux-flow` | `ux-designer` | PRD + FRD | Personas, flow diagrams, IA, wireframe specs |
| `/design-system` | `ui-designer` | UX output | Token set, component catalogue, accessibility rules |
| `/threat-model` | `security-engineer` | Architecture + API | `docs/security/threat-model.md` |

## Phase 3 — Planning & Development

| Command | Owner | Input | Output |
|---|---|---|---|
| `/epics` | `product-owner` + `solution-architect` | FRD + roadmap phase | `backlog/epics/*/EPIC.md` |
| `/stories <epic>` | `business-analyst` + `qa-lead` | Epic | Story files (task-packet format) |
| `/sprint-plan` | `delivery-manager` | Ready stories | `sprint-NN.md` — assignments, dependencies, capacity |
| `/assign <story>` | `delivery-manager` | Story | Routing to the right agent + readiness check |
| `/dev-task <story>` | relevant developer | Story file | Code + tests + story update |
| `/team-feature <epic>` | `delivery-manager` | Epic | End-to-end vertical slice, multi-agent coordinated |
| `/handoff` | any | Work in progress | Handoff packet (≤200 words) |

## Phase 4 — Quality

| Command | Owner | Input | Output |
|---|---|---|---|
| `/code-review [scope]` | `code-reviewer` | Diff / files | Findings list + verdict |
| `/test-plan` | `qa-lead` | FRD + risk | `docs/qa/test-plan.md`, risk-based coverage |
| `/qa-run [scope]` | `test-engineer` | Test plan | Test execution + result report + bug records |
| `/bug "<description>"` | `test-engineer` | Observation | `BUG-NNN.md` + triage (priority/owner) |
| `/security-review` | `security-engineer` | Code + architecture | OWASP findings + verdict |
| `/perf-check` | `performance-engineer` | NFR + code | Budget comparison + bottleneck analysis |
| `/dod-check <story>` | `qa-lead` | Story + evidence | DoD gate verdict |

## Phase 5 — Release & Operate

| Command | Owner | Input | Output |
|---|---|---|---|
| `/release <version>` | `devops-engineer` + `ceo` | Completed release scope | Release plan, rollback, go/no-go |
| `/changelog` | `tech-writer` | Story history | `CHANGELOG.md` entry |
| `/hotfix "<issue>"` | `delivery-manager` | Production incident | Fast path: analysis → fix → verify → ship |
| `/retro` | `delivery-manager` | Sprint/release | Retro note + action items |
| `/status` | `delivery-manager` | Project | Status dashboard + next step |

## Utility

| Command | Owner | Purpose |
|---|---|---|
| `/context-compact` | `delivery-manager` | Compact bloated docs, refresh indexes |

---

## Phase transition rules

A phase does not advance until its exit gate returns `APPROVED`. `/status` tells you
which gate is open.

```
Phase 0 → 1 : CEO-VISION
Phase 1 → 2 : PO-SCOPE + BA-REQ
Phase 2 → 3 : CTO-STACK + ARCH-DESIGN
Phase 3 → 4 : DM-PLAN (per sprint)
Phase 4 → 5 : QA-DONE (all stories in the release scope)
Phase 5     : OPS-READY + CEO-GONOGO
```

Can phases be skipped? Yes — when `scale=prototype`, `/kickoff` suggests this shortcut:

```
/kickoff → /prd → /architecture → /epics → /stories → /dev-task → /qa-run → /release
```

`business-analyst`, `ux-designer`, `security-engineer` and `performance-engineer` are
disabled. This cuts token cost by roughly 60%.
