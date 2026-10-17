# Flutter app architecture recommendations

Verified against the live page on 2026-10-18. Condensed from the Flutter team's architecture recommendations (https://docs.flutter.dev/app-architecture/recommendations). Trust level: official. These are recommendations to adapt, not fixed rules. Priority labels come from the source: Strongly recommend, Recommend, Conditional. "(inference)" marks the author's reading.

## Separation of concerns

Split the app into a UI layer and a data layer, then split each by responsibility. Reason: this is the most important architectural principle; each class then has one reason to change.

| Practice | Priority | Mechanism |
|---|---|---|
| Clearly defined data layer and UI layer | Strongly recommend | Data layer exposes app data and holds most business logic. UI layer shows data and receives user events, using separate classes for UI logic and widgets |
| Repository pattern in the data layer | Strongly recommend | Repositories and services isolate data access (databases, APIs, files) from business logic, so storage can change without touching callers |
| MVVM: ViewModels and Views in the UI layer | Strongly recommend | Keeps widgets "dumb", which makes the UI less error prone |
| `ChangeNotifier` and `Listenable` for widget updates | Conditional | Ships with the SDK and lets widgets observe a ViewModel. State-management choice is otherwise a matter of preference |
| No logic in widgets | Strongly recommend | Logic lives in ViewModel methods |
| Domain layer (use cases) | Conditional | Only for complex logic that crowds ViewModels or is repeated across them; in most apps it is overhead |

Logic a view may legitimately contain:

- Simple if-statements that show or hide widgets from a flag or nullable ViewModel field.
- Animation logic that depends on the widget.
- Layout logic based on device information such as screen size or orientation.
- Simple routing logic.

## Handling data

| Practice | Priority | Mechanism |
|---|---|---|
| Unidirectional data flow | Strongly recommend | State flows from data layer to UI; UI events go back to the data layer to be processed. Updates have one path, so bugs have one place to hide |
| `Command` objects for user-initiated events | Recommend | Prevent rendering errors and standardise how the UI sends events to the data layer. A Command exposes running, error and completed state; see [data-layer-patterns.md](data-layer-patterns.md) |
| Immutable data models | Strongly recommend | Changes require a new instance, so accidental edits in the UI layer cannot happen |
| `freezed` or `built_value` to generate models | Recommend | Generate JSON serialisation, deep equality and copy methods. Cost: significant build time in apps with many models |
| Separate API models and domain models | Conditional | For large apps. Adds verbosity but keeps wire-format quirks out of ViewModels and use cases |

## App structure

| Practice | Priority | Mechanism |
|---|---|---|
| Dependency injection | Strongly recommend | Avoids globally accessible objects, which are hard to replace and hide dependencies. The source suggests the `provider` package; other injection approaches also satisfy the principle (inference) |
| `go_router` for navigation | Recommend | Covers most apps. Use the Navigator API directly or another package for cases it does not solve |
| Name classes for their architectural role | Recommend | `HomeViewModel`, `HomeScreen`, `UserRepository`, `ClientApiService` |
| Avoid names that collide with SDK concepts | Recommend | Put shared widgets in `ui/core/`, not `widgets/`, to avoid confusion with SDK widgets |
| Abstract repository classes | Strongly recommend | Repositories are the source of truth for data. An abstract class permits different implementations per environment (development, staging) and test fakes |

## Testing

- Test architectural components separately and together (Strongly recommend). Write unit tests for every service, repository and ViewModel, each method tested individually. Write widget tests for views, with routing and dependency injection as priority areas.
- Make fakes for testing and write code that can use them (Strongly recommend). A fake cares about inputs and outputs, not internals, so designing for fakes pushes you toward small modules with clear contracts.

## Choosing packages

The source names `provider` for injection and `ChangeNotifier` for updates. Treat these as examples of the principle, not the only valid choice: any dependency injection and state-management approach is acceptable if it keeps data flow one-way, keeps logic out of widgets, and lets tests substitute fakes. Follow the packages the project already uses.
