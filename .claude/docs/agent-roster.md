# Agent Roster

19 roles across 4 tiers. Each row: the role's **one-sentence job**, its assigned model,
and **which files it may write to**.

Model assignment drives token cost: `opus` = strategic/ambiguous work,
`sonnet` = production work, `haiku` = mechanical/templated work.

---

## Tier 0 — Executive

| Agent | Model | Job | Write access |
|---|---|---|---|
| `ceo` | opus | Business vision, success metrics, phase go/no-go, scope–budget arbitration | `product/00-brief.md`, `product/vision.md` |
| `cto` | opus | Technology strategy, architectural authority, technical risk acceptance | `docs/architecture/TECH-STRATEGY.md`, ADR approval |

**They do not:** write code, write stories, or design. They decide and open gates.

---

## Tier 1 — Product & Planning

| Agent | Model | Job | Write access |
|---|---|---|---|
| `product-owner` | opus | Turns vision into a PRD, owns the backlog, prioritizes, accepts work | `product/prd/`, `product/backlog/`, `product/roadmap/` |
| `business-analyst` | opus | Elicits requirements, models processes, produces FRD/NFR/data dictionary, hunts ambiguity | `product/requirements/` |
| `solution-architect` | opus | System architecture, component boundaries, ADRs, API contract, NFR mechanisms | `docs/architecture/`, `docs/api/` |
| `delivery-manager` | sonnet | Sprint planning, task assignment, dependency/risk management, status reporting | `product/sprints/`, `product/risks.md`, `.state/project.json` |

**PO ↔ BA relationship:** the PO owns *what and why*; the BA owns *exactly how it
will behave*. The two hold a **round-table** in `/discovery` and `/requirements`;
disagreements escalate to `ceo`.

---

## Tier 2 — Design

| Agent | Model | Job | Write access |
|---|---|---|---|
| `ux-designer` | sonnet | Personas, user flows, information architecture, wireframes, usability criteria | `docs/design/ux/` |
| `ui-designer` | sonnet | Design tokens, component specs, accessibility (WCAG), visual language | `docs/design/system/` |

---

## Tier 2 — Engineering

| Agent | Model | Job | Write access |
|---|---|---|---|
| `frontend-developer` | sonnet | UI implementation, state management, API consumption, client performance | `src/frontend/**`, `tests/frontend/**` |
| `backend-developer` | sonnet | Service/domain layer, API implementation, business rules, integrations | `src/backend/**`, `tests/backend/**` |
| `sql-developer` | sonnet | Schema, migrations, indexes, query tuning, referential integrity | `db/**`, `src/**/migrations/**` |
| `data-engineer` | sonnet | ETL/ELT, reporting model, event schema, analytics pipeline *(optional role)* | `src/data/**`, `docs/data/` |
| `devops-engineer` | sonnet | CI/CD, IaC, environments, secret management, observability, deployment | `infra/**`, `.github/**`, `docs/ops/` |

**Critical rule:** engineering agents **consume contracts, they do not produce them.**
Changes to `docs/api/openapi.yaml` and `db/schema.sql` require approval from
`solution-architect` and `sql-developer` — they cannot be changed unilaterally.

---

## Tier 3 — Quality

| Agent | Model | Job | Write access |
|---|---|---|---|
| `qa-lead` | opus | Test strategy, acceptance-criteria quality review, DoD gate, risk-based testing | `docs/qa/test-plan.md`, `docs/qa/strategy.md` |
| `test-engineer` | sonnet | Test case authoring, automation, regression suite, bug reports | `tests/**`, `docs/qa/test-cases/`, `docs/qa/bugs/` |
| `code-reviewer` | sonnet | Independent code review: correctness, readability, rule compliance | Does not write — returns findings |
| `security-engineer` | sonnet | Threat model, OWASP checks, authorization review, secret scanning | `docs/security/` |
| `performance-engineer` | sonnet | Performance budgets, load testing, profiling, bottleneck analysis | `docs/qa/performance/` |

---

## Tier 3 — Support

| Agent | Model | Job | Write access |
|---|---|---|---|
| `tech-writer` | haiku | API docs, user guides, changelog, README, release notes | `docs/guides/`, `CHANGELOG.md` |

---

## Authority matrix (summary)

| Decision type | Owner | Consulted | Informed |
|---|---|---|---|
| Business goal / MVP scope | `ceo` | `product-owner` | everyone |
| Feature priority | `product-owner` | `business-analyst`, `delivery-manager` | engineering |
| Requirement behaviour | `business-analyst` | `product-owner`, `ux-designer` | engineering, QA |
| Technology choice | `cto` | `solution-architect`, `devops-engineer` | engineering |
| Component boundary / pattern | `solution-architect` | relevant developer | QA |
| Data model | `sql-developer` | `solution-architect`, `backend-developer` | `data-engineer` |
| API contract | `solution-architect` | `backend-developer`, `frontend-developer` | QA |
| User flow | `ux-designer` | `product-owner` | `frontend-developer` |
| "Done" decision | `qa-lead` | `test-engineer`, `product-owner` | `delivery-manager` |
| Ship decision | `ceo` (go/no-go) | `qa-lead`, `devops-engineer`, `security-engineer` | everyone |

---

## Enabling and disabling roles

On small projects, narrow the roster — every agent call costs tokens.

| Project scale | Active roles |
|---|---|
| Prototype / weekend project | `product-owner`, `solution-architect`, `backend-developer`, `frontend-developer`, `test-engineer` |
| Standard product | + `business-analyst`, `ux-designer`, `sql-developer`, `devops-engineer`, `qa-lead`, `code-reviewer` |
| Enterprise / regulated | Full roster + `security-engineer`, `performance-engineer`, `ceo`, `cto` |

The active roster is stored in the `activeRoles` field of `.state/project.json`;
`/kickoff` determines it from the project scale.
