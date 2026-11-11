# Flutter data layer patterns: services, repositories, Command and Result

Sources (official, fetched 2026-10-18): https://docs.flutter.dev/app-architecture/case-study/data-layer, /design-patterns/command, /design-patterns/result, /case-study/dependency-injection. "(inference)" marks the author's reading.

## Services and repositories

- The data layer is the app's model. It is the source of truth for data and the only place data should be changed.
- Services are stateless classes without side effects whose only job is to wrap an external API (an HTTP server or platform plugin). Usually one per data source. They return API models holding raw data.
- A repository manages one type of app data. It handles polling, retry logic, cached data, transformation to domain models, and offline synchronisation when supported. The service is a private dependency.
- Repositories and services are many to many: a service can feed several repositories, and a repository can combine several services.
- API models hold raw server data that often needs filtering, combining or trimming. Domain models hold only what the rest of the app needs. Every repository outputs domain models.
- An abstract repository class lets you swap implementations, for example remote and local.

## Event cycle

User acts in the UI, the ViewModel handles it and passes the change to the repository, the repository calls the service and returns a Result, the ViewModel consumes the Result and calls `notifyListeners`, and the UI updates.

## Result pattern

- Dart exceptions are unchecked, so a forgotten catch surfaces as a crash.
- A sealed `Result<T>` with `Ok` (value) and `Error` (exception) subclasses makes handling explicit: the compiler checks an exhaustive `switch`.
- Services catch exceptions from the HTTP client and parsing and return `Result.error`. Repositories pass results through or combine them (for example fall back to a second source). ViewModels `switch` on the result, set state and notify.
- Catch `Exception` types, not `Error` types, consistent with Effective Dart.
- The guide presents this as a recommendation. Packages such as `result_dart` exist as alternatives.

## Command pattern

- A `Command` wraps one ViewModel action and exposes its state: `running`, `error`, `completed`, and a way to clear the state after the UI has handled it.
- Problem solved: with several actions, plain methods multiply state flags (`runningLoad`, `errorLoad`, `runningEdit`), and UI reactions such as a snackbar need boilerplate and must clear the error so it does not fire on every `notifyListeners`.
- `execute()` ignores calls while running, which stops repeated taps from starting the action twice, sets running, resets error and completed, runs the action, captures a thrown exception, then clears running and notifies.
- The ViewModel exposes command fields (for example `load`, `delete`) and keeps the underlying methods private. The view calls `viewModel.load.execute()` and listens to the command with `ListenableBuilder` for progress and error UI.
- Variants take zero or one argument. The `command_it` package is a ready-made implementation.

## Dependency injection

- Dependencies arrive through constructors, for example a repository takes a service. Injected fields are private to the consumer so views cannot reach a repository through the ViewModel.
- The Compass sample provides services first, then repositories (read services with `context.read()`), then creates ViewModels in the route configuration, using `package:provider`. The guide says Google teams recommend `provider`.
- Concrete implementations are provided as their abstract type (`as AuthRepository`).
- The page does not cover fakes or per-environment switching. A compile-time flag such as `--dart-define` with `bool.fromEnvironment` choosing between a fake and a remote implementation is a workable approach (inference).

### `context.read()`/`provider` versus a service locator (`get_it`)

Community practice, not an official Flutter team recommendation; follow the project's existing choice over either.

- `context.read()` with `provider` (or `RepositoryProvider` from `flutter_bloc`, the same mechanism) is itself a form of service location, with `BuildContext` acting as the registry: a dependency is provided at some point in the widget tree and fetched by type from any descendant. It ties a dependency's lifetime to a position in the widget tree, which is a genuine fit for a dependency scoped to one feature or screen, but awkward for code that has no legitimate reason to hold a `BuildContext` (a background isolate, a plain Dart class used from tests or from outside the widget tree).
- `get_it` (https://pub.dev/packages/get_it) registers dependencies in one central runtime registry instead, with no `BuildContext` needed to fetch them. It exposes finer-grained lifetime control than `context.read()` does directly: `registerLazySingleton` (built on first access), `registerSingletonAsync` (for a dependency whose construction itself needs `await`, paired with `await GetIt.I.allReady()` before `runApp`), and factory registration (a fresh instance per request).
- Prefer `context.read()`/`provider` when the project already uses `provider` or `flutter_bloc`, or when a dependency's lifetime should genuinely match a part of the widget tree. Prefer `get_it` when a dependency needs async construction or fine-grained scope control, or when code outside the widget tree needs it. Either way, keep consumer classes (ViewModels, repositories) written only against constructor-injected interfaces, and confine direct calls to `context.read()` or `GetIt` to the single place that constructs them, so only that one wiring point is coupled to the chosen mechanism.

### Riverpod as a state-sharing option

- Source: *Flutter App Development* (Payne, Apress, 2024), Chapter 8. This is community practice, not the Flutter team's recommendation, so treat it as one valid choice beside `provider` and `flutter_bloc`. Follow whichever the project already uses; do not add a second.
- Setup: add `flutter_riverpod`, wrap the root widget in `ProviderScope`, and declare each piece of shared state as a top-level provider (for example `final favColorProvider = StateProvider<Color>((_) => Colors.red);`). A widget that uses providers extends `ConsumerStatefulWidget` and `ConsumerState` (or `ConsumerWidget`) so it gets a `ref`.
- `ref.watch(provider)` subscribes: use it inside `build`, and the widget rebuilds when the value changes. `ref.read(provider)` reads the current value once without subscribing: use it in callbacks, and to write, as in `ref.read(provider.notifier).state = newValue`. Reason: `watch` in a callback, or `read` in `build`, gives a screen that never updates or a subscription that leaks.
- Like `provider` and `flutter_bloc`, it solves the same problem as `InheritedWidget`: sharing state between widgets that are not close in the tree. Keep ViewModels and repositories free of `ref` where practical, so only the wiring code is tied to Riverpod.
