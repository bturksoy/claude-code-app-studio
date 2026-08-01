# Test Code Rules

**Scope:** `tests/**`, `**/*.test.*`, `**/*.spec.*`, `**/__tests__/**`

---

## Naming

The test name states what it tests and links to an acceptance criterion:

```
✓ AC-2_order_exceeding_stock_returns_409
✓ empty_list_submission_returns_400_with_field_error
✗ test_order_1
✗ should work
```

File: `tests/<layer>/<area>/<slug>.test.<ext>`

## Structure

```
Given (Arrange) → When (Act) → Then (Assert)
```

- One test verifies **one behaviour**
- No assertion, no test. "It did not throw" is not an assertion
- Assertions are **specific**: `expect(res.status).toBe(409)` — not `toBeTruthy()`

## Independence

- Tests are **order-insensitive**; they run alone and in parallel
- Each test sets up and tears down its own data
- Shared mutable state is forbidden
- Do not set up data in a global `beforeAll` and share it across tests

## Determinism

- Conditional waiting (`waitFor`, polling with timeout) instead of `sleep`
- Date/time from an injectable source (use a fixed date)
- Randomness with a fixed seed
- External network calls are **forbidden** — use mocks or test doubles
- A flaky test is quarantined immediately and its cause investigated.
  **Never hidden behind a retry**

## Coverage

At least one test per `AC-N`. In addition, edge cases:

```
empty / null / undefined
zero / negative / maximum
single element / many elements
concurrent calls
repeated calls (idempotency)
invalid type / format
unauthorized access
```

The happy path is one test; boundaries are three. A story with only a happy-path test
is not DONE.

## Test levels

| Level | What it tests | What it does not use |
|---|---|---|
| Unit | Pure logic, business rules | Database, network, filesystem |
| Integration | Component interaction, real DB, API contract | External third-party services |
| E2E | Critical user journeys (≤8 scenarios) | — |

## E2E discipline

- **At most 8 scenarios** — only journeys that touch money
- Selectors: `data-testid` or an accessible role/label. **Never** CSS classes or text
- Each scenario creates its own user and data
- Do not test unit-level logic in E2E — that is the unit test's job

## Mock usage

- Do not mock code you own; mock boundaries (external services, clock, randomness)
- An over-mocked test tests the implementation, not the behaviour
- Mock verification (`toHaveBeenCalledWith`) does not replace a behavioural assertion

## Test data

- Factory/builder pattern: `createOrder({status: 'paid'})` — specify only what matters
- Meaningful names instead of magic values: `EXPIRED_TOKEN`, `MAX_QUANTITY`
- Fixtures live next to the test, not in a distant folder

## Prohibitions

- Committed `skip` / `only` / `xit` / `fdescribe`
- A test with its assertion commented out
- Loosening an assertion to make a test pass
- Using production data
- Leaving `console.log` in a test
- Raising the timeout "so it passes" (find the root cause)
