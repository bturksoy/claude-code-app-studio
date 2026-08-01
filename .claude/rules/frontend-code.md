# Frontend Code Rules

**Scope:** `src/frontend/**`, `src/web/**`, `src/app/**`, `**/*.tsx`, `**/*.vue`, `**/*.svelte`

---

## Contract and types

- API types are **derived** from `docs/api/openapi.yaml`, never hand-written
- If the contract is wrong, do not change it — escalate to `solution-architect`
- `any` is forbidden. Use `unknown` plus narrowing for unknown types

## Styling and the design system

- Never write raw colour/spacing/font values. Semantic tokens only
  ✗ `color: #3B82F6` · `margin: 13px`
  ✓ `color: var(--action-primary)` · `margin: var(--space-3)`
- Check `docs/design/system/components/` before writing a new component
- Implement **every state** listed in the component specification

## State completeness

For every data-fetching screen, **all four** are mandatory:
```
loading  → skeleton or spinner, without layout shift
empty    → explanatory message + primary action
error    → what happened + what to do + retry
success  → the data
```
If one is missing, the story is not finished.

## Accessibility

- Semantic HTML: `<div onClick>` instead of `<button>` is forbidden
- Every form field is bound to a `<label>` (`htmlFor`/`id`)
- Error messages are linked via `aria-describedby` and announced with `aria-live="polite"`
- Keyboard: every interactive element reachable with Tab, `focus-visible` visible
- Modal: focus trap, closes on Esc, focus moves inside on open and back to the trigger on close
- Images: meaningful `alt`, `alt=""` for decorative ones
- Colour never carries information alone (icon or text support)

## Business logic

- **The backend is authoritative.** Price, discount, permission and stock calculations
  are never done client-side
- Client validation is for UX, not security — the backend always revalidates
- Sensitive data (tokens, personal information) is never written to `localStorage` or logged

## State management

- Server state ≠ client state. Do not copy server data into a global store; use a
  data layer (query cache)
- Do not store derivable values in state; compute them during render
- Global state is a last resort. Props first, then context, then global

## Performance

- List keys must be stable identifiers (`item.id`); index is **forbidden**
- Virtualization for lists over 1000 rows
- Route-based code splitting; main bundle < 200 KB gzip
- Images: dimensions specified (prevents CLS), lazy loading, modern format
- Memoize **after measuring**; profile first

## Error handling

- Network errors, timeouts and 4xx/5xx are handled separately
- The error shown to the user **says what to do**
  ✗ "An error occurred"
  ✓ "The order could not be saved. Check your connection and try again."
- Raw error messages and stack traces are never shown to the user

## Tests

- Component test: render + user interaction + accessibility assertion
- Use `data-testid` or accessible role/label as selectors; never CSS classes
- At least one test per `AC-N`, with `AC-N` in the test name
- Test file: `tests/frontend/<area>/<slug>.test.*`

## Prohibitions

- `console.log` in production code
- Commented-out code
- Unowned `TODO` (owner and issue reference required)
- Adding a new library (requires an ADR)
- `dangerouslySetInnerHTML` / `v-html` (if unavoidable: sanitize + note it in code review)
