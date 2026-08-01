---
name: help
description: Shows the App Studio command list grouped by phase. With an argument, explains what that command does.
---

# /help

## Without arguments

If `.state/project.json` exists, read the current phase and **put that phase's commands
first**, abbreviating the rest. Otherwise show everything.

```
# Claude Code App Studio — Commands

## Bootstrap
/start                    State detection + next step
/kickoff "<idea>"         Start a new project (CEO + PO)
/onboard                  Bring an existing codebase into the system
/status                   Project status dashboard

## Phase 1 — Discovery & Requirements
/discovery                PO + BA round-table: problem, personas, scope
/roundtable "<topic>"     Multi-role discussion + decision
/prd                      Product requirements document
/requirements             FRD + NFR + data dictionary
/roadmap                  Phasing and release plan
/estimate                 Effort estimation
/scope-check              Scope-creep check

## Phase 2 — Architecture & Design
/architecture             Architecture + technology stack
/adr "<topic>"            Architecture decision record
/api-contract             OpenAPI contract
/data-model               ER + schema + migration plan
/ux-flow                  Personas, flows, wireframes
/design-system            Tokens + component catalogue
/threat-model             Security threat model

## Phase 3 — Planning & Development
/epics                    Epic breakdown
/stories <epic>           Story generation (task packets)
/sprint-plan              Sprint + task assignment
/assign <story>           Route a story to the right agent
/dev-task <story>         Implement a story
/team-feature <epic>      End-to-end vertical slice, multi-agent
/handoff                  Handoff packet between agents

## Phase 4 — Quality
/code-review [scope]      Independent code review
/test-plan                Test plan and coverage
/qa-run [scope]           Run tests and report
/bug "<description>"      Bug report + triage
/security-review          OWASP + threat verification
/perf-check               Performance budgets
/dod-check <story>        The "done" gate

## Phase 5 — Release
/release <version>        Release plan + go/no-go
/changelog                Change log
/hotfix "<issue>"         Emergency fix path
/retro                    Retrospective

## Utility
/context-compact          Compact documents, save tokens
```

## With an argument — `/help <command>`

Read `.claude/skills/<command>/SKILL.md` and produce this summary:

```
/<command>
What it does: <1-2 sentences>
Owner: <agent>
Input: <what is required>
Output: <which files>
Before: <which command must have run>
After: <a sensible next command>
```

## Further reading

If the user wants to understand the system, point them to:

| Question | File |
|---|---|
| Roles and their authority | `.claude/docs/agent-roster.md` |
| Who reports to whom | `.claude/docs/coordination-rules.md` |
| How do I lower token cost | `.claude/docs/token-budget.md` |
| What does "done" mean | `.claude/docs/definition-of-done.md` |
| Quality gates | `.claude/docs/gates.md` |
| Where do files live | `.claude/docs/context-protocol.md` |
