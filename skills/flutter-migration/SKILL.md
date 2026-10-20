---
name: flutter-migration
description: >
  Plans and performs Flutter and Dart SDK upgrades and breaking-change
  migrations: deprecated API removals, Android Gradle Plugin and Kotlin
  build changes, and other changes listed on the Flutter breaking-changes
  page. Use when upgrading the Flutter or Dart version, when a build fails
  after an SDK or Android Gradle Plugin upgrade, or when fixing a
  deprecation warning tied to a specific Flutter version. Do not use for
  app-level architecture decisions (flutter-architecture) or for routine
  feature work with no version or build change involved.
---

# Flutter Migration

Keep the app building and behaving the same while the Flutter or Dart version, or a native build tool under it, changes. The project's current versions and the specific breaking-change guide for the gap being crossed decide the steps; do not guess at a change from its title alone.

## Gate

| Situation | Action |
|---|---|
| No upgrade, build failure or deprecation warning is requested or evidenced | Do not start a migration |
| An SDK upgrade, Android Gradle Plugin upgrade, or named deprecation warning is the request | Inventory current versions, find the matching guide, plan the smallest staged change |
| The change is listed as "not yet released to stable" | Do not apply it to a production app; say so and wait for a stable release |
| A Flutter plugin blocks the migration (still uses the old API) | Check the plugin's changelog on pub.dev before assuming it is unmigrated |

## Steps

1. **Inventory.** Read `pubspec.yaml` for the Flutter and Dart SDK constraints, `android/gradle.properties` and `android/settings.gradle(.kts)` for the Android Gradle Plugin and Kotlin versions, and run `flutter --version`. Note the gap between the current and target version.
2. **Find the guide.** Check the [Flutter breaking-changes index](https://docs.flutter.dev/release/breaking-changes) for every entry between the current and target version, not only the one named in the request; an SDK bump usually crosses several. [android-built-in-kotlin.md](references/android-built-in-kotlin.md) holds the distilled steps for the Android Gradle Plugin 9 Kotlin migration, the one most likely to break a build today.
3. **Migrate in small steps.** Apply one guide at a time. Prefer the project's existing patterns over a rewrite. For a flag-gated change (for example `android.builtInKotlin`), confirm every dependency supports the new behaviour before turning the flag on everywhere.
4. **Verify.** Build and run the app (`flutter build apk`, `flutter build ios`, or the platform that changed), then run `dart format`, `dart analyze` (or `flutter analyze`) and `flutter test`. State which checks ran and which were skipped.

## Hard rules

- Do not apply a change still marked "not yet released to stable". Mechanism: its final shape can still change before release. Reason: migrating early means migrating twice.
- Do not enable a build flag (such as `android.builtInKotlin=true`) before every plugin the app depends on supports it. Mechanism: one unmigrated plugin breaks the whole build, and the failure looks unrelated to the flag. Reason: flipping a global flag is all-or-nothing.
- Do not assume a breaking-change title fully describes the fix. Mechanism: titles are summaries; the linked guide has the exact code and file changes. Reason: guessing from a title produces plausible but wrong edits.
- State the Flutter and Dart versions involved in every migration change. Mechanism: the same symptom can have different fixes on different versions. Reason: an undated fix cannot be checked against the project later.

## References

- [Flutter breaking-changes index](https://docs.flutter.dev/release/breaking-changes): every entry since Flutter 1.17, newest first.
- [android-built-in-kotlin.md](references/android-built-in-kotlin.md): the Android Gradle Plugin 9 built-in Kotlin migration, distilled from the official app-developer and plugin-author guides.

## Next

- Structural or layer questions that come up while migrating: [flutter-architecture](../flutter-architecture/SKILL.md)
- Dart-level style of the migrated code: [dart-code-standards](../dart-code-standards/SKILL.md)
- Back to [flutter-developer](../flutter-developer/SKILL.md)
