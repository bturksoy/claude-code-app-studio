---
name: start
description: Detects the project state and tells you where to continue. Bootstraps a new project or finds the missing step in an existing one. The first command of every session.
---

# /start

Performs a cheap state check and suggests **a single next step**. Invokes no agents.

## 1. State detection

Check the existence of these files **with Glob** (do not read their contents):

```
.state/project.json
product/00-brief.md
product/prd/PRD.md
product/requirements/FRD.md
product/roadmap/ROADMAP.md
docs/architecture/ARCHITECTURE.md
docs/api/openapi.yaml
product/backlog/index.md
product/sprints/index.md
docs/CONTEXT.md
```

Also: are there any files under `src/` (Glob `src/**/*.*`, the first 5 results suffice).

## 2. Route by state

### A) None of them exist and `src/` is empty → **new project**

```
There is no project in this directory yet.

To begin, describe your project idea in one sentence:
  /kickoff "<your project idea>"

Example:
  /kickoff "Inventory and invoicing app for small businesses"
```

Stop. Do nothing else.

### B) `src/` has content but `product/` and `docs/` do not → **existing codebase**

```
There is code here but no App Studio documentation.

  /onboard    → analyses the codebase and drafts CONTEXT.md and the architecture
```

### C) `.state/project.json` exists → **project in progress**

Read `.state/project.json` and `docs/CONTEXT.md` (only these two).
Produce this table:

```
## <project name>
Phase: <phase>  |  Sprint: <NN>  |  Mode: <lean>  |  Scale: <standard>

Completed
  ✓ <step>  → <file>
Missing
  ○ <step>  → <command>

Open gate conditions: <N>  (CONDITIONAL entries from .state/gates.jsonl)

▶ Next step: <a single command>
```

State → next command map:

| Current state | Next |
|---|---|
| Brief exists, no PRD | `/prd` |
| PRD exists, no FRD | `/requirements` |
| FRD exists, no roadmap | `/roadmap` |
| Roadmap exists, no architecture | `/architecture` |
| Architecture exists, no backlog | `/epics` |
| Epics exist, no stories | `/stories <epic>` |
| Stories exist, no sprint | `/sprint-plan` |
| Sprint active with open stories | `/dev-task <story>` |
| All stories DONE | `/dod-check` → `/release` |

## 3. Rules

- **Invoke no agents.** This skill only checks file existence.
- **Maximum whole-file reads: 2** (`project.json`, `CONTEXT.md`).
- If several things are missing, suggest **only the first** — do not flood the user with options.
- If the user asks to see everything, tell them to run `/help`.
