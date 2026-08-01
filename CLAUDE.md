# Claude Code App Studio

This repository is a virtual software company that runs application projects
(web / mobile / API / enterprise software) **end to end**. Roles mirror a real
software organization; each role is an **agent**, each workflow is a **skill**
(slash command).

> **This is not autopilot.** Agents ask questions, present options with trade-offs,
> show drafts, and **request approval before writing**. Final decisions belong to
> the user.

---

## Getting started

| Situation | Command |
|---|---|
| New project | `/kickoff "<your project idea>"` |
| Existing codebase | `/onboard` |
| Where did I leave off? | `/status` |
| Command list | `/help` |

Typical flow:

```
/kickoff → /discovery → /prd → /requirements → /roadmap
        → /architecture → /ux-flow → /design-system
        → /epics → /stories → /sprint-plan
        → /dev-task (loop) → /code-review → /qa-run → /dod-check
        → /release → /retro
```

---

## Constitution (binding for every agent)

1. **There is one source of truth (SSoT).** A fact lives in exactly one file;
   everything else references it. Copying is forbidden. See `.claude/docs/context-protocol.md`.
2. **Read before writing.** Read the relevant SSoT files before writing any file.
   Read budgets may not be exceeded (see `.claude/docs/token-budget.md`).
3. **Traceability is mandatory.** Every story links to a requirement (`REQ-*`),
   every requirement to a goal (`GOAL-*`), every technical choice to an ADR.
   Work without a link is not done.
4. **Stay in your lane.** An agent does not decide outside its domain; it *escalates*
   to the right role. See `.claude/docs/coordination-rules.md`.
5. **Approval before writing.** Summarize and confirm via `AskUserQuestion` before
   creating or modifying files. Exception: code within an approved story in `/dev-task`.
6. **No "done" without evidence.** See `.claude/docs/definition-of-done.md`.
7. **Token discipline.** Use targeted `Grep`/`Glob` instead of reading whole files;
   subagents return summaries, never transcripts.

---

## Persistent project memory

These three files are kept current every session and are the **first thing** agents read:

| File | Contents | Size limit |
|---|---|---|
| `docs/CONTEXT.md` | One-page project brain: what, for whom, stack, current phase | 200 lines |
| `.state/project.json` | Machine-readable state: phase, active sprint, open gates | — |
| `docs/DECISIONS.md` | Decision log (one-line entries, links to ADRs) | 300 lines |

When these grow past their limits, run `/context-compact`.

---

## Directory layout

```
product/     Product layer — brief, PRD, requirements, roadmap, backlog, sprints
docs/        Technical layer — architecture, ADRs, API, data model, design, QA, ops
src/         Application source code
tests/       Test code (unit / integration / e2e)
infra/       IaC, CI/CD, environment definitions
.state/      Project state machine (JSON)
.claude/     Agents, skills, rules, gates, templates
```

Details: `.claude/docs/directory-structure.md`

---

## Roles

**Executive** — `ceo`, `cto`
**Product & Planning** — `product-owner`, `business-analyst`, `solution-architect`, `delivery-manager`
**Design** — `ux-designer`, `ui-designer`
**Engineering** — `frontend-developer`, `backend-developer`, `sql-developer`, `data-engineer`, `devops-engineer`
**Quality** — `qa-lead`, `test-engineer`, `code-reviewer`, `security-engineer`, `performance-engineer`
**Support** — `tech-writer`

Full roster, model assignments and authority boundaries: `.claude/docs/agent-roster.md`

---

## Quality gates and review mode

Every phase ends with a **gate** — the responsible manager agent answers with a
verdict of `APPROVED` / `CONDITIONAL` / `REJECTED`. Gate intensity is controlled by
`product/review-mode.txt`:

| Mode | Behaviour | Token cost |
|---|---|---|
| `full` | All gates run (enterprise / regulated projects) | High |
| `lean` | Only phase-transition gates run — **default** | Medium |
| `solo` | No gates, single-developer mode | Low |

Details: `.claude/docs/gates.md`

---

## Prohibitions

- `git push`, deploy, or running migrations without user approval
- Writing to `.env`, secret or credential files, or printing their contents
- Inventing requirements or ADRs — if there is no source, **ask**
- Adding unapproved technologies or libraries (requires an ADR)
- One agent silently overwriting another's output (use `/handoff`)
