# Security Rules (apply to all code)

**Scope:** `src/**`, `infra/**`, `db/**` — these rules override the other rule files.

---

## Identity and authorization

- **Default deny.** Authorization is written explicitly at every entry point
- **Resource ownership checks are mandatory.** "Can this user see/modify this record"
  — this is the most commonly found critical vulnerability (IDOR)
- Role check ≠ ownership check. Both are required
- Authorization may be **duplicated** on the client (for UX), but the backend is authoritative
- Passwords: modern KDF (argon2id/bcrypt) with appropriate cost. MD5/SHA1 forbidden
- Tokens: short lifetime, refresh rotation, revocation mechanism
- Admin endpoints get extra protection (additional authorization + rate limit + audit trail)

## Input

- Validation happens **at the boundary** (schema), business validation additionally in the domain
- Allowlists are preferred over denylists
- Size limits everywhere: body, file, array length, string length
- File upload: type (magic bytes), size, filename sanitization, isolated storage
- Path traversal: user input never goes directly into a file path
- SSRF: anywhere an external URL is accepted uses an allowlist and blocks internal addresses

## Injection

- SQL: **always** parameterized queries. String concatenation forbidden
- Command execution: user input never reaches a shell; if it must, use an argument
  array with `shell=false`
- Templates: auto-escaping on; if disabled, justify and sanitize
- XSS: avoid `innerHTML` / `dangerouslySetInnerHTML` / `v-html`; sanitize if used
- Deserialization: safe parsers for untrusted data (`yaml.safe_load`; `pickle` forbidden)

## Output and leakage

- Error responses contain no stack traces, SQL, file paths, version info or internal IPs
- Masked in logs: passwords, tokens, API keys, card numbers, identity numbers,
  emails (partial), health data
- User enumeration is prevented: "user not found" and "wrong password" return the same response
- Timing attacks: authentication comparisons are constant-time

## Data protection

- TLS in transit (HSTS)
- Sensitive fields encrypted at rest
- Personal data minimization: data not collected cannot leak
- Retention period defined, deletion mechanism present
- Backups encrypted with restricted access
- Production data is **never** copied to test/development without anonymization

## Configuration

- **No secrets in the repo.** `.env` is not versioned
- Security headers: HSTS, CSP, X-Content-Type-Options, Referrer-Policy, X-Frame-Options
- CORS: allowlist. `*` combined with `credentials: true` is **forbidden**
- No default accounts or passwords
- Debug mode off in production
- Directory listing off

## Cryptography

- **Never write your own** encryption algorithm — use a standard library
- Randomness: cryptographically secure source (`crypto.randomBytes`, `secrets`)
  — `Math.random()` is **forbidden** for security purposes
- Forbidden: MD5, SHA1 (for security), DES, ECB mode, fixed IVs

## Dependencies

- Lock file present and committed
- Known-vulnerability scanning in the pipeline
- A new dependency requires an ADR (maintenance status, license, size, security history)

## Abuse protection

- Brute-force protection on authentication endpoints (rate limit + account lockout)
- Rate limits and resource caps on expensive endpoints
- Audit log: who, when, what — immutable

## Prohibitions

- Printing, logging or committing a secret
- Disabling a security control "temporarily"
- Skipping authorization because "it is on the internal network anyway"
- Producing exploit code or attack tooling
- Running security tests against production systems (without permission)
