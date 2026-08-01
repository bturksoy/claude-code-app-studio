# Quality Gates

A gate is a **binding verdict** issued by the responsible manager agent at the end of
a phase. The invoking skill reads the **first line** of the subagent's reply.

---

## Verdict format

The agent invoked for a gate **must** begin its reply with:

```
<GATE-ID>: APPROVED
```
```
<GATE-ID>: CONDITIONAL
```
```
<GATE-ID>: REJECTED
```

Rationale follows. The verdict is never buried inside a paragraph — the calling skill
parses the first line.

| Verdict | Meaning | Flow |
|---|---|---|
| `APPROVED` | The phase may proceed | Continue |
| `CONDITIONAL` | Passes once the listed items are fixed | Apply items, do not re-invoke the gate |
| `REJECTED` | There is a fundamental problem | Phase goes back, user is notified |

On a `CONDITIONAL` verdict the agent lists at most **5 items**; each must be one line
and actionable (phrases like "could be better" are forbidden).

---

## Gate catalogue

| Gate ID | Phase | Invoking skill | Agent | Question | Mode |
|---|---|---|---|---|---|
| `CEO-VISION` | 0 | `/kickoff` | `ceo` | Is this project commercially meaningful and measurable? | PHASE |
| `PO-SCOPE` | 1 | `/prd` | `product-owner` | Is the scope right-sized for an MVP? | PHASE |
| `BA-REQ` | 1 | `/requirements` | `business-analyst` | Are requirements complete, consistent and testable? | PHASE |
| `QA-TESTABLE` | 1 | `/requirements` | `qa-lead` | Are the acceptance criteria verifiable? | full |
| `CTO-STACK` | 2 | `/architecture` | `cto` | Does the technology fit the team, scale and budget? | PHASE |
| `ARCH-DESIGN` | 2 | `/architecture` | `solution-architect` | Does the architecture satisfy the NFRs? | PHASE |
| `SEC-THREAT` | 2 | `/threat-model` | `security-engineer` | Are the critical threats addressed? | full |
| `UX-FLOW` | 2 | `/ux-flow` | `ux-designer` | Do the flows cover every REQ? | full |
| `DM-PLAN` | 3 | `/sprint-plan` | `delivery-manager` | Does the plan fit capacity and dependencies? | PHASE |
| `ARCH-STORY` | 3 | `/stories` | `solution-architect` | Are stories split in line with the architecture? | full |
| `CR-CODE` | 4 | `/code-review` | `code-reviewer` | Is the code correct, readable and compliant? | lean+ |
| `QA-DONE` | 4 | `/dod-check` | `qa-lead` | Does the evidence satisfy the DoD? | PHASE |
| `SEC-REVIEW` | 4 | `/security-review` | `security-engineer` | Any release-blocking vulnerability? | full |
| `PERF-BUDGET` | 4 | `/perf-check` | `performance-engineer` | Do the performance budgets hold? | full |
| `OPS-READY` | 5 | `/release` | `devops-engineer` | Are environment, rollback and monitoring ready? | PHASE |
| `CEO-GONOGO` | 5 | `/release` | `ceo` | Are we shipping? | PHASE |

**Mode column:**
- `PHASE` → runs in `lean` and `full`, skipped in `solo`
- `full` → runs only in `full` mode
- `lean+` → runs in `lean` and `full` (code review is critical)

---

## Gate invocation pattern

Every skill applies this block before invoking a gate:

```
1. Read product/review-mode.txt (assume "lean" if missing)
2. Compare against the gate's Mode column:
   - solo  → skip, note: "<GATE-ID> skipped — solo mode"
   - lean  → run only PHASE and lean+ gates
   - full  → run all
3. If it runs: invoke the agent via the Agent tool.
   Embed the following in the prompt (CONTENT, not file paths):
     - The gate ID and its question
     - A summary of the output to evaluate (≤100 lines)
     - The evaluation criteria
   End the prompt with: "Begin your reply with '<GATE-ID>: APPROVED|CONDITIONAL|REJECTED'."
4. Parse the first line and branch on the verdict.
```

---

## Gate economics

Gates are the single largest token cost. Rules:

- A gate is invoked **once**. It is not re-invoked after `CONDITIONAL` items are fixed.
- Never embed whole files in a gate prompt; embed a **summary**.
- If a phase has multiple gates, invoke them **in parallel** (one message, multiple
  Agent calls).
- If the user wants to skip a gate manually: `/skill --gate=off`.

---

## Gate history

Every gate result is appended to `.state/gates.jsonl` as one line:

```json
{"gate":"ARCH-DESIGN","verdict":"CONDITIONAL","phase":2,"sprint":null,"items":3}
```

`/status` reads this file to report open `CONDITIONAL` items.
