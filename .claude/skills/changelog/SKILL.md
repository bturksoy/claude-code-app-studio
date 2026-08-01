---
name: changelog
description: Produces a change log entry from completed stories and bug fixes. Written in the user's language using Keep a Changelog + SemVer format.
---

# /changelog [version]

Owner: `tech-writer` (haiku — cheap, mechanical work).

---

## 1. Collect the input (free)

- Stories with `Status: DONE` since the last release (title + value statement)
- Closed bugs (`docs/qa/bugs/` — `Status: Closed`)
- Breaking changes (`docs/DECISIONS.md` + `openapi.yaml` changes)
- The existing `CHANGELOG.md` (for the format and the last version number)

## 2. Determine the version number

```
Breaking change present → MAJOR
New feature present     → MINOR
Fixes only              → PATCH
```

Propose it and confirm with the user.

## 3. Invoke `tech-writer`

```
Previous version: <vX.Y.Z>
Proposed version: <vX.Y.Z>

Completed stories:
| ID | Title | User value |

Closed bugs:
| ID | Title |

Breaking changes: <list>
Security fixes: <list>

Task: produce the CHANGELOG entry (Keep a Changelog format).
Sections: Added / Changed / Deprecated / Removed / Fixed / Security

Rules:
- Write in the USER's language, not technical jargon
  ✗ "Added an idempotency key to OrderService"
  ✓ "The same order can no longer be created twice by accident"
- Reference at the end of each line: (story-014) or (BUG-021)
- If there is a breaking change, a MIGRATION NOTE is mandatory: what changed,
  what the user must do
- No marketing language
- Do NOT write internal changes the user will not notice
```

## 4. Write

Prepend to `CHANGELOG.md` (append-only — never edit old entries).

## 5. Close

```
✓ CHANGELOG updated — <vX.Y.Z>
  Added <a> | Fixed <b> | Security <c>
  Breaking change: <yes/no>

▶ Next: /release <vX.Y.Z>
```

---

## Token note

- **1 haiku call** — this work is mechanical and does not need a large model.
- Embed the stories' titles and value statements, not their full contents.
