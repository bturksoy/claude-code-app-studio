# Token Budget and Optimization Protocol

This system runs many agents; left unchecked, token consumption explodes.
The rules below are **binding** and referenced from every agent definition.

---

## 1. The context pyramid

An agent must get information from the **cheapest layer** that works. Only descend
when the layer above is insufficient.

```
Layer 1 (free)        → The task packet (story/task file) — self-sufficient by design
Layer 2 (cheap)       → docs/CONTEXT.md (≤200 lines) + .state/project.json
Layer 3 (medium)      → The relevant SSoT file (PRD / ADR / OpenAPI / schema) — targeted section
Layer 4 (expensive)   → Targeted Grep in source code
Layer 5 (very costly) → Reading whole files, scanning directories
```

**Rule:** Before descending to Layer 5, state which Layer 3 file is missing.
The answer is usually "documentation is missing", not "read more code".

---

## 2. Read budgets (per agent, per task)

| Agent tier | Max whole-file reads | Max greps | Note |
|---|---|---|---|
| Executive (ceo, cto) | 3 | 5 | Summary and decision files only |
| Product/Planning | 6 | 10 | PRD/FRD is their own domain |
| Engineering | 8 | 15 | Story + contract + the module being touched |
| Quality | 8 | 20 | Broad search is reasonable for testing |

If the budget will be exceeded, the agent **stops** and reports:
> "Budget exceeded. To continue I need to look at X as well — do you approve?"

---

## 3. Subagent (Task) protocol

When one agent calls another:

- **Input:** the task plus a **summary** of the required context. Never say "read
  these files" — embed the needed content in the prompt. The subagent starts blind;
  the less it searches, the better.
- **Output:** the subagent returns a **structured summary** — never a full transcript,
  file dump, or chain of thought. Standard format:

```
VERDICT: <APPROVED | CONDITIONAL | REJECTED | COMPLETE | BLOCKED>
SUMMARY: <at most 3 sentences>
FINDINGS:
- [LEVEL] <file:line> — <one sentence>
NEXT STEP: <one line>
```

- **Parallelism:** independent work is called in parallel in a single message.
  Dependent work is chained. **Never** spawn an agent "just in case".

---

## 4. Model selection

| Work type | Model | Example |
|---|---|---|
| Ambiguous, strategic, many variables | `opus` | Architecture decisions, scope negotiation, requirements elicitation |
| Defined input → defined output | `sonnet` | Story implementation, test writing, code review |
| Mechanical/templated | `haiku` | Changelog, index refresh, filename checks, formatting |

Before promoting work to a larger model, ask: *is the input actually clear?*
If not, the fix is not a bigger model — it is a **better task packet**.

---

## 5. The task packet principle

A story/task file must be **self-sufficient**. It contains:

- The relevant acceptance criteria (copied, not referenced)
- The **decision summary** of the governing ADR (so the ADR need never be opened)
- The file paths to touch (identified, not guessed)
- What is out of scope (neighbouring stories)
- Ready-made test scenarios

This lets the engineering agent read 1 file instead of 8.
**This is where the largest token savings come from.**

---

## 6. Gate mode

Contents of `product/review-mode.txt`:

| Mode | Gates that run | Typical overhead |
|---|---|---|
| `full` | All (~14 gates) | +60% |
| `lean` | Phase transitions only (~5 gates) | +20% |
| `solo` | None | +0% |

Every skill reads this file before invoking a gate and skips accordingly.

---

## 7. Documentation hygiene

- **Bloat control:** if `docs/CONTEXT.md` exceeds 200 lines or `docs/DECISIONS.md`
  exceeds 300, run `/context-compact`.
- **Index files:** every collection directory (`adr/`, `epics/`, `test-cases/`) has an
  `index.md`. Agents read the index first, then drill into a single file.
- **No duplication:** the same fact never lives in two files. If a copy is found,
  replace it with a link to the source.
- **Prefer append-only:** add to the decision log and changelog rather than rewriting —
  this preserves the prompt cache.

---

## 8. Session discipline

- Run **one phase per session**. When a phase ends, write state to disk with `/status`
  and start a fresh session. Long sessions incur compaction costs.
- Never print long outputs (reports, plans) twice — write to file, summarize on screen.
- Do not re-read a file just to verify an edit you made.

---

## 9. Measurement

The `/status` output includes this line for the current sprint:

```
Token note: <N> agent calls, <M> gates, mode=<lean>. Suggestion: <if any>
```

If a sprint exceeds 30 agent calls, `delivery-manager` reports that task packets
are inadequate.
