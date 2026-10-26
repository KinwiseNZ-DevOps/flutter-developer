---
name: flutter-tech-debt-plan
disable-model-invocation: true
description: >
  Use when asked to audit tech debt, find code smells, assess missing tests or
  outdated docs, or plan a clean-up. Produces a scored technical debt
  remediation plan for Flutter and Dart code, tests and documentation, with a
  summary table and a detailed plan per item, without changing code. Do not use
  for fixing the debt (flutter-developer) or for open-ended investigation
  (flutter-task-research).
---

# Flutter Tech Debt Plan

Stance: this skill analyses and plans; it does not edit code. Frozen: the scoring scale and the output sections. Flexible: how many items the plan covers, which should match the evidence found.

## Hard rules

- Make no code changes. Mechanism: the plan is reviewed and prioritised before any work is approved.
- Keep entries concise and actionable. Mechanism: long explanations hide the next step.
- Every item cites evidence from the code. Mechanism: unevidenced debt cannot be prioritised or disputed.
- Do not create duplicate issues. Mechanism: duplicates split discussion and inflate the backlog.
- Order implementation steps so each can be verified, and name the test that proves the fix. Mechanism: debt fixes without tests risk new defects.

## Gate

| Situation | Action |
|---|---|
| Debt is real and evidenced in files you opened | Add it to the plan |
| A concern is a matter of taste | Leave it out, or note it as taste |
| A TODO or FIXME marker exists | Treat it as a lead, confirm the problem in the code |
| User asks to fix an item | Finish the plan, then hand off for implementation |

Reason: a plan padded with unverified or cosmetic items buries the few that matter.

## Steps

1. **Detect.** Look for the common debt types: missing or thin test coverage, outdated or missing documentation, unmaintainable structure, tight coupling and poor modularity, deprecated dependencies or APIs, ineffective design patterns, and TODO or FIXME markers. Use `dart analyze`, a dependency check such as `flutter pub outdated`, and a read of the code. Record file paths as evidence.
2. **Score.** Rate each item 1 to 5 on three measures. Ease of remediation: 1 trivial, 5 complex. Impact on quality: 1 minimal, 5 critical. Risk of inaction: 1 negligible, 5 severe, shown with an icon (green low, amber medium, red high). Say beside the table that a high Ease number means harder.
3. **Write.** Start with a summary table: item, ease, impact, risk, one-line explanation. Then for each item: Overview, Explanation, Requirements, Implementation steps (ordered), Testing. Details: [scoring-and-format.md](references/scoring-and-format.md).
4. **Link.** If the project uses an issue tracker, search existing issues before proposing a new one, use its chore or maintenance template, and reference related issues.

## References

- [scoring-and-format.md](references/scoring-and-format.md): scale, required sections, output format, tracker rules.

## Next

To fix an item see [flutter-developer](../flutter-developer/SKILL.md). To investigate a particular item first see [flutter-task-research](../flutter-task-research/SKILL.md).
