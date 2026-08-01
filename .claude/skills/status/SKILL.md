---
name: status
description: Produces the project status dashboard — phase, sprint, progress, blocked work, open gates, risks and a token-usage note. Then suggests a single next step.
---

# /status

Owner: `delivery-manager`. **Invokes no agents by default** — it reads files.

---

## 1. Gather the data (all cheap)

| Source | What is taken |
|---|---|
| `.state/project.json` | phase, sprint, mode, scale, counters, stack |
| `docs/CONTEXT.md` | current focus, known debt |
| `product/sprints/sprint-NN.md` | assignments and statuses |
| Story files (header blocks) | status, owner, type |
| `.state/gates.jsonl` | gate history, open CONDITIONAL items |
| `product/risks.md` | active risks |
| `docs/qa/bugs/` | open bugs (header blocks) |
| `.state/agent-log.jsonl` | agent call count (for the token note) |

## 2. Produce the dashboard

```
╭─ <Project name> ─────────────────────────────────────────
│ Phase: <phase>   Sprint: <NN>   Mode: <mode>   Scale: <scale>
│ Stack: <summary>
╰───────────────────────────────────────────────────────────

PROGRESS
  Epics    ████████░░  <a>/<b>
  Stories  ██████░░░░  <c>/<d> DONE
  Sprint <NN>  Day <x>/<y>

SPRINT <NN> — <goal>
| Story | Owner | Type | Status |
| 004 | backend-developer | Logic | DONE |
| 005 | frontend-developer | UI | In progress |
| 006 | test-engineer | Integration | Blocked ⚠ |

BLOCKED (<n>)
  story-006 — <reason> → <who it should be escalated to>

OPEN GATE CONDITIONS (<n>)
  ARCH-DESIGN CONDITIONAL — <n> items open

RISKS (active, high)
  | Risk | Probability×Impact | Owner | Mitigation |

OPEN BUGS
  P0: <a>  P1: <b>  P2: <c>

TECHNICAL DEBT
  <from CONTEXT.md, at most 3 lines>

TOKEN NOTE
  This sprint: <N> agent calls, <M> gates, mode=<mode>.
  <if N>30: "Task packets are inadequate — /stories output should include ADR
  summaries and file paths.">

▶ NEXT STEP
  <a single command> — <one-sentence rationale>
```

## 3. Deciding the next step

Priority order (the first match wins):

```
1. A blocked story           → an escalation suggestion (to which role, what to ask)
2. An open CONDITIONAL item  → the command that closes those items
3. An open P0 bug            → /dev-task <fix story>
4. Sprint in progress        → /dev-task <next story on the critical path>
5. Sprint stories finished   → /dod-check sprint
6. Sprint closed             → /retro → /sprint-plan
7. Phase stories finished    → /release <version>
8. Phase closed              → /roadmap (next phase) or /requirements
```

## 4. `/status --deep` mode

If the user wants a deeper analysis, invoke `delivery-manager`:

```
<DASHBOARD DATA>
Story completion rate over the last 2 sprints: <data>
Estimate vs actual: <data>

Task: delivery health analysis.
1. Velocity trend — accelerating or slowing, and why
2. Estimate accuracy — is there a systematic bias
3. Bottleneck role — which agent is constantly on the critical path
4. Process problem — recurring causes of blocking
5. At most 3 concrete improvement suggestions
```

This mode is optional and invokes a single agent.

## 5. Update

Refresh the "Current work" section of `docs/CONTEXT.md` from the dashboard.
`.state/project.json` → `lastUpdated`.

---

## Token note

- The default mode is **entirely free** — file reads only.
- Read the **header blocks** of story files (first 8 lines), not their full contents.
- Running `/status` at the start of every session makes the following steps start with the
  right context — an indirect but large saving.
