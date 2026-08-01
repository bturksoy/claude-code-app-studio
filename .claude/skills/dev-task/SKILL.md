---
name: dev-task
description: Implements a single story end to end. Runs a readiness check, invokes the right developer agent, runs the tests, obtains a code review and updates the story. The main development loop.
---

# /dev-task <story-path>

Output: code + tests + an updated story file.

---

## 1. Load the story and check readiness

Without an argument, suggest the next story in the current sprint (critical path first).

Read the story file. **Readiness check** (no agent):

```
[ ] Is the status "Ready"? (if Blocked, show why and stop)
[ ] Are the acceptance criteria present and in Given/When/Then form?
[ ] Is "Architecture decisions to apply" filled in (or "N/A — <reason>")?
[ ] Is the "Contract" section filled in (for types that need it)?
[ ] Is there a "Files to touch" list?
[ ] Is "Test scenarios" filled in (for Logic/Integration)?
[ ] Are the stories it depends on DONE?
```

If anything is missing, **stop**:
```
⚠ Story not ready: <missing items>
Fix: re-run /stories <epic> or complete the story manually.
If you continue anyway, the developer agent will have to read extra files
(higher token cost and higher error risk).
```
`AskUserQuestion`: `Fix the story (Recommended)` / `Continue anyway`

If a dependency is not DONE, **stop unconditionally** — do not break the ordering.

## 2. Select the right agent

The story's `Owner` field decides. If there is no match, derive it from the type:

| Type / content | Agent |
|---|---|
| UI, screen, component | `frontend-developer` |
| Logic/Integration, endpoint, business rule | `backend-developer` |
| Data, schema, migration, index | `sql-developer` |
| Infra, pipeline, environment | `devops-engineer` |
| ETL, report, event | `data-engineer` |
| Test automation | `test-engineer` |

## 3. Invoke the developer agent

**Embed the ENTIRE story file in the prompt.** Do not give a path and have it read the
file — the task packet was written to be self-sufficient.

```
<THE FULL CONTENT OF THE STORY FILE>

Additional context:
- Project stack: <stack summary>
- Coding rules to apply: .claude/rules/<relevant>.md
  <the content of the relevant rules file is also embedded — about 40 lines>

Task: implement this story.

1. Turn the acceptance criteria into a checklist
2. Work with the files in the "Files to touch" list.
   If the list is incomplete, search with targeted Grep — do NOT scan directories.
3. If similar code exists, extend it rather than copy-pasting
4. Write tests against the TCs in the "Test scenarios" section.
   Do not invent tests from scratch.
5. RUN the tests and look at the output. Never say "it should pass".
6. Do NOT do the work listed under "Out of scope".

Output format:
VERDICT: COMPLETE | BLOCKED
SUMMARY: <3 sentences>
FILES: <paths>
TESTS: <command> → <passed/total>
ACCEPTANCE CRITERIA: AC-1 ✓ | AC-2 ✓ | AC-3 ✗ <why>
NOTE: <out-of-scope observations — do NOT fix, just report>
NEXT STEP: <one line>
```

If it returns `BLOCKED`: classify the cause, escalate to the right role
(`.claude/docs/coordination-rules.md` §3), inform the user, stop.

## 4. Code review (lean+ mode)

Invoke `code-reviewer`:

```
<CONTENT OF THE CHANGED FILES or the git diff>
<THE STORY'S acceptance criteria + business rules + out-of-scope section>
<CONTENT OF THE RELEVANT .claude/rules/*.md>

Task: the CR-CODE gate. Review order: correctness → security → scope fidelity
→ rule compliance → readability → test quality.

Each finding: [BLOCKER|MAJOR|MINOR|NOTE] <file:line> — <one-sentence claim + reason>
At most 15 findings. Do not write style preferences.
Begin your reply with "CR-CODE: APPROVED|CONDITIONAL|REJECTED".
```

| Verdict | Action |
|---|---|
| `APPROVED` | Go to step 5 |
| `CONDITIONAL` | Send the MAJOR findings to the developer **in one round**, have them fixed, do not re-invoke the gate |
| `REJECTED` | Send the BLOCKER findings to the developer, have them fixed, **invoke the gate once more** |

Skip this step in `solo` mode.

## 5. Update the story

- Tick the acceptance-criteria checkboxes
- `**Status:**` → `In review` (the DoD has not been passed yet)
- Write the test file path and result into the `## Required evidence` section
- Update the `**Updated:**` date

## 6. Present

```
✓ Story <NNN>: <title>
  Owner: <agent> | Type: <type>

Files: <N> changed, <M> new
Tests: <passed>/<total> ✓
Acceptance criteria: <X>/<Y> ✓
Code review: CR-CODE <verdict> (<a> findings fixed)

NOTE (out-of-scope observations):
- <what the developer reported>

▶ Next: /dod-check <story-path>
   or straight to the next story: /dev-task <path>
```

If there are out-of-scope observations, ask the user whether they should be added to the
backlog as stories.

---

## Token note — why this skill should be cheap

- **1-2 agent calls** (developer + [lean+: reviewer]).
- The developer agent **reads no documentation files** — everything is embedded in the story.
- The rules file is embedded too (40 lines, fixed content, prompt-cache friendly).
- The readiness check is free and **prevents round-trips** — that is the biggest saving.
- If a story takes more than 3 rounds, that is a task-packet quality problem; report it
  to `delivery-manager` and fix the same mistake in the next `/stories` run.
