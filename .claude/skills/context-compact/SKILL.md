---
name: context-compact
description: Compacts bloated documents, refreshes index files, checks whether content copied into stories is still in sync with its source, and removes duplication. Provides a direct token saving.
---

# /context-compact

Owner: `delivery-manager`. When to run: at the end of a sprint, or when `/status` warns.

---

## 1. Bloat audit (free)

```
docs/CONTEXT.md        ≤ 200 lines   → compact if exceeded
docs/DECISIONS.md      ≤ 300 lines   → archive if exceeded
product/risks.md       ≤ 100 lines   → archive closed risks
docs/qa/bugs/          closed ones   → move under docs/qa/bugs/archive/
product/backlog/       DONE epics    → mark closed in the index
```

Measure and report the line count of each file.

## 2. Index refresh (free)

Regenerate these index files by scanning their source directories:

```
product/backlog/index.md          ← epics/*/EPIC.md
product/sprints/index.md          ← sprint-*.md
docs/architecture/adr/index.md    ← ADR-*.md
docs/qa/test-cases/index.md       ← test case files
docs/qa/bugs/index.md             ← BUG-*.md (open ones)
```

Indexes let agents read one file to survey a whole collection.

## 3. Synchronization audit ⚠ critical

Story files carry content **copied** from source documents (a deliberate SSoT exception).
If a source has changed, the copies are stale.

Check:
- Acceptance criteria in stories ↔ their current form in `FRD.md`
- ADR implementation guidance in stories ↔ the current ADR file
- Contract blocks in stories ↔ `openapi.yaml` / `ER.md`

Method: Grep the `REQ-*` and `ADR-*` references in the stories, then compare the source
files' modification dates against each story's `Updated` date. If the source is newer,
it is a **stale candidate**.

```
⚠ Possibly stale stories:
  story-004 — REQ-ORD-003 changed on <date>, story updated on <date>
```

Ask the user whether the stale stories should be refreshed (re-run `/stories` for the
relevant epic).

## 4. Compaction

If `docs/CONTEXT.md` is bloated, invoke `delivery-manager`:

```
Current CONTEXT.md:
<full content>

Additional state: <project.json summary>

Task: compact it below 200 lines.
Rules:
- PRESERVE the structure (the template sections do not change)
- REMOVE historical information — only what is currently true stays
- Reference instead of detail: a long explanation → "see <file>"
- The technology table, critical NFRs and the active focus are PRESERVED
- Drop the detail of finished sprints, keep only a summary
```

If `docs/DECISIONS.md` exceeds 300 lines: move the older entries to
`docs/decisions/archive-<year>.md` and leave a summary line in the main file.

## 5. Duplication hunt (free)

Detect the same fact living in two places:
- Is the same NFR present as full text in both `NFR.md` and `ARCHITECTURE.md`
- Is the same business rule in both `FRD.md` and `PRD.md`
- Is the same term defined differently in `data-dictionary.md` and `ER.md`

Report what you find and propose converting **the non-owning copy** into a reference
(per the SSoT table in `.claude/docs/context-protocol.md`).

## 6. Present

```
## Context Compaction

File sizes
| File | Before | After | Limit |
| docs/CONTEXT.md | 340 | 186 | 200 ✓ |

Indexes refreshed: <N> files
Archived: <a> closed bugs, <b> closed risks, <c> decisions

⚠ Stale story candidates: <n>
  story-004 — REQ-ORD-003 is newer

⚠ Duplicated content: <n>
  NFR-PERF-01 appears as full text in both NFR.md and ARCHITECTURE.md
  → should become a reference in ARCHITECTURE.md

Estimated saving: ~<N> fewer lines of context per agent call
```

## 7. Apply

Get approval via `AskUserQuestion`, then write the changes.
Archived content is **never deleted**; it moves under `archive/`.

---

## Token note

- The audit and index refresh are **entirely free**.
- At most **1 agent call** for the compaction itself.
- This skill is cheap and its payoff is continuous: a compacted `CONTEXT.md` saves
  tokens on every agent call.
- Run it routinely at the end of each sprint.
