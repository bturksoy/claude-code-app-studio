---
name: adr
description: Produces an Architecture Decision Record (ADR). Permanently records a technical decision, the alternatives considered, the consequences, and the implementation guidance. The instructions the developer sees inside a story are produced here.
---

# /adr "<decision topic>"

Owner: `solution-architect`, approval: `cto`.
Output: `docs/architecture/adr/ADR-NNNN-<slug>.md`

---

## 1. Number and topic

Find the highest number under `docs/architecture/adr/` with Glob and add 1.
If there is no argument, pick from the "Proposed" list in `adr/index.md` or ask the user.

## 2. Situations that require an ADR (check first)

If it is none of these, do not write an ADR — one line in `docs/DECISIONS.md` is enough:
- A new dependency / library / service
- A data storage or modelling approach
- An authentication / authorization approach
- An integration pattern (sync/async, queue, webhook)
- A concurrency or consistency model
- An error/retry/rollback strategy
- A versioning or backward-compatibility policy
- Any irreversible choice

## 3. Invoke `solution-architect`

```
Decision topic: <topic>
Context: <CONTEXT.md summary + relevant NFRs + current stack>
Related requirements: <REQ/NFR list>
Existing ADRs: <titles from adr/index.md — for conflict checking>

Task: produce ADR-<NNNN>.

## Context
Which forces drive this decision — requirement-referenced, one paragraph

## Options considered
At least 3 (one must be "do nothing / keep the status quo").
| Option | Pros | Cons | Why eliminated |

## Decision
One paragraph, imperative: "We will use X."

## Consequences
Positive: | Negative (cost we accept): | Reversal cost: low/medium/high

## Implementation guidance
CRITICAL SECTION — this gets copied into story files.
Write it concretely enough that the developer never needs to open the ADR:
- Which file/layer does what
- The required pattern (described at code level)
- The forbidden pattern
- Configuration / naming rules

## Verification
How we check this decision was applied: a test, a lint rule, a code review item,
or an architecture fitness function.

If it conflicts with an existing ADR, SAY SO — which ADR, and how.
```

## 4. `cto` approval (lean+ mode)

```
<ADR DRAFT — full text>

Task: approve or reject.
Criteria: were the alternatives genuinely evaluated (in good faith),
are the consequences written honestly, does it satisfy the NFRs,
was a simpler option eliminated by mistake, is the exit cost acceptable.

Begin your reply with "ADR-<NNNN>: ACCEPTED|CONDITIONAL|REJECTED".
```

Skip in `solo` mode; the status becomes `Accepted` directly.

## 5. Write

- `docs/architecture/adr/ADR-NNNN-<slug>.md` — status `Accepted` or `Proposed`
- Append a row to `docs/architecture/adr/index.md`:
  `| ADR-NNNN | <title> | Accepted | <date> | <area affected> |`
- Append one line to `docs/DECISIONS.md`
- If it **supersedes** an existing ADR: set the old one's status to
  `Superseded (by ADR-MMMM)` and **do not delete its content**

## 6. Close

```
✓ ADR-<NNNN>: <title> — <status>
  Affects: <REQ/module list>

The implementation guidance will be copied into stories (/stories does this automatically).

▶ Next: <the next suggested ADR, if any> or /data-model | /api-contract
```

---

## Token note

- **1-2 agent calls.** The ADR draft is embedded in full for the CTO (it is a short document).
- Only the **index titles** of existing ADRs are embedded, never their contents.
- Invest in the "Implementation guidance" section — because of it, the developer agent
  never opens the ADR file. That is a direct token saving.
