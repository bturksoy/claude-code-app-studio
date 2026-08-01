---
name: roundtable
description: Runs several roles in parallel on any topic, gathers analysis through different lenses, separates agreement from disagreement, and presents the decision to the user. A general-purpose discussion tool for hard, cross-disciplinary decisions.
---

# /roundtable "<topic>"

A general-purpose multi-role discussion. `/discovery` is a specialized version of this.

---

## 1. Determine the topic and participants

If there is no argument, ask: *"What topic should we discuss?"*

Suggest participants based on the topic (confirm with `AskUserQuestion`, **at most 4 roles**):

| Topic type | Suggested participants |
|---|---|
| Scope / priority | `product-owner`, `business-analyst`, `delivery-manager` |
| Technology choice | `cto`, `solution-architect`, `devops-engineer` |
| Data model | `solution-architect`, `sql-developer`, `business-analyst` |
| User experience | `ux-designer`, `product-owner`, `frontend-developer` |
| Performance problem | `performance-engineer`, `solution-architect`, `sql-developer` |
| Security approach | `security-engineer`, `solution-architect`, `backend-developer` |
| Quality / definition of done | `qa-lead`, `business-analyst`, `delivery-manager` |
| Release decision | `ceo`, `qa-lead`, `devops-engineer` |

**Never invoke more than 4 roles.** Marginal value drops while cost grows linearly.

## 2. Build a shared context block

Write a single context block (≤ 50 lines) and send **the same one to everyone**:

```
TOPIC: <topic>
CONTEXT: <relevant project information — summarized from CONTEXT.md>
CONSTRAINTS: <known limits>
DECISION REQUIRED: <the precise question>
CURRENT STATE: <what exists today>
```

Do not give file paths — embed the content. The subagent should not have to search.

## 3. Parallel call (all in one message)

Give each role **its own lens**:

```
<CONTEXT BLOCK>

Lens: <role-specific angle — from the table below>

Produce:
1. What you see when you look at this from your discipline (at most 5 bullets)
2. The biggest risk / the thing being missed
3. Your recommendation and its rationale
4. The cost you accept along with that recommendation
5. When would we know this decision was wrong

At most 25 lines. Do not guess what the other roles will say; stay in your domain.
```

Lenses:

| Role | Lens |
|---|---|
| `ceo` | Business value, cost, reversibility |
| `cto` | Technology risk, operating cost, lock-in |
| `product-owner` | User value, priority, scope impact |
| `business-analyst` | Ambiguity, contradiction, missing scenario |
| `solution-architect` | Component boundaries, coupling, NFR mechanisms |
| `delivery-manager` | Schedule, dependencies, capacity, risk |
| `ux-designer` | The experience the user will have, step count |
| `sql-developer` | Data integrity, query cost, migration risk |
| `devops-engineer` | Deployment, rollback, observability, cost |
| `qa-lead` | Testability, regression risk |
| `security-engineer` | Attack surface, data exposure |
| `performance-engineer` | Behaviour at scale, bottlenecks |

## 4. Synthesis (you do this)

```markdown
## Round-table: <topic>
Participants: <roles>

### Shared view
<what everyone agreed on — bulleted>

### Divergence
| # | Topic | <Role A> | <Role B> | Why it matters |

### What nobody said
<the gap you noticed during synthesis — if any>

### Decision options
**A) <name>** — <what it means> | Gain: <...> | Cost: <...> | Reversal: <easy/hard>
**B) <name>** — ...

**Recommendation:** <A or B> — <one-sentence rationale>
```

## 5. Take and record the decision

Present the options with `AskUserQuestion` (recommendation first, labelled "(Recommended)").

After the decision:
- Append one line to `docs/DECISIONS.md`:
  `| <date> | <decision> | user | <rationale> | /roundtable |`
- If the decision is architectural, suggest running `/adr`
- If it affects scope, suggest `/scope-check`
- Tell the affected roles what changed, in one line each (in the report)

---

## Token note

- Participant count **scales cost linearly**. Three is ideal, four is the ceiling.
- Everyone receives the same context block → prompt-cache friendly.
- One round. A second round happens only if the user provides new information.
- Synthesis and decision are the model's job — do not spawn a separate agent for them.
