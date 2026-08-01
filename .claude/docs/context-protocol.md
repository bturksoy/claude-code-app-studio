# Context Protocol — Single Source of Truth (SSoT) Map

Every fact lives in **exactly one file**. The table below defines where each fact is
stored and who may write it. If an agent duplicates a fact elsewhere, that is a **defect**.

---

## SSoT table

| Fact | File | Owner | Readers |
|---|---|---|---|
| Business goals, success metrics | `product/00-brief.md` | `ceo` | everyone |
| Product scope, feature list, priority | `product/prd/PRD.md` | `product-owner` | everyone |
| Functional requirements (`REQ-*`) | `product/requirements/FRD.md` | `business-analyst` | design, engineering, QA |
| Non-functional requirements (`NFR-*`) | `product/requirements/NFR.md` | `business-analyst` | architecture, DevOps, QA |
| Data dictionary / domain terms | `product/requirements/data-dictionary.md` | `business-analyst` | `sql-developer`, backend |
| Phase/release plan | `product/roadmap/ROADMAP.md` | `product-owner` | everyone |
| Sprint contents and assignments | `product/sprints/sprint-NN.md` | `delivery-manager` | everyone |
| Risk register | `product/risks.md` | `delivery-manager` | executive |
| System architecture | `docs/architecture/ARCHITECTURE.md` | `solution-architect` | engineering, QA |
| Architecture decisions (`ADR-*`) | `docs/architecture/adr/` | `solution-architect` (approval: `cto`) | engineering |
| API contract | `docs/api/openapi.yaml` | `solution-architect` | FE, BE, QA |
| Database schema | `db/schema.sql` + `docs/data/ER.md` | `sql-developer` | BE, data |
| User flows, IA | `docs/design/ux/` | `ux-designer` | FE, PO, QA |
| Design tokens & components | `docs/design/system/` | `ui-designer` | FE |
| Test strategy | `docs/qa/strategy.md` | `qa-lead` | QA, engineering |
| Test cases | `docs/qa/test-cases/` | `test-engineer` | engineering |
| Bug reports | `docs/qa/bugs/` | `test-engineer` | engineering, PO |
| Threat model | `docs/security/threat-model.md` | `security-engineer` | architecture, BE |
| Environments & CI/CD | `docs/ops/` + `infra/` | `devops-engineer` | everyone |
| Decision log | `docs/DECISIONS.md` | append: everyone | everyone |
| Project summary (the brain) | `docs/CONTEXT.md` | `delivery-manager` | **everyone, read first** |
| Machine state | `.state/project.json` | `delivery-manager` | skills |

---

## Read map — which role reads what

An agent opens **only** the files on its row. More than that is a budget violation.

```
ceo                  → CONTEXT.md, 00-brief.md, ROADMAP.md, risks.md
cto                  → CONTEXT.md, ARCHITECTURE.md, adr/index.md, NFR.md
product-owner        → CONTEXT.md, 00-brief.md, PRD.md, FRD.md, ROADMAP.md, backlog/
business-analyst     → CONTEXT.md, PRD.md, FRD.md, NFR.md, data-dictionary.md, ux/
solution-architect   → CONTEXT.md, FRD.md, NFR.md, ARCHITECTURE.md, adr/, openapi.yaml, ER.md
delivery-manager     → CONTEXT.md, ROADMAP.md, backlog/index.md, sprints/, risks.md, project.json
ux-designer          → CONTEXT.md, PRD.md, FRD.md (relevant REQs), ux/, system/
ui-designer          → CONTEXT.md, ux/, system/
frontend-developer   → story file, openapi.yaml, system/, ux/ (relevant flow), src/frontend
backend-developer    → story file, openapi.yaml, ER.md, governing ADR, src/backend
sql-developer        → story file, ER.md, schema.sql, data-dictionary.md, db/
data-engineer        → story file, ER.md, docs/data/, src/data
devops-engineer      → story file, NFR.md, ARCHITECTURE.md, infra/, docs/ops/
qa-lead              → CONTEXT.md, FRD.md, NFR.md, strategy.md, backlog/index.md
test-engineer        → story file, FRD.md (relevant REQs), test-cases/, tests/
code-reviewer        → diff, relevant story, relevant rules file
security-engineer    → threat-model.md, ARCHITECTURE.md, openapi.yaml, relevant src
performance-engineer → NFR.md, ARCHITECTURE.md, performance/, relevant src
tech-writer          → CONTEXT.md, PRD.md, openapi.yaml, CHANGELOG.md
```

---

## `docs/CONTEXT.md` template

This is the **first file every agent reads** and may not exceed 200 lines.

```markdown
# Project Context

**Project:** <name> — <one-sentence description>
**Primary user:** <persona>
**Stage:** <discovery | design | build | hardening | release | operate>
**Release target:** <vX.Y — date>
**Review mode:** <full | lean | solo>

## What we are building
<3-5 bullets, user-value oriented>

## Deliberately out of scope
<3-5 bullets>

## Technology stack
| Layer | Choice | ADR |
|---|---|---|

## Critical NFRs
<at most 5 lines — performance, security, scale targets>

## Active roles
<roster list>

## Current work
**Sprint:** <NN> — <goal>
**In progress:** <story list with owners>
**Blocked:** <if any>

## Known debt and risks
<at most 5 lines>
```

---

## Handoff packet

When one agent hands work to another, `/handoff` is used. The packet follows this
format and **must not exceed 200 words**:

```
FROM: <role>   TO: <role>   WORK: <story-id>
DONE: <bullets>
REMAINING: <bullets>
DECISIONS: <decisions made, with rationale>
WATCH OUT: <pitfalls, assumptions>
FILES: <paths touched>
VERIFY: <command the receiving agent should run>
```

---

## Conflict resolution

When two agents want to change the same file:

1. The file's **owner** is determined from the table above.
2. The non-owner presents the change as a **proposal**; it does not write.
3. If the owner accepts, the owner writes. If rejected, the rationale is added to
   `docs/DECISIONS.md`.
4. If the disagreement persists, escalate one level up in the authority matrix.
