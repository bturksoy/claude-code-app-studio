---
name: qa-run
description: Runs the tests, reports the results, analyses failures and turns genuine defects into BUG records. Writes missing tests when coverage gaps are found.
---

# /qa-run [scope]

Owner: `test-engineer`. Scope: a story, an epic, `regression`, `smoke`, or empty (→ everything).

---

## 1. Detect the test command

Find the test command in `package.json` / `pyproject.toml` / `*.csproj` / `Makefile`.
If you cannot find it, ask the user — **do not guess**.

## 2. Run it (Bash — no agent)

By scope:
```
smoke      → the most critical <8 tests
regression → all automated tests
<epic>     → that epic's test files
empty      → the full test suite
```

Keep the output **verbatim**. For failures: test name, error message, stack trace.

## 3. Analysis

If nothing failed → go to step 5.

Otherwise invoke `test-engineer`:

```
Test output:
<the real output — do not truncate>

Related story/AC information:
<the acceptance criteria the failing tests are bound to>

Related code:
<the relevant section of the file under test>

Task: classify each failure:
- PRODUCT BUG: the code is wrong → a BUG record is needed
- TEST BUG: the test is written incorrectly → fix the test
- FLAKY: not deterministic → quarantine + root-cause analysis
- ENVIRONMENT: dependency/data/config problem → fix step

For each:
  <test name> → <class> → <one-sentence root cause> → <proposed fix> → <priority>

Do NOT hide flaky tests behind retries — find the cause.
```

## 4. Bug records

For everything classified as `PRODUCT BUG`, apply the `/bug` flow (create BUG-NNN files).
For P0/P1 bugs: **keep the failing test**, then open a fix story.

## 5. Coverage gap check

Scan the acceptance criteria in the stories (Grep `AC-`) and list those with no
counterpart in the test files:

```
⚠ Acceptance criteria without tests:
  story-004 AC-3 — <criterion>
```

Ask the user whether the missing tests should be written now.
If yes, have `test-engineer` write them **all in a single call**.

## 6. Present

```
## Test Run — <scope>
Command: <command>
Result: <passed>/<total> — <duration>

Failures (<n>)
| Test | Class | Root cause | Action |
| ... | PRODUCT BUG | ... | BUG-021 filed |
| ... | FLAKY | ... | quarantined |

Coverage: <percentage> (target <percentage>)
⚠ ACs without tests: <n>

Bugs filed: BUG-021 (P1), BUG-022 (P2)

▶ Next: <depending on the situation — /bug triage, /dev-task <fix>, /dod-check>
```

## 7. Record

`docs/qa/runs/run-<date>.md` — command, result, failures, bugs filed.
Add flaky tests to `docs/qa/flaky.md` (test name, first seen, hypothesis).

---

## Token note

- Running tests is **free** (Bash). An agent is invoked **only if something failed**.
- If everything passes, **no agent is invoked at all**.
- The full output of failing tests is embedded — analysis quality depends on it.
- Write missing tests in bulk in a single call.
