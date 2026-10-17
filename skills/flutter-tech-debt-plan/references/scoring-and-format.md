# Technical debt remediation plan

Generalised from a planning prompt. Trust level: team-written. This is an analysis-only output format: it plans remediation and does not change code.

## Role and constraints

- Produce a remediation plan for technical debt in code, tests or documentation.
- Analysis only. Make no code changes.
- Keep recommendations concise and actionable. Skip verbose explanation.

## Scoring (1 to 5 each)

| Metric | 1 means | 5 means |
|---|---|---|
| Ease of remediation | Trivial | Complex |
| Impact | Minimal effect on codebase quality | Critical |
| Risk of inaction | Negligible | Severe |

Show risk with an icon as well as a number: green for low, amber for medium, red for high. Reason: a reader scanning a table sees priority before reading figures.

Note the direction: for Ease, a higher number is harder. State this beside the table so nobody reads 5 as "easy". (Inference: the original scale is easy to misread.)

## Common debt types to look for

- Missing or incomplete test coverage.
- Outdated or missing documentation.
- Unmaintainable code structure.
- Poor modularity or tight coupling.
- Deprecated dependencies or APIs.
- Ineffective design patterns.
- TODO and FIXME markers.

## Required output

1. A summary table: item, ease, impact, risk, one-line explanation.
2. A detailed plan per item with these sections:
   - Overview: what the debt is.
   - Explanation: the problem and the approach to resolving it.
   - Requirements: prerequisites for remediation.
   - Implementation steps: ordered actions.
   - Testing: how to verify the fix.

## Issue tracker integration (optional)

- Search existing issues before creating a new one, to avoid duplicates.
- Use the repository's chore or maintenance issue template for remediation tasks.
- Link related existing issues in the plan.
