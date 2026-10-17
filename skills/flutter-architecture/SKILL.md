---
name: flutter-architecture
description: >
  Applies the Flutter team's app architecture recommendations: UI and data
  layers, MVVM, repositories, unidirectional data flow, immutable models,
  dependency injection, navigation, naming and testing with fakes. Use when
  structuring a Flutter app or feature, deciding where logic belongs, reviewing
  widgets that hold logic, or planning tests per layer. Do not use for Dart
  naming and style (dart-code-standards) or for profiling and rebuild tuning.
---

# Flutter Architecture

Stance: separation of concerns is fixed; the specific packages and the amount of ceremony are flexible. The source labels each practice Strongly recommend, Recommend or Conditional, and those labels keep their weight: treat them as recommendations to adapt, not laws.

## Gate

| Situation | Action |
|---|---|
| The project already has an architecture that works | Follow it, even where it differs from the recommendations |
| New feature or app, no established pattern | Apply the Strongly recommend practices |
| Small app or simple logic | Skip Conditional practices (domain layer, separate API models) |
| Logic repeated across ViewModels, or ViewModels crowded with rules | Consider a domain layer |
| Unsure whether a practice fits | Say it is a judgement call and name the cost of each choice |

Reason: imposing a heavier structure than the app needs adds files and indirection without removing any risk.

## Steps

1. **Detect.** Find where logic lives today: business rules inside `build` methods or widget state, data access called straight from widgets, global singletons, mutable models changed from the UI.
2. **Fix.** Least invasive first:
   1. Move logic out of the widget into a ViewModel method; leave only the allowed view logic (show or hide from a flag, animations, layout from device information, simple routing).
   2. Put data access behind a repository, preferably an abstract class so tests and environments can swap implementations.
   3. Wrap each ViewModel action in a `Command` so loading, error and completed state is in one place, and return `Result` from services and repositories so failure must be handled.
   4. Make data models immutable and send updates one way: data layer to UI, with UI events passed back to the data layer.
   5. Inject dependencies instead of reaching for globals.
3. **Verify.** Unit test each service, repository and ViewModel method, using fakes. Widget test views, with routing and dependency injection as priority areas. Confirm behaviour is unchanged.

The full table of practices, priorities and reasons is in [recommendations.md](references/recommendations.md). Services, repositories, API versus domain models, Result, Command and injection are detailed in [data-layer-patterns.md](references/data-layer-patterns.md).

## Hard rules

- Keep logic out of widgets. Mechanism: logic in widgets cannot be unit tested without a widget tree and gets duplicated between screens.
- Data flows one way. Mechanism: with a single update path, a wrong value has one place to originate.
- Models are immutable. Mechanism: changes need a new instance, so the UI layer cannot modify data by accident.
- Depend on abstract repositories, not concrete ones. Mechanism: abstraction allows development, staging and test implementations without edits to callers.
- Avoid globally accessible objects; inject. Mechanism: globals hide dependencies and cannot be replaced in tests.
- Name classes for their role (`HomeScreen`, `HomeViewModel`, `UserRepository`, `ClientApiService`) and avoid names that clash with SDK concepts. Mechanism: the name tells a reader which layer they are in.
- Follow the project's existing packages for state management, injection and navigation. Mechanism: the recommendations name `provider`, `ChangeNotifier` and `go_router` as examples; the principle matters more than the package.
- Services are stateless wrappers around one external API, and repositories are the only place data is changed. Mechanism: one writer per kind of data means one place to look when it is wrong.
- Return `Result` rather than throwing across layers. Mechanism: Dart exceptions are unchecked, so a forgotten catch becomes a crash.
- Subscribe to the smallest slice of state a widget needs, so a change rebuilds only what shows it. Mechanism: a broad subscription rebuilds the whole screen for one changed field; for measured rebuild problems hand off to the performance companion (flutter-perf-build-and-rebuild).
- Generated models (`freezed`, `built_value`) trade build time for less hand-written code; say so when proposing them.

## References

- [recommendations.md](references/recommendations.md): every practice with its priority and reason.
- [data-layer-patterns.md](references/data-layer-patterns.md): services, repositories, Result, Command, dependency injection.

## Next

For calling a Django backend see [flutter-django-integration](../flutter-django-integration/SKILL.md). For theming see [flutter-design-system](../flutter-design-system/SKILL.md). For Dart-level style see [dart-code-standards](../dart-code-standards/SKILL.md). To investigate an unfamiliar codebase first see [flutter-task-research](../flutter-task-research/SKILL.md). Back to [flutter-developer](../flutter-developer/SKILL.md).
