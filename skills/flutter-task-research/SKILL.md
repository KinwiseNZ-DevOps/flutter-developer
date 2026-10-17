---
name: flutter-task-research
description: >
  Runs a research-only investigation before a task is planned: reads the
  codebase and authoritative sources, records verified findings in one research
  note, weighs alternatives and converges on a single recommended approach
  without editing code. Use when asked to research, investigate, analyse how
  something works, compare approaches or prepare a plan for a Flutter or Dart
  task. Do not use to implement changes or to score technical debt
  (flutter-tech-debt-plan).
---

# Flutter Task Research

Stance: this skill reads and records; it does not change source code or configuration. Frozen: only verified findings go in the note, and only the research note is written. Flexible: how many sources and searches the question needs.

## Gate

| Situation | Action |
|---|---|
| The answer is one file read away | Answer directly, skip the note |
| Task needs understanding of several files, a convention, or a choice between approaches | Run the full method |
| User asks for the change itself | Finish research, hand off to implementation, do not edit here |
| A finding rests on an assumption | Mark it unverified or leave it out |

Reason: a full research pass on a trivial question wastes effort, while an unresearched plan inherits every unchecked assumption.

## Steps

1. **Scope.** Restate the question in one sentence and list what you need to learn.
2. **Gather.** Read the project: structure, naming, lint rules, how the relevant pattern is used. Then consult official documentation for the framework or package involved. Cross-check each finding against a second source where one exists.
3. **Record.** After each step, add the finding and its source to a single research note (for example `notes/20260101-topic-research.md`; use the project's own notes folder if it has one). Sections: what was researched, key discoveries, recommended approach, implementation guidance. Template and rules: [method-and-template.md](references/method-and-template.md).
4. **Compare.** For each viable approach note what it is, where it fits, its limits and risks, and its fit with project conventions. Present them briefly and ask which fits the objective.
5. **Converge.** Once an approach is chosen, delete the others from the note, merge duplicates, and remove anything outdated.
6. **Hand off.** Give the note's path, the critical discoveries, the one recommendation, and what implementation should do first.

## Hard rules

- Write only the research note. Mechanism: research that also edits code stops being a neutral input to planning.
- Record only what you verified by reading or running something. Mechanism: a plan built on an assumption fails later and is hard to trace back.
- Keep one living note and prune it. Mechanism: stale alternatives left in a note get implemented by mistake.
- Keep chat updates short and point to the note rather than repeating it. Mechanism: duplicated text in two places drifts.
- Separate fact from inference and say which is which.

## References

- [method-and-template.md](references/method-and-template.md): working method, note template, communication rules.

## Next

After a choice is made, implement with [flutter-developer](../flutter-developer/SKILL.md). For a debt-focused review see [flutter-tech-debt-plan](../flutter-tech-debt-plan/SKILL.md).
