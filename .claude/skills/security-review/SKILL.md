---
name: security-review
description: Performs a security review of code and configuration. Checks OWASP items, authorization logic, secret leakage, and whether the threat model's mitigations were implemented. Operates the SEC-REVIEW gate.
---

# /security-review [scope]

Owner: `security-engineer`. Scope: an epic, a release, or empty (→ the last sprint's changes).

---

## 1. Targeted scan (no agent — cheap pre-filter)

Grep for these patterns and collect candidate findings:

```
Secret leakage   : api[_-]?key|secret|password\s*=|token\s*=|BEGIN (RSA|PRIVATE)
Injection risk   : raw query, string concat + SELECT/INSERT, exec(, eval(
XSS risk         : innerHTML, dangerouslySetInnerHTML, v-html, |safe
Missing authz    : router/controller definitions without auth middleware
Cryptography     : md5|sha1|Math.random\(\)|DES|ECB
CORS/headers     : cors\(|Access-Control-Allow-Origin
Deserialization  : pickle|yaml.load\(|JSON.parse\( + user input
Files            : path.join.*req\.|readFile.*req\.
```

Also run a dependency scan if available: `npm audit`, `pip-audit`,
`dotnet list package --vulnerable`.

## 2. Invoke `security-engineer`

```
Scope: <what was reviewed>

THREAT MODEL MITIGATIONS (to be checked for implementation):
<the HIGH/CRITICAL mitigation table from threat-model.md>

SCAN CANDIDATES:
<Grep results — file:line + the matching line>

DEPENDENCY SCAN:
<audit output>

CHANGED CODE:
<diff or the relevant files>

API CONTRACT:
<endpoint list + security definitions>

Task: the SEC-REVIEW gate.

1. Validate the scan candidates — which are real vulnerabilities, which are false positives
2. Was each HIGH/CRITICAL mitigation from the threat model implemented — show it in the code
3. Additional checks:
   - Is authorization present on every endpoint, is resource ownership (IDOR) checked
   - Is input validation at the boundary
   - Do error responses leak detail
   - Is there sensitive data in the logs
   - Is rate limiting present on critical endpoints
4. Write a CONCRETE exploit scenario for each finding. If you cannot, it is not a
   finding → NOTE.

Finding format:
[CRITICAL|HIGH|MEDIUM|LOW] <file:line>
  Vulnerability: | Exploit: <what the attacker does, what they gain> | Impact: | Fix: | Verification:

Do NOT produce exploit code. Match the scale of this project.
Begin your reply with "SEC-REVIEW: APPROVED|CONDITIONAL|REJECTED".
```

## 3. Present

```
## Security Review — <scope>
Verdict: SEC-REVIEW <verdict>

Findings: Critical <a> | High <b> | Medium <c> | Low <d>
False positives eliminated: <n>

[CRITICAL] <file:line> — <vulnerability>
  Exploit: <scenario>
  Fix: <concrete>

Threat model mitigations: <implemented>/<total>
⚠ Not implemented: <list>

Dependencies: <vulnerability count> (<critical count> critical)
```

## 4. Fixes and acceptance

`AskUserQuestion`:
- `Fix Critical + High findings (Recommended)`
- `Fix only the Criticals, accept the rest as risk`
- `Add them all to the backlog as stories`

Accepted risks go into `product/risks.md`: the risk, the rationale, who accepted it,
the review date. **The acceptance decision is the user's**, not the security engineer's.

If a fix is chosen, send it to the relevant developer in one round; on a `REJECTED`
verdict, invoke the gate once more after the fix.

## 5. Record

- `docs/security/checklist.md` — this round's results (date-stamped)
- `.state/gates.jsonl` → SEC-REVIEW
- Accepted risks → `product/risks.md`

---

## Token note

- The **Grep pre-filter is free** and stops the agent from searching — the biggest saving here.
- **1 agent call** + at most 1 fix round.
- Embed only the HIGH/CRITICAL mitigation table from the threat model, not the whole document.
