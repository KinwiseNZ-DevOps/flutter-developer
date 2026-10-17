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
