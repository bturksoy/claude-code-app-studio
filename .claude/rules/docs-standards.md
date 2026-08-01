# Documentation Standards

**Scope:** `docs/**`, `product/**`, `*.md`

---

## General

- **Single source of truth.** A fact lives in one file. Link instead of copying.
  Exception: the deliberate copies inside story files (the task-packet principle).
- **No unsourced claims.** If a behaviour is described, its source is cited
  (`REQ-*`, `ADR-*`, story). If there is no source, mark it `OPEN:`.
- **Active voice, short sentences, one idea at a time.**
- **Date format:** `YYYY-MM-DD`. Never write relative dates ("last week" is forbidden).

## Identifiers

Every document artifact carries an id and links into the chain:

```
GOAL-NN → REQ-<AREA>-NNN → story-NNN → TC-<REQ>-NN
                ↓
            ADR-NNNN
```

Requirements without an id and stories not tied to a goal are not written.

## Size limits

| File | Limit | If exceeded |
|---|---|---|
| `docs/CONTEXT.md` | 200 lines | `/context-compact` |
| `docs/DECISIONS.md` | 300 lines | archive |
| `product/risks.md` | 100 lines | archive closed risks |
| `CLAUDE.md` | 150 lines | move detail into `.claude/docs/` |

## Index files

Every collection directory has an `index.md` kept current:
`adr/`, `epics/`, `sprints/`, `test-cases/`, `bugs/`

The index lets agents read one file to survey a whole collection.

## Diagrams

- Use Mermaid — text, versionable, cheap
- Prefer text specifications over image files (png/jpg)
- Every diagram has a **one-sentence caption** beneath it

## Tables

- A header row is mandatory
- Write `—` instead of leaving a cell empty
- Tables wider than 6 columns get split

## Code blocks

- A language tag is mandatory (` ```sql `, ` ```ts `)
- Runnable commands are tagged ` ```bash ` and contain **one command**

## Immutability

- `docs/DECISIONS.md` and `CHANGELOG.md` are **append-only** — old entries are never edited
- When an ADR is superseded, the old one is not deleted; its status becomes
  `Superseded (by ADR-MMMM)`
- Closed bugs, risks and stories are not deleted; they move to `archive/` or `deferred/`

## Prohibitions

- Marketing language ("powerful", "seamless", "revolutionary")
- Keeping the same fact as full text in two files
- Replacing a text specification with a screenshot
- A numeric claim without a cited source
- An unmeasurable acceptance criterion or NFR
