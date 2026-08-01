# Definition of Done (DoD)

"Done" is not a feeling — it is **evidence**. `/dod-check` uses this file as a
checklist and refuses to close a story when evidence is missing.

---

## Story types and required evidence

Every story is assigned a type during `/stories`. The type determines the evidence.

| Type | Assigned when | Required evidence |
|---|---|---|
| **Logic** | Business rule, calculation, state transition, validation | Passing unit test: `tests/**/<slug>.test.*` |
| **Integration** | 2+ components interacting, API call, queue, external service | Passing integration test + contract-conformance evidence |
| **Data** | Schema, migration, index, data transformation | Migration up+down executed + `db/schema.sql` current + sample query plan |
| **UI** | Screen, component, form, navigation | Passing component test **or** `docs/qa/evidence/<slug>.md` (steps + expected + actual) |
| **Infra** | CI/CD, environment, IaC, monitoring | Green pipeline output + written rollback steps |
| **Config** | Settings/data change only, no new logic | Smoke test record |

For mixed stories, the **highest-risk type** applies.

---

## Common checklist for every story

```
[ ] All acceptance criteria checked off (checkboxes in the story file)
[ ] Traceability complete: story → REQ-* → GOAL-* and ADR-* if applicable
[ ] Type-required evidence exists and passes
[ ] Out-of-scope section untouched (no neighbouring story's work done here)
[ ] No path rule violated (.claude/rules/)
[ ] If a new dependency was added, an ADR exists
[ ] Error paths handled (at least 2 non-happy-path scenarios)
[ ] No secret leakage (logs, error messages, responses)
[ ] Code review verdict: APPROVED, or CONDITIONAL items closed
[ ] Documentation impact handled (openapi.yaml if the API changed, guides/ if behaviour changed)
[ ] If a new decision was made, it is one line in docs/DECISIONS.md
```

---

## Sprint DoD

Before a sprint closes:

```
[ ] Sprint goal met, or the variance is documented
[ ] Every story is either DONE or returned to the backlog with a reason
[ ] Regression suite green
[ ] No open CONDITIONAL gate items (.state/gates.jsonl)
[ ] docs/CONTEXT.md updated (stage, in-progress work, debt)
[ ] product/risks.md reviewed
[ ] Retrospective held, actions assigned to owners
```

---

## Release DoD

```
[ ] Every story in the release is DONE
[ ] Regression + smoke suites green on the target environment
[ ] SEC-REVIEW: APPROVED (or accepted risk documented)
[ ] PERF-BUDGET: APPROVED (NFR targets measured)
[ ] Migration plan + rollback steps tested
[ ] Observability: logs, metrics, alerts defined
[ ] CHANGELOG.md current, release tag ready
[ ] User/operations documentation current
[ ] OPS-READY: APPROVED
[ ] CEO-GONOGO: APPROVED
```

---

## Acceptance criteria quality

`business-analyst` and `qa-lead` reject the following:

| Bad | Why | Good |
|---|---|---|
| "The system should be fast" | Not measurable | "The list returns p95 < 400 ms with 1000 records" |
| "It should be user-friendly" | Not verifiable | "A new user completes registration in 3 steps without help" |
| "Errors must be handled" | Vague | "An invalid email shows `Invalid email format` under the field and the form does not submit" |
| "It must be secure" | Unscoped | "An unauthorized user receives 403 on `/admin/*` and the event is written to `audit_log`" |

Preferred format: **Given / When / Then**.

```
Given: <precondition>
When: <action>
Then: <observable result>
Edge cases: <boundary / failure scenarios>
```
