---
name: team-feature
description: Delivers a feature (epic) end to end with the whole team — contract, data, service, interface, tests, review. Runs agents in the right order and in parallel where possible. Vertical slice delivery.
---

# /team-feature <epic-slug>

A multi-agent vertical slice orchestrated by `delivery-manager`.
Instead of calling `/dev-task` one story at a time, it finishes a whole feature in one pass.

**When to use:** the epic's stories are ready and interdependent; sequential `/dev-task`
calls would lose context between them.

**When not to use:** single-story work (`/dev-task` is enough) or stories that are not
ready (run `/stories`).

---

## 1. Preparation

Load the epic's stories (header blocks). Check:
- Are all stories `Ready`? List any that are blocked and stop.
- Is the dependency graph acyclic?
- Is the total story count ≤ 8? If more, do it in two passes.

Derive **waves** from the dependency graph:

```
Wave 1 (parallel): stories with no dependencies
Wave 2 (parallel): stories depending only on Wave 1
Wave 3: ...
```

Stories that touch the same module are **never placed in the same wave** — push them
to the next one.

## 2. Present the plan

```
## Vertical Slice: <epic name>

Wave 1 — parallel  [contract & foundation]
  story-001  sql-developer      <title>
  story-002  solution-architect <title>

Wave 2 — parallel  [service & interface]
  story-003  backend-developer  <title>
  story-004  frontend-developer <title>  (starts against mocks)

Wave 3 — sequential [integration & testing]
  story-005  frontend-developer <title>  (switches to the real API)
  story-006  test-engineer      <title>

Total: <N> stories | Estimated agent calls: <M>
```

`AskUserQuestion`: `Start (Recommended)` / `Run Wave 1 only` /
`I'll proceed story by story with /dev-task`

## 3. Run the waves

For each wave:

**a) Parallel call** — every story in the wave in one message, each to its own agent.
Each prompt uses the format from `/dev-task` step 3 (story fully embedded).

**b) Collect the results.** Each agent returns:
`VERDICT / SUMMARY / FILES / TESTS / ACCEPTANCE CRITERIA / NOTE`

**c) Conflict check.** If two agents wrote to the same file:
- Compare the changes and show any conflict to the user
- This is a **planning error** — note it for the next `/sprint-plan`

**d) Wave gate.** If a story returned `BLOCKED`:
- **Stop** the stories in later waves that depend on it
- Independent ones continue
- Report the situation to the user and escalate

**e) Handoff note.** When moving to Wave 2, prepare what the next wave needs from
Wave 1's output as a **handoff packet of ≤200 words** and add it to the next wave's prompt:

```
FROM THE PREVIOUS WAVE:
- <story-001> complete → <what was produced: table/endpoint/type names>
- Watch out: <assumption, pitfall>
- Available to you: <file paths, function/type names>
```

## 4. Bulk code review (lean+ mode)

Once all waves finish, make **a single** `code-reviewer` call (not one per story):

```
<DIFF OF ALL CHANGED FILES>
<THE EPIC'S acceptance criteria and scope boundary>
<RELEVANT rules files>

Task: CR-CODE — vertical slice review. Additionally check:
- Cross-layer consistency (does what the FE expects match what the BE returns)
- Contract conformance (OpenAPI vs the actual implementation)
- Duplicated code (two agents may have written the same helper separately)
```

## 5. Integration verification

Run the end-to-end tests (if any). If there are none, have `test-engineer` write one:

```
Epic: <name> — the main user journey
Task: write and run 1 end-to-end test for this slice.
Scope: <flow steps>
```

## 6. Present

```
✓ Vertical slice complete: <epic>

| Story | Owner | Status | Tests |
| 001 | sql-developer | ✓ | 4/4 |
| 004 | frontend-developer | ⚠ | 6/7 — <note> |

Total: <a> complete, <b> blocked
Code review: CR-CODE <verdict>
End-to-end: <result>

Planning notes (for the next sprint):
- <conflict or dependency surprise>

▶ Next: /dod-check <epic>  → /qa-run <epic>
```

---

## Token note

- Parallelism buys **wall-clock time, not tokens** — cost still scales with story count.
  You are doing the same work, just faster.
- **Bulk code review** is the real saving: 1 review instead of 6.
- Handoff packets are ≤200 words — context transfer between waves must stay cheap.
- The 8-story ceiling exists because beyond it both conflict and context risk rise.
