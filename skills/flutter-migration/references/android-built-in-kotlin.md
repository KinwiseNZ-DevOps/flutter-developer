# Android Gradle Plugin 9: migrating to built-in Kotlin

Android Gradle Plugin (AGP) 9.0.0 dropped support for applying the separate Kotlin Gradle Plugin (`kotlin-android`, or `org.jetbrains.kotlin.android`). A project that still applies it fails to compile on AGP 9+. Flutter lets a project keep using the old plugin for a while so teams can migrate, but that support will be removed in a later Flutter version with no fixed date yet, so do not treat it as permanent.

## Who needs the full migration

Only an app that applies the Kotlin Gradle Plugin needs every step below. If `android/app/build.gradle(.kts)` has no `kotlin-android` plugin and no `kotlinOptions` block, add only the `android.newDsl=false` flag in step 1 and stop there.

## Version requirements

- Android Gradle Plugin 9.0.0 or newer, with the minimum dependency versions AGP's own release notes list.
- Flutter 3.44 or newer to use AGP 9 at all, with built-in Kotlin still switched off.
- Flutter 3.47 or newer before switching built-in Kotlin on.

## Steps

1. **Set the Gradle property flags.** In `<project>/android/gradle.properties`:
   ```properties
   android.newDsl=false
   android.builtInKotlin=false
   ```
   `flutter run`, `flutter build apk` and Android Studio add these automatically for a normal Flutter project. An add-to-app host app builds natively, so its own `gradle.properties` needs these added by hand.
2. **Replace the Kotlin plugin block.** In `<app>/android/app/build.gradle(.kts)`: remove the `kotlin-android` plugin entry (or, in an add-to-app host using version catalogs, the `alias(libs.plugins.kotlin.android)` line) and the `kotlinOptions { }` block, then add a `kotlin { compilerOptions { } }` block with the same settings (for example `jvmTarget`). The exact syntax differs between the Kotlin DSL (`build.gradle.kts`) and Groovy (`build.gradle`); check which one the project uses, since the old `apply plugin:` form only exists in Groovy.
3. **Turn built-in Kotlin on once everything is migrated.** Confirm the app and every Flutter plugin it depends on build under AGP 9 first, then set `android.builtInKotlin=true` and rebuild. An unmigrated plugin that still applies the Kotlin Gradle Plugin will break this step; that is expected, not a new bug.
4. **If a plugin is the blocker**, check its pub.dev page and changelog for a migrated release before assuming none exists. If none has migrated, raise it with the plugin's maintainers rather than patching around it in the app.

## Keeping the generated files current

The Gradle files a `flutter create` or `flutter upgrade` generates match the Flutter version that created them. Run `flutter upgrade` in the project root periodically so these flags and templates do not fall behind the version actually in use.

## Source

Distilled from Flutter's official migration guides for [app developers](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers) and [plugin authors](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-plugin-authors). Check those pages for the exact current code samples before editing a build file; this page is a summary, not a copy.
