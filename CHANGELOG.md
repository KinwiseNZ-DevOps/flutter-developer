# Changelog

All notable changes to this plugin are listed here, newest first. To cut a release, add your notes under "Unreleased", then run `python scripts/bump_version.py patch` (or `minor` or `major`). It updates the plugin version and moves those notes under the new version.

## [Unreleased]

- Added triggering tests (`evals/triggers.jsonl`): every skill has an obvious, a paraphrase and an unrelated query, checked by the validator and exported as `tool_used` graders.
- The always-on rules now default to `auto`, so they load only in Flutter projects (a `pubspec.yaml` that mentions Flutter).
- Moved Hard rules to the top of every skill, above the gate.
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
