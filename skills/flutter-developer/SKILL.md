---
name: flutter-developer
description: >
  Router and shared guardrails for Dart and Flutter development work, including
  Django API integration and design systems: picks the right specialist skill and enforces verify-before-claiming, smallest-change
  and honest close-out rules. Use when a task touches Dart or Flutter code, when
  starting any Flutter change, or when it is unclear which skill applies. Do not
  use for backend work, or for performance profiling and optimisation.
---

# Flutter Developer

Stance: the official Dart and Flutter guidance, the project's own conventions and the real code are fixed points; the size of the change and the order of work are flexible. Read the code before judging it, change as little as the task needs, and report exactly what was and was not checked.

## Gate

| Situation | Action |
|---|---|
| Request is about Dart or Flutter code, structure, planning or build automation | Route using the table below |
| Request is about backend code, deployment platforms or profiling | Leave it alone, say another skill or repo owns it |
| Request is a one-line fix with an obvious cause | Make it directly, then run the checks in step 4 |
| Unsure which skill applies | Ask one short question, or start with `flutter-task-research` |

Reason: routing a trivial fix through a full workflow wastes effort, and routing a design question straight to code produces changes nobody planned.

## Routing

| The task is about | Use |
|---|---|
| Naming, formatting, doc comments, null handling, async, error handling, public API shape | [dart-code-standards](../dart-code-standards/SKILL.md) |
| Layers, ViewModels, repositories, data flow, dependency injection, navigation, test strategy | [flutter-architecture](../flutter-architecture/SKILL.md) |
| Understanding a codebase or comparing approaches before any change | [flutter-task-research](../flutter-task-research/SKILL.md) |
| Finding and scoring technical debt, producing a remediation plan | [flutter-tech-debt-plan](../flutter-tech-debt-plan/SKILL.md) |
| Calling a Django REST API: models, auth, errors, pagination, CORS | [flutter-django-integration](../flutter-django-integration/SKILL.md) |
| Widget and screen code: stateless or stateful, const, keys, layout constraint errors, forms, dispose, local state, reading Flutter errors | [flutter-widget-fundamentals](../flutter-widget-fundamentals/SKILL.md) |
| Theming, design tokens, dark mode, contrast, tap targets, text scaling, dashboards and stat screens | [flutter-design-system](../flutter-design-system/SKILL.md) |
| Makefile targets that wrap build, analyse, generate or test commands | [make-automation](../make-automation/SKILL.md) |
| Flutter or Dart SDK upgrades, deprecation warnings, Android Gradle Plugin or Kotlin build changes | [flutter-migration](../flutter-migration/SKILL.md) |

## Steps

1. **Orient.** Read the project's own conventions first: lint rules (`analysis_options.yaml`), `pubspec.yaml`, folder layout, and the packages already used for state and navigation. Follow them over any generic advice.
2. **Route.** Pick the skill from the table. For a change that needs understanding first, run `flutter-task-research`, then implement.
3. **Change.** Make the smallest correct change. Match surrounding naming, comment density and idiom.
4. **Verify.** Run, in this order, whatever the project supports: `dart format`, `dart analyze` (or `flutter analyze`), then `flutter test`. A skipped check is reported as skipped.

## Hard rules

- Never describe code you have not opened. Mechanism: file names and docs describe intent, not behaviour, so confident claims about unread files are wrong often enough to mislead a review.
- Follow the project's existing choices (state management, navigation, code generation) over a fresh preference. Mechanism: a second pattern in one codebase costs every later reader more than the better pattern saves.
- Do not add comments, abstractions, error handling or refactors the task did not ask for. Mechanism: each extra line is extra review burden and extra risk.
- Do not claim completion beyond the evidence. State which checks ran and their results, which were skipped and why, and what risk remains. Mechanism: an unqualified "done" hides the gap between written and verified.
- Keep project-specific facts out of shared guidance; read the project's architecture at runtime instead.

## Companion plugins (use when installed)

| Work | Hand off to |
|---|---|
| Profiling, rebuild cost, list scrolling, isolates, image and effect cost, "the app feels slow" | flutter-performance-specialist (start with flutter-perf-audit) |
| Server-side API work that a Flutter change depends on | django-api-architect and its specialist skills |

This repo owns correctness, structure and integration; the companions own measurement and server code. Do not optimise without a profile, and do not edit server code from here. If a companion is not installed, say the hand-off was skipped.

## References

Depth lives in the specialist skills above; this skill holds only routing and the shared rules.

## Next

Start with the row of the routing table that matches the task.

## Always-on mode

When the plugin is installed, a start-up hook adds [always-on-rules.md](references/always-on-rules.md) to every Claude Code session. The user can say "stop flutter mode" to pause it, or ask for the saved mode to be set to on, off or auto. The rules file is the single source of those rules; edit it, not a copy. The same hooks also run safety checks (risky commands, secrets, invented packages, licences, risky code patterns, suspicious pasted prompts, and a reminder when code changed but no checks ran). Each can be switched off in the features file described in the README, and none edits a file on its own.
