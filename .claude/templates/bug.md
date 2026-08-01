# BUG-<NNN>: <one sentence — the observed behaviour, not an interpretation>

**Priority:** P0 | P1 | P2 | P3
**Status:** Open | Confirmed | In progress | Fixed | Closed
**Found in:** <local | test | staging | prod>
**Version/build:** <...>
**Related:** REQ-<ID> / story-<NNN>
**Owner:** <agent>
**Date:** <YYYY-MM-DD>

## Steps to reproduce

1. <precondition: which user, which data>
2. <step>
3. <step>

**Frequency:** Every time | Sometimes (<n>/10) | Seen once

## Expected

<What should have happened — source: REQ-<ID> AC-<N>>

## Observed

<What happened>

## Evidence

```
<log line, error message, test output>
```

## Scope and impact

- **Users/scenarios affected:** <...>
- **Data corruption:** <yes/no>
- **Workaround:** <exists — how | none>

## Root cause

<Filled in after confirmation>

## Fix

<What changed, which files>

## Regression test

**File:** `tests/<path>/<slug>.test.<ext>`
**What it asserts:** <...>
**Status:** [ ] Written, failed first, then passed

## Prevention

<Why this class of bug was not caught — a test, review or monitoring gap.
Was a follow-up story created?>
