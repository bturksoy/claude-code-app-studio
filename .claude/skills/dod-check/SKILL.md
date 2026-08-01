---
name: dod-check
description: Audits a story, sprint or release against the Definition of Done using evidence. The gate where "done" is decided. Operates the QA-DONE gate.
---

# /dod-check [story-path | sprint | release]

Owner: `qa-lead`. No approval is given without evidence.

---

## 1. Determine the scope

| Argument | Scope |
|---|---|
| story path | Single-story DoD |
| `sprint` | Every story in the current sprint + the sprint DoD |
| `release` | The release scope + the release DoD |
| none | Stories in the current sprint with status `In review` |

## 2. Collect the evidence (no agent — this is the cheap part)

For a story:
- The story file: acceptance-criteria checkboxes, the `Required evidence` section, the type
- Does the named test file **actually exist** (Glob)
- **Run** the tests (Bash) and capture the output — do not trust claims
- The code review verdict (`.state/gates.jsonl`)
- Whether the work in the `Out of scope` section was done (check via git diff)

For sprint/release, additionally: the regression suite result, open `CONDITIONAL` gate
items, open P0/P1 bugs.

## 3. Invoke `qa-lead`

```
Scope: <story/sprint/release>

<STORY INFORMATION: title, type, acceptance criteria and their checked state,
 business rules, out-of-scope section>

COLLECTED EVIDENCE:
- Test file: <path> — exists/missing
- Test run output:
  <the real command output — do not truncate, give it verbatim>
- Code review: CR-CODE <verdict>, <a> findings fixed
- Changed files: <list>
- Was the out-of-scope section touched: <yes/no — evidence>

Task: the QA-DONE gate.

Checklist (.claude/docs/definition-of-done.md):
1. Are all acceptance criteria checked AND is each bound to a test?
   (check whether AC-N appears in the test name)
2. Does the story type's required evidence exist and PASS?
3. Are error/edge scenarios tested? (happy path only → REJECTED)
4. Is traceability complete: test → AC → REQ → GOAL
5. Is there any scope overreach?
6. Is the code review closed?

Look at the evidence, do not trust claims. If the test output contains failures, REJECTED.
Begin your reply with "QA-DONE: APPROVED|CONDITIONAL|REJECTED".
If CONDITIONAL, list at most 5 actionable items.
```

## 4. Process the verdict

| Verdict | Action |
|---|---|
| `APPROVED` | Story `Status: DONE`, `.state/project.json` → `counters.done++` |
| `CONDITIONAL` | Show the items, have the relevant agent fix them, **do not re-invoke the gate** — approval is implied after the fix |
| `REJECTED` | Story returns to `Ready`, report the gaps to `delivery-manager` |

## 5. Present

```
## DoD Audit — <scope>

| Story | Type | AC | Tests | Review | Verdict |
| 004 | Logic | 3/3 ✓ | 7/7 ✓ | APPROVED | APPROVED |
| 005 | UI | 2/3 ⚠ | 4/5 ✗ | CONDITIONAL | REJECTED |

Evidence summary:
  Tests: <passed>/<total>
  Coverage: <percentage, if available>
  Open findings: <n>

Reasons for REJECTED/CONDITIONAL:
  story-005: no test for AC-3; the empty-list scenario is untested

▶ Next: <depending on the situation>
```

## 6. Additional checks in sprint/release mode

```
Sprint DoD:
[ ] Was the sprint goal met (otherwise document the variance)
[ ] Is every story DONE or returned to the backlog with a reason
[ ] Is the regression suite green
[ ] Are there no open CONDITIONAL gate items (.state/gates.jsonl)
[ ] Was docs/CONTEXT.md updated
[ ] Was product/risks.md reviewed

Release DoD: (.claude/docs/definition-of-done.md — Release DoD section)
```

## 7. Record

- `.state/gates.jsonl` → the QA-DONE line
- Status updates in the story files
- `.state/project.json` → counters
- `docs/CONTEXT.md` → "Current work" (in sprint mode)

---

## Token note

- **1 agent call.** Evidence collection is free (file reads + Bash).
- Embed the test output **without truncating** — the entire value of this gate is in the evidence.
- If several stories are being audited, send them **all in one call**; never one call per story.
