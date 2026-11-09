# Changelog

All notable changes to this plugin are listed here, newest first. To cut a release, add your notes under "Unreleased", then run `python scripts/bump_version.py patch` (or `minor` or `major`). It updates the plugin version and moves those notes under the new version.

## [Unreleased]

## [0.11.0] - 2026-11-10

- Strengthened three skills with sourced detail from *Flutter Design Patterns and Best Practices* (Orlova,
  Kadah, Blasco, Packt, 2024) and *Flutter App Development* (Payne, Apress, 2024): dart-code-standards now
  states that a Future starts running at creation, not at await, and the pattern of starting independent
  Futures before awaiting any of them; flutter-architecture documents get_it as a sourced alternative to
  context.read()/provider for dependency injection, with a decision rule for each; flutter-widget-fundamentals
  gains a Gestures section (GestureDetector wiring, swipe-direction detection) it did not have before. The full
  annotated bibliography is in reference-content/sources/flutter-architecture-and-patterns.md (private, not
  published).

## [0.10.0] - 2026-11-05

- Added a Works with other repos section to the router skill and README: it names the repos this one depends on or is relied on by, and when to hand off. Marketing comes first in the decision order (marketing, then look and feel, then the technical work). The map is in skills-repos-dependency-map.md beside the repos.

## [0.9.0] - 2026-10-29

- Added the rule to act only when told and to analyse the repo before answering: no guesswork, no redoing finished work, and show the real artifact when asking the user to review or approve. It is in AGENTS.md and as a hard-rule bullet in every skill.

## [0.8.0] - 2026-10-26

- The validator now checks the Codex manifests (`plugin.json`, `.agents/plugins/marketplace.json`) against the Claude ones.
- Fixed the Codex short description, which was cut off mid-sentence.

- Added triggering tests (`evals/triggers.jsonl`): every skill has an obvious, a paraphrase and an unrelated query, checked by the validator and exported as `tool_used` graders.
- The always-on rules now default to `auto`, so they load only in Flutter projects (a `pubspec.yaml` that mentions Flutter).
- Moved Hard rules to the top of every skill, above the gate.
- `flutter-task-research` and `flutter-tech-debt-plan` are now user-only (`disable-model-invocation: true`): you start them with `/flutter-developer:<skill>`, so long investigations never begin on their own. The router tells the user to start them.
- Removed links between reference files so every reference is one level deep from its SKILL.md.

## [0.7.1] - 2026-10-23

- Added the rule to trust the user's description of their own system: check the real files, report facts only, and never argue then concede. It is in the always-on rules, the router hard rules, AGENTS.md and the agent profiles.

## [0.7.0] - 2026-10-22

- Added `flutter-widget-fundamentals`: widget kind, const, State lifecycle, keys, layout constraints, forms, navigation basics and error reading, distilled from beginner Flutter course slides.

## [0.6.0] - 2026-10-20

- Added BlinkPay open banking guidance to flutter-django-integration: in-app browser, return-link handling, app-resume reconciliation, platform deep-link setup, and what not to copy from BlinkPay's reference Flutter demo.

## [0.5.0] - unreleased

- Initial skills.
- Added flutter-migration: Flutter and Dart SDK upgrades, breaking-change fixes, and the Android Gradle Plugin 9 built-in Kotlin migration.
