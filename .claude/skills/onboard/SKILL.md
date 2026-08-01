---
name: onboard
description: Brings an existing codebase into the App Studio system. Analyses the code and produces CONTEXT.md, a draft architecture, a technical debt list and reverse-engineered requirements. The entry point for brownfield projects.
---

# /onboard

Owner: `solution-architect`. Outputs: `docs/CONTEXT.md`, a draft `ARCHITECTURE.md`,
a technical debt list, `.state/project.json`.

---

## 1. Quick reconnaissance (free — stops the agent from having to search)

Collect the following with Glob and Grep (do not read file contents; check existence and
structure only):

```
Stack signals    : package.json, requirements.txt, *.csproj, go.mod, pom.xml,
                   Gemfile, composer.json, Cargo.toml
Structure        : top-level directories (2 levels deep)
Entry points     : main.*, index.*, app.*, Program.cs, server.*
Configuration    : *.config.*, .env.example, appsettings*.json
Tests            : test/ spec/ __tests__/ — file count
Database         : migrations/, schema.sql, models/, entities/
CI/CD            : .github/workflows/, .gitlab-ci.yml, Jenkinsfile, Dockerfile
Documentation    : README, docs/, traces of ADRs
Dependency count : from the manifest file
Code volume      : file count and approximate line count (Glob counting)
```

If git is present: `git log --oneline -20`, contributor count, last commit date.

## 2. Invoke `solution-architect`

```
RECONNAISSANCE OUTPUT:
<the structured information collected above>

KEY FILE CONTENTS:
<package.json / manifest file — full>
<entry point file — full>
<README — if present, full>
<migration/schema file names, if any>

Task: map this codebase.

1. Stack detection: language, framework, database, infrastructure — with versions
2. Architectural pattern: layered, modular, monolith, microservices?
   Is there a dependency direction rule, and is it enforced?
3. Component map: main modules and their responsibilities (C4-2 level)
4. Data model: which entities exist (inferred from file/folder names)
5. Test situation: which levels exist, a rough coverage estimate
6. Technical debt signals:
   - Outdated/unmaintained dependencies
   - Test gaps
   - Configuration/secret management problems
   - Architectural inconsistencies
   - Missing documentation
7. Unknowns: what you could not infer from the code and must be asked of the user

Rule: mark anything you are not sure about as "GUESS:".
If you need to read additional files, SAY which ones and list them — do not perform
a broad scan yourself.
```

If the agent requests specific files, **read them and send them in a single second round**.
At most one additional round.

## 3. Questions for the user

From the agent's "Unknowns" list, ask via `AskUserQuestion` (at most 4):
- What is this project for / who are its users?
- What stage is it at (in production, in development)?
- What is the biggest known problem?
- What do you want to use App Studio for: `Adding new features` /
  `Refactoring / paying down debt` / `Producing documentation` / `Raising quality`

## 4. Present

```
## Codebase Analysis

Stack: <language> <framework> | <database> | <infrastructure>
Volume: ~<N> files, <M> dependencies
Architecture: <pattern> — <consistency assessment>

Components
| Module | Responsibility | State |

Tests: <levels> — rough coverage <estimate>
CI/CD: <present/absent — what it does>

Technical debt (in priority order)
| # | Debt | Impact | Estimated cost |

Unknowns: <what was asked of the user>
Items marked GUESS: <n> — these need verification
```

## 5. Write

- `docs/CONTEXT.md` — fill in the template, mark unknowns as `<to be verified>`
- `docs/architecture/ARCHITECTURE.md` — a **draft** (with the note
  "Reverse-engineered — not verified")
- `product/risks.md` — the technical debt items as risks
- `.state/project.json` — `phase: "operate"` or according to the user's chosen purpose
- Create any missing `.claude/` directory structure (the directories from `/kickoff` step 6)

## 6. Suggest the next step

Based on the user's purpose:

| Purpose | Next |
|---|---|
| Adding new features | `/prd` (for the new feature only) → `/epics` → `/stories` |
| Refactoring / debt | `/architecture` (target architecture) → `/adr` → `/epics` |
| Documentation | `/api-contract` (from the existing code) → `/data-model` |
| Raising quality | `/test-plan` → `/qa-run` → `/security-review` |

```
✓ The codebase is now in the system.
  docs/CONTEXT.md and the draft architecture are ready.

⚠ The architecture document is REVERSE-ENGINEERED — it has not been verified.
  <n> items are marked as GUESS.

▶ Next: <the command matching the purpose>
```

---

## Token note

- The reconnaissance step is **free** and stops the agent from searching blindly —
  the most critical saving here.
- **1-2 agent calls.**
- Do not read all the source code. The manifest, entry point and README are enough;
  anything further is targeted and only on the agent's request.
- For large codebases, proceed module by module rather than mapping everything at once.
