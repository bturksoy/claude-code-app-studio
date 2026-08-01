### REQ-<AREA>-<NNN>: <title>

**Source:** GOAL-<NN> / PRD §<section> / FEAT-<NN>
**Priority:** Must | High | Medium | Low
**Actor:** <role>
**Trigger:** <what starts it>

**Behaviour**

<What the system does. One paragraph, no ambiguity.
It must pass the test: "could two different systems be built from this definition?">

**Business rules**

- **BR-1:** <rule>
- **BR-2:** <rule>

**Acceptance criteria**

- **AC-1:** <criterion>
  - Given: <precondition>
  - When: <action>
  - Then: <observable, measurable result>
- **AC-2:** <criterion>
  - Given: <...>
  - When: <...>
  - Then: <...>

**Errors and edge cases**

*At least 2 scenarios are mandatory. Never write the happy path alone.*

| Case | Expected behaviour | Message to user |
|---|---|---|
| <empty input> | | |
| <unauthorized access> | | |
| <concurrent operation> | | |

**Authorization**

| Role | Can | Cannot |
|---|---|---|

**Dependencies:** <REQ-* / external system / None>
**Assumptions:** <if any>
**Open questions:** <question — owner — blocking?>
