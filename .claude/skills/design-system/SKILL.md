---
name: design-system
description: Produces the design token set and component catalogue. Derives the component list from the UX screens and writes variant, state, prop and accessibility specifications for each.
---

# /design-system

Owner: `ui-designer`. Output: `docs/design/system/`

Prerequisite: `docs/design/ux/wireframes/` (if missing, suggest `/ux-flow`).

---

## 1. Input

- The **UI elements** from the screen inventory and wireframe specifications
  (collect the layout lines starting with `[` via Grep — do not embed whole wireframes)
- Accessibility NFRs
- Any brand/visual preference from `docs/DECISIONS.md`

Ask the user via `AskUserQuestion`:
- **Visual direction:** `Neutral and professional (Recommended)` / `Warm and friendly` /
  `Dense and data-oriented` / `I have an existing brand (I'll describe it)`
- **Theme:** `Light + dark (Recommended)` / `Light only`

## 2. Invoke `ui-designer`

```
UI elements appearing in the screens: <derived list>
Visual direction: <answer> | Theme: <answer>
Accessibility target: WCAG 2.2 AA
Platform: <web/mobile>

Task: produce the design system.

1. tokens.md
   - Raw palette (with contrast ratios)
   - SEMANTIC mapping table (light + dark theme)
     surface.*, text.*, border.*, action.*, feedback.*
   - Type scale, spacing scale (4px-based), radius, shadow, motion
   - Rule: components use ONLY semantic tokens

2. Component inventory — DERIVE it from the screens; do not invent components
   | Component | Screens used on | Priority | Complexity |

3. A specification per component:
   anatomy, variants, states (default/hover/focus-visible/active/
   disabled/loading/error), props table, accessibility
   (ARIA role, keyboard map, focus ring, touch target ≥44px),
   a "do not" list

4. patterns.md — form layout, table+filter, modal, empty state,
   notification, confirmation flow, pagination. ONE correct way for each.

5. accessibility.md — the WCAG 2.2 AA checklist and how this system meets it

Rules:
- Few, well-defined tokens. Forty colour tokens kill the system.
- Compute and write down contrast ratios (text ≥4.5:1, UI ≥3:1)
- A component without a loading and error state is unfinished
- Write it clearly enough that the frontend developer can implement without questions

Give the token set and component inventory first, then the specifications.
```

## 3. Scope check

If the component count exceeds 15: write the `High` priority ones now and the rest
as they are needed. Ask the user.

## 4. Present

```
## Design System
Tokens: <N> semantic (colour <a>, typography <b>, spacing <c>)
Theme: <light+dark>
Components: <M>

| Component | Usage | Priority |

Contrast check: <passing>/<total>
⚠ Contrast problems: <if any>
```

## 5. Write

- `docs/design/system/tokens.md`
- `docs/design/system/components/<name>.md`
- `docs/design/system/patterns.md`
- `docs/design/system/accessibility.md`

## 6. Close

```
✓ Design system → docs/design/system/
  <N> tokens | <M> components

▶ Next: /epics
   We are ready to build — time for the backlog breakdown.
```

---

## Token note

- **1 agent call.**
- Do not embed whole wireframes; derive just the UI element lines.
- Write component specifications in priority order, not all at once.
