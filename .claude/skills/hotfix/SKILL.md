---
name: hotfix
description: Resolves an urgent production issue on a fast path — impact analysis, root cause, minimal fix, regression test and expedited release. Skips the normal sprint flow but not the quality bar.
---

# /hotfix "<issue>"

Coordination: `delivery-manager`. **A fast path, not a shortcut.**

---

## 1. Impact assessment (first — no agent)

Ask in a single round via `AskUserQuestion`:
- **What is happening right now:** `System completely down` / `Main flow broken` /
  `Some users affected` / `Data being corrupted or leaked`
- **When did it start:** `After the last deploy` / `Gradually` / `Unknown`
- **Is there a workaround:** `Yes, it can be announced to users` / `No`

**If it is data corruption or a security leak:** first propose a **containment** measure
(turn the feature off, cut traffic, restrict access) — stop the bleeding before fixing.

## 2. Root cause analysis

If it started after the last deploy, review the changes (`git log`, the last release note).

Invoke the relevant developer agent (based on the affected area):

```
URGENT — production issue.
Symptom: <issue>
Impact: <answer>
Started: <answer>
Recent changes: <git log --oneline of the last 10, or the release note>
Related code: <the relevant section found via Grep>
Logs/errors: <whatever the user provided>

Task:
1. The 2 most likely root-cause hypotheses + how each would be CONFIRMED
2. The MINIMAL fix — the smallest change that resolves the issue.
   Do NOT refactor, do NOT improve, just stop the bleeding.
3. Side effects of this fix
4. Is rolling back safer than fixing forward? Answer honestly.
5. A test that verifies the fix (it must fail first)

Be brief and fast.
```

## 3. Rollback vs roll forward

If the agent says rollback is safer, **present it to the user**:

```
Option A — Roll back
  Time: <fast> | Risk: <low> | Side effect: <the last release's features are lost>
Option B — Roll forward (hotfix)
  Time: <longer> | Risk: <medium> | Side effect: <...>

Recommendation: <A or B> — <rationale>
```

## 4. Apply and verify the fix

1. **Write the failing test first** (the regression test) — no exceptions
2. Apply the fix
3. Run the test — it must now pass
4. Run the regression suite — confirm nothing else broke

## 5. Expedited review

Invoke `code-reviewer` — **BLOCKER level only**:

```
<DIFF>
Task: URGENT hotfix review. Look only at:
1. Does the fix actually resolve the issue
2. Does it introduce a new bug or vulnerability
3. Is the scope minimal (are there unnecessary changes)
Report only BLOCKER-level findings. Do not write style or improvement notes.
Begin with "CR-CODE: APPROVED|REJECTED".
```

## 6. Release

Invoke `devops-engineer`:
```
Hotfix: <summary>
Changed: <files>
Task: an expedited release plan.
1. Deploy steps (minimal, only this change)
2. Rollback step (the hotfix itself must be reversible)
3. Post-release verification: which metrics to watch in the first 15 minutes
```

Do **not** execute the deploy — show the command, let the user run it.

## 7. Record and follow-up

- `docs/qa/bugs/BUG-NNN.md` — the bug record (created retroactively)
- `CHANGELOG.md` — a PATCH version entry
- `docs/ops/release-<version>.md` — the hotfix release record
- `product/risks.md` — what is needed so this does not recur

**Mandatory follow-up:** the hotfix exposed a gap. Add stories to the backlog:
- Why the tests did not catch it → test gap
- Why the review did not catch it → checklist gap
- Why monitoring did not warn → alerting gap

## 8. Close

```
✓ Hotfix applied: <summary>
  Root cause: <one sentence>
  Regression test: <file> ✓
  Review: CR-CODE <verdict>

⚠ The deploy command was NOT run — run it yourself when ready.

Follow-up stories added to the backlog:
  - <test/review/monitoring gap>

▶ Next: post-release verification → /retro (for this incident)
```

---

## Token note

- **3 agent calls** (developer + reviewer + devops). Fast path, narrow scope.
- Impact assessment goes to the user — free and the most critical information.
- The review scope is deliberately narrow: BLOCKER only.
