---
name: handoff
description: Produces a work handoff packet from one agent to another. Conveys what was done, what remains, the decisions made and the pitfalls, in no more than 200 words. Used at session end or on a role change.
---

# /handoff [from] [to]

Prevents context loss and stops the receiving side from re-researching from scratch.

**When:** role change, end of session, wave transition, handing off blocked work.

---

## 1. Gather the handoff information

From the current session or the specified story:
- What was done (files, tests, decisions)
- What was left unfinished
- Which decisions were made and why
- Which pitfalls were hit / which assumptions were made
- The verification command the receiving side should run

## 2. Produce the packet — **200-word limit**

```markdown
## Handoff Packet
**From:** <role> | **To:** <role> | **Work:** <story-id / topic> | **Date:** <date>

### Done
- <item — concrete, with file/function names>

### Remaining
- <item — the next concrete step>

### Decisions made
- <decision> — <one-sentence rationale>

### Watch out
- <pitfall, assumption, surprise>

### Files
- `<path>` — <what was done>

### Verify
```bash
<the command the receiving side should run>
```
```

**If the limit is exceeded:** drop the detail, keep the outcome.
"I tried X, it failed, then I tried Y" → "Approach X was chosen because Y."

## 3. Where it goes

| Situation | Location |
|---|---|
| Story handoff | A `## Handoff note` section at the end of the story file |
| End of session | `docs/CONTEXT.md` → "Current work" |
| Wave transition | Embedded in the next wave's agent prompt (not written to a file) |
| Blocked handoff | `product/sprints/sprint-NN.md` → as a note |

## 4. Starting point for the receiving side

The handoff packet is embedded in the receiving agent's prompt **together with the story**:

```
<THE STORY FILE>

HANDOFF FROM THE PREVIOUS WORKER:
<the handoff packet>

Task: continue from where it was left. Do NOT question the decisions in the handoff
packet — they are already implemented. Only do the work under "Remaining".
```

---

## Rule

A handoff packet **contains no commentary**, only state.
Phrases like "I could have done this better" are not written — that is the retro's job.

---

## Token note

- **0 agent calls** — produced from the current context.
- The 200-word limit is deliberate: a long handoff note is a reading cost for the receiver.
- A good handoff packet saves the receiving agent from scanning 5-8 files.
