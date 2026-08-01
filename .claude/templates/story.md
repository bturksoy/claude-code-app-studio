# Story <NNN>: <title>

> **Epic:** <name> | **Type:** <Logic|Integration|Data|UI|Infra|Config> | **Owner:** <agent>
> **Status:** Ready | **Estimate:** <XS/S/M/L> | **Sprint:** — | **Updated:** <YYYY-MM-DD>

## What to build

<2-3 sentences. The first thing the developer reads. Concrete and technical.>

## Acceptance criteria

*Source: REQ-<ID> — copied here, not referenced*

- [ ] **AC-1:** <criterion>
  - Given: <precondition>
  - When: <action>
  - Then: <observable result>
- [ ] **AC-2:** <criterion>
  - Given: <...>
  - When: <...>
  - Then: <...>

## Business rules

*Source: REQ-<ID> — copied*

- **BR-1:** <rule>
- **BR-2:** <rule>

## Errors and edge cases

| Case | Expected behaviour | Message to user |
|---|---|---|
| | | |

## Architecture decisions to apply

*ADR-<NNNN>: <title>*

<The ADR's "Implementation guidance" section is copied here.
The developer will not open the ADR file.>

**Required pattern:** <...>
**Forbidden pattern:** <...>

## Contract

*Relevant endpoint / table / component definitions — copied*

```yaml
# relevant section from openapi.yaml
```

```sql
-- relevant table from ER.md / schema.sql
```

## Files to touch

*Identified paths — not guesses*

- `<path>` — <what changes>
- `<test path>` — new

## Out of scope

*Neighbouring stories handle these — do not do them here*

- Story <NNN+1>: <what>

## Test scenarios

*Written by the QA Lead. Do not invent tests from scratch.*

**TC-<REQ>-01** — AC-1
- Given: <...> | When: <...> | Then: <...>
- Edge cases: <...>
- Priority: P0

## Required evidence

**Type:** <type>
**Required:** <the type's mandatory evidence, from the DoD>
**File:** `tests/<path>/<slug>.test.<ext>`
**Status:** [ ] Not yet created

## Dependencies

**Must finish first:** <story-NNN or None>
**Waiting on this:** <story-NNN or None>

## Traceability

REQ-<ID> → GOAL-<NN> | ADR-<NNNN> | Screen: <if any>
