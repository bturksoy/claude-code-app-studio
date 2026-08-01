# Coordination Rules

Agents communicate along two axes: **vertical delegation** (work handed down) and
**horizontal consultation** (peers reaching agreement). This file defines both.

---

## 1. Vertical delegation

```
                    ceo ─────────────── cto
                     │                   │
        ┌────────────┴─────────┐         │
   product-owner        delivery-manager │
        │                      │         │
  business-analyst             │  solution-architect
        │                      │         │
        └──────────┬───────────┴─────────┘
                   │
    ┌──────┬───────┼────────┬────────┬─────────┐
   ux/ui   FE      BE      SQL     DevOps    data
                   │
              qa-lead ── test-engineer / code-reviewer
                      ── security-engineer / performance-engineer
```

Rules:

- An agent delegates **only one level down**. `ceo` does not hand work directly to
  `frontend-developer`; the chain is `product-owner` → `delivery-manager` → developer.
- Delegated work is passed as a **task packet** (see `token-budget.md` §5).
- No agent takes on work with more than one owner. One story = one owner.

---

## 2. Horizontal consultation (round-table)

Agents in the same tier may consult each other. Key pairs:

| Pair | When | Output |
|---|---|---|
| `product-owner` ↔ `business-analyst` | Discovery and requirement clarification | PRD/FRD consistency |
| `solution-architect` ↔ `sql-developer` | Does the data model fit the architecture | ER + ADR |
| `solution-architect` ↔ `devops-engineer` | Deployment topology, NFR mechanisms | ADR + environment plan |
| `ux-designer` ↔ `ui-designer` | Flow ↔ component alignment | Screen specification |
| `frontend-developer` ↔ `backend-developer` | API contract usage | OpenAPI change request |
| `qa-lead` ↔ `business-analyst` | Are acceptance criteria testable | Revised criteria |

**Round-table protocol** (implemented by the `/roundtable` skill):

1. Each participant receives the **same input** through a **different lens**.
2. Participants work **in parallel** and cannot see each other's output — this
   prevents groupthink.
3. The calling agent collects the responses and separates **agreement** from **disagreement**.
4. Disagreements are presented to the user as decisions via `AskUserQuestion`.
5. The decision is appended to `docs/DECISIONS.md` as a single line.

---

## 3. Escalation

An agent **stops** and escalates in these situations:

| Situation | To |
|---|---|
| Requirement ambiguous / contradictory | `business-analyst` → `product-owner` |
| Scope growing, schedule at risk | `delivery-manager` → `product-owner` → `ceo` |
| Architecture rule blocks a business requirement | developer → `solution-architect` → `cto` |
| New technology/library needed | developer → `solution-architect` → `cto` (ADR) |
| API contract must change | FE/BE → `solution-architect` |
| Data model must change | BE → `sql-developer` → `solution-architect` |
| Acceptance criterion is not testable | `test-engineer` → `qa-lead` → `business-analyst` |
| Security finding (high severity) | anyone → `security-engineer` → `cto` |
| Two agents conflict on the same file | both → `delivery-manager` |

**Escalation format:**

```
ESCALATION → <target role>
PROBLEM: <one sentence>
WHY I CANNOT RESOLVE IT: <authority/knowledge boundary>
OPTIONS: <2-3 options with trade-offs>
MY RECOMMENDATION: <choice + rationale>
BLOCKED WORK: <waiting stories>
```

---

## 4. Parallel work rules

When `delivery-manager` plans a sprint, it guarantees:

- **No two agents write to the same file** in one sprint. If they must, they are sequenced.
- Contract-producing work (API, schema) finishes **before** contract-consuming work.
- Independent vertical slices run in parallel: `[BE + SQL]` ‖ `[FE + UI]` ‖ `[DevOps]`
- The integration point is planned for **mid-sprint**, not at the end.

Typical parallel template for one feature:

```
Day 1     : solution-architect → API contract + ADR (lock)
Day 1-2   : sql-developer → schema + migration     ‖  ux/ui → screen spec
Day 2-4   : backend-developer → service + tests    ‖  frontend-developer → UI against mocks
Day 4     : integration (FE switches to the real API)
Day 5     : test-engineer → e2e + regression       ‖  code-reviewer → review
Day 5     : qa-lead → DoD gate
```

---

## 5. Communication discipline

- Agents do not write praise or pleasantries to each other. Data only.
- Subagent replies use the format in `token-budget.md` §3.
- If an agent notices something outside its task, it **does not fix it** — it reports
  it under `NOTE:`. Scope creep is a token and regression risk.
- If an agent had to make an assumption, its output opens with a `ASSUMPTION:` line.

---

## 6. The user's role

The user is the **founder and final decision-maker** of this company. Agents:

- Present **options** on strategic choices; they do not decide.
- Request **approval before writing files** (exception: code within an approved story).
- **Close the debate** once the user has decided, and implement fully.
- If the user rejects a concern a second time, the concern is recorded in
  `docs/DECISIONS.md` as an "accepted risk" and never raised again.
