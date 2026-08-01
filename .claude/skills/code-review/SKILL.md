---
name: code-review
description: Performs an independent code review. Produces findings across correctness, security, scope fidelity, rule compliance, readability and test quality. Operates the CR-CODE gate.
---

# /code-review [scope]

Owner: `code-reviewer`. Writes no code; reports findings.

Scope argument: a story path, a file list, an epic slug, or empty
(→ working-directory changes / `git diff`).

---

## 1. Collect the scope

- If it is a git repo: `git diff` (staged + unstaged) or `git diff <base>..HEAD`
- Otherwise: read the given file list
- Find the relevant story file (if any) — for acceptance criteria and scope boundary
- Select the relevant `.claude/rules/*.md` files based on the paths touched

If the diff exceeds 1500 lines, **split it** into two review rounds, or ask the user:
> "<N> lines changed. Should I review all of it, or the riskiest files?"

## 2. Invoke `code-reviewer`

```
<DIFF or FILE CONTENTS>

<STORY CONTEXT (if any):
  acceptance criteria, business rules, out-of-scope section>

<RELEVANT RULES: the content of .claude/rules/<file>>

Task: the CR-CODE gate.

Review order (earlier items matter more):
1. Correctness — are the ACs met, edge cases, error paths,
   concurrency, null/off-by-one
2. Security — authorization, resource ownership (IDOR), input validation,
   injection, secret leakage
3. Scope fidelity — was "Out of scope" work done, are there unrelated refactors
4. Rule compliance — the items in the supplied rules file
5. Readability/maintainability — naming, single responsibility, magic values, dead code
6. Test quality — is there a test per AC, does it really assert,
   are edge cases tested, any leftover skip/only

Finding format:
[BLOCKER|MAJOR|MINOR|NOTE] <file:line> — <one-sentence claim + reason + which AC/rule>

DO NOT WRITE: style preferences, "would be nicer", praise paragraphs,
the same issue repeated (write it once, say "in N places").
At most 15 findings; if there are more, give the 15 most critical.

Begin your reply with "CR-CODE: APPROVED|CONDITIONAL|REJECTED".
APPROVED = no BLOCKER and no MAJOR. CONDITIONAL = MAJOR present. REJECTED = BLOCKER present.
```

## 3. Present

```
## Code Review — <scope>
Verdict: CR-CODE <verdict>
Scope: <N> files, <M> lines

BLOCKER (<a>)
  <file:line> — <claim>
MAJOR (<b>)
  ...
MINOR (<c>)
  ...
NOTE (<d>)
  ...
```

## 4. Fix flow

`AskUserQuestion`:
- `Fix BLOCKER + MAJOR findings (Recommended)`
- `Fix only the BLOCKERs`
- `I'll fix them myself`

If a fix is chosen, send them to the relevant developer agent **in one round**:

```
Fix the following findings. Only these — make no other changes.
<finding list>
After fixing, run the relevant tests and report the result.
```

On a `REJECTED` verdict, invoke the gate **once more** after the fixes.
On `CONDITIONAL`, do not re-invoke.

## 5. Record

Append the CR-CODE line to `.state/gates.jsonl`.
Any unfixed `MAJOR` findings are added to `product/risks.md` as technical debt.

---

## Token note

- **1 agent call** + at most 1 fix round + (if REJECTED) 1 verification round.
- The rules files are embedded (fixed content → prompt-cache friendly).
- Splitting a large diff is cheaper than sending it all at once (no context overflow).
- If several stories need reviewing, combine them into **a single call**.
