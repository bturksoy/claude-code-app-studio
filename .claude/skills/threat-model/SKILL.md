---
name: threat-model
description: Produces a STRIDE-based security threat model. Identifies assets, trust boundaries and threats, and assigns a mitigation and verification method to each. Operates the SEC-THREAT gate.
---

# /threat-model

Owner: `security-engineer`. Output: `docs/security/threat-model.md`

Prerequisite: `ARCHITECTURE.md` (plus `openapi.yaml` if available).
Mandatory in `full` mode; optional in `lean`; skipped in `solo`.

---

## 1. Input

- Architecture: containers, trust boundaries, external systems
- API: endpoint list + auth schemes (not the full YAML)
- Data: which entities are sensitive (personal, financial, health, credentials)
- Compliance requirements (GDPR/PCI etc. — from `NFR.md`)
- User roles and the permission matrix

## 2. Invoke `security-engineer`

```
<CONTEXT BLOCK>

Task: produce a STRIDE threat model.

1. Asset inventory
   | Asset | Sensitivity | Where stored | Who accesses | Legal status |

2. Trust boundaries (Mermaid) — every boundary crossing is a control point

3. Threat table — apply all 6 STRIDE categories to each trust boundary:
   Spoofing, Tampering, Repudiation, Information disclosure,
   Denial of service, Elevation of privilege
   | # | Boundary | STRIDE | Threat scenario | Impact | Likelihood | Risk | Mitigation | Verification |
   The threat scenario must be CONCRETE: "if the attacker does X they obtain Y"

4. For every HIGH/CRITICAL risk:
   - The required mitigation (actionable, at code/config level)
   - The verification method (a test id or a check step)
   - Which REQ/ADR it will be bound to

5. Risks recommended for acceptance (mitigation cost > risk) — with rationale

6. Security requirement proposals: items that should be added to NFR.md

Rules:
- Do NOT produce attack tooling or exploit code — describe the scenario
- If you cannot write an exploit scenario, it is not a finding but a theoretical concern
- Match the scale of this project; do not write an APT model for a 10-user internal tool

Begin your reply with "SEC-THREAT: APPROVED|CONDITIONAL|REJECTED".
```

## 3. Present

```
## Threat Model
Assets: <N> | Trust boundaries: <M> | Threats: <K>

Risk distribution: Critical <a> | High <b> | Medium <c> | Low <d>

Required mitigations (Critical/High):
| # | Threat | Mitigation | Where it will be bound |

Risks recommended for acceptance: <list>
NFR proposals: <list>

Gate: SEC-THREAT <verdict>
```

Have the user confirm the risks to accept via `AskUserQuestion` — this is a
**business decision**, not one the security engineer can make alone.

## 4. Write

- `docs/security/threat-model.md`
- Propose the required mitigations **as NFRs** to `business-analyst` (list them in the
  report — you do not modify `NFR.md`)
- Add accepted risks to `product/risks.md` (with owner + review date)
- `.state/gates.jsonl`

## 5. Close

```
✓ Threat model → docs/security/threat-model.md
  <K> threats | <a> critical/high mitigations required

⚠ These mitigations must become stories: <list>
   Include them when you run /epics.

▶ Next: /epics
```

---

## Token note

- **1 agent call.**
- Depth should match project scale — do not produce 60 threats for a small project; 15 is enough.
- Do not embed the whole API; the endpoint list plus auth schemes is enough.
