# Widget patterns

Distilled from the basics of the official Flutter documentation and a beginner course's slides. Each rule has its reason. Check the project's Flutter version before relying on a newer API.

Also distilled from *Flutter App Development* (Payne, Apress, 2024), chapters 4, 6 and 11 to 16 and appendix E, for the form, layout, navigation and debugging rules.

Contents: stateless or stateful, const, State lifecycle, changing state, passing state, keys, layout and constraints, gestures, forms, navigation, dialogs, animations, adaptive layouts, reading errors.

## Stateless or stateful

- A stateless widget shows what its parent gives it. It redraws only when the parent rebuilds it.
- A stateful widget keeps its own data in a `State` object and redraws when you change that data with `setState` (or the project's tool).
- Default to stateless. Reason: less to dispose, less to go wrong, easier to test.
- Data that outlives the widget, or that other screens read, does not belong in a `State`. Use the project's state tool.

## const

- Mark a widget `const` when everything inside it is fixed at compile time. Flutter then reuses one object instead of rebuilding it.
- Turn on `prefer_const_constructors` in `analysis_options.yaml` and let the lint point them out. Reason: it is free and reviewers stop arguing about it.
- `const` cannot hold a value that is only known when the app runs.
- `final` means set once at run time; `const` means fixed at compile time; `var` can change.

## The State lifecycle

```dart
class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

- `initState` runs once. Call `super.initState()` first. Reason: the framework expects its setup before yours.
- `dispose` frees what you created. Call `super.dispose()` last. Reason: the framework tears down after yours.
- Do not read inherited values such as `Theme.of(context)` in `initState`. Use `didChangeDependencies` or `build`.
- After an `await`, the widget may be gone. Check `if (!context.mounted) return;` before using the context (inside a `State`, `mounted` also works).

## Changing state

- Replace instead of mutate: `setState(() => _items = [..._items, newItem]);` rather than `_items.add(newItem)`. Reason: a new list is visible to anything comparing references and to tests.
- With `final list = [...]` you can still call `list.add(...)`, because `final` stops reassigning, not editing. Do not rely on that for state.
- Use the spread `...` to copy items into a new list. Writing `[old, x]` puts the old list in as one item.
- The `map` method returns a lazy sequence; call `.toList()` when a list is required, for example for `children`.

## Passing state and changes

- Data flows down through constructor arguments. Changes flow up through callbacks such as `onChanged`.
- When two siblings need the same value, lift it to the nearest parent that contains both.
- When many levels would only pass it along, use the project's state tool or an inherited widget. Which tool is the project's choice; see [flutter-architecture](../../flutter-architecture/SKILL.md).

## Keys

- Flutter matches widgets to their old elements by type and position. Stateful items in a reorderable or filterable list can then keep the wrong state.
- Give them `ValueKey(item.id)`. Reason: the id follows the item, the index does not.
- Use `ObjectKey` when the whole object is the identity, and `GlobalKey` rarely, for example to reach a `FormState`.
- Stateless rows with no internal state do not need keys.

## Layout and constraints

- The rule: constraints go down, sizes go up, the parent sets the position.
- A `Column` gives its children unbounded height. A `ListView` placed directly inside a `Column` then raises an error about unbounded height. Fix it with `Expanded` or `Flexible` around the list, or a fixed height if the design wants one.
- `Row` mirrors this for width.
- `Expanded` and `Flexible` work only directly inside `Row`, `Column` or `Flex`.
- `Stack` layers widgets on top of each other; use `Positioned` for placement inside it.
- Prefer `Padding`, `SizedBox` spacing and `LayoutBuilder` or `MediaQuery.sizeOf(context)` to hard-coded sizes. Reason: screen sizes, text scale and platforms vary.
- Overflow fixes: `Wrap` for flowing items such as tags, `Flexible` or `FittedBox` to squeeze a few known children, a scroll widget when content may be longer than the screen. Overflow stripes show only in debug mode; a release build silently clips, so a stripe that "vanishes" is still a bug.
- `SingleChildScrollView` builds every child up front, so use it for short content only. `ListView` (and `.builder`, `.separated`) builds what is near the screen. Use `InteractiveViewer` for two-axis pan and pinch zoom.
- `GridView.extent(maxCrossAxisExtent: ...)` keeps item size steady and changes the column count with width; `GridView.count` fixes the columns and resizes the items. Prefer `.extent` unless the design needs a fixed column count.
- `Container` with no child fills the space it is given; with a child it shrinks to it, but setting `alignment` makes it grow. It cannot take both `color` and `decoration`: put the colour inside `BoxDecoration`. Width and height are honoured only within the parent's constraints.
- Put `SafeArea` inside the `Scaffold`, around the body. An `AppBar` `leading` widget replaces the automatic drawer icon, so leave it out when using a drawer.
- Use `Table` only for data whose rows and columns must line up; nested `Row` and `Column` do not align across rows.

## Gestures

- Built-in widgets already handle the common case: every button variant exposes `onPressed`; `Dismissible` handles a swipe that removes the wrapped widget, with a different `background` colour per swipe direction.
- For anything else, wrap the widget in `GestureDetector`. Decide the gesture-to-behaviour mapping before writing code, then wire each one: tap/double-tap to `onTap`/`onDoubleTap`, long press to `onLongPress`, horizontal swipe to `onHorizontalDragStart`/`Update`/`End`, vertical swipe to the vertical equivalents, diagonal to `onPanStart`/`Update`/`End`, pinch to `onScaleStart`/`Update`/`End` (`scale` in the update event is above 1.0 for a spread-out gesture, below 1.0 for a pinch-in).
- A drag start event gives a position but not a direction. To detect left versus right, record the starting X position in `onHorizontalDragStart`, compare it to the current X on each `onHorizontalDragUpdate` to track which way the finger is moving, then act on that in `onHorizontalDragEnd`.
- `GestureDetector` is non-visual: it only wraps or nests another widget, with no bloat besides `child` and the event callbacks. Gesture callbacks run outside the build cycle, so marking one `async` and `await`-ing inside it is safe.

## Forms

- Wrap fields in `Form` with a `GlobalKey<FormState>`. Each `TextFormField` has a `validator` that returns an error string or `null`.
- On submit: `if (_formKey.currentState!.validate()) { _formKey.currentState!.save(); ... }`. Use `reset()` to clear.
- Validate on the client for convenience and on the server for truth. Reason: the client can be bypassed.
- A bare `Checkbox`, `Switch`, `Radio` or `Slider` has no `validator` or `onSaved`. Wrap it in a `FormField` to join the form's `save`, `validate` and `reset`; wrap a `Radio` group as one `FormField`, not one per button. `TextFormField` and `DropdownButtonFormField` already include this.
- `inputFormatters` limits which characters can be typed; `keyboardType` only changes the keyboard shown. Use both when a field must be numeric.
- Dispose any controllers you made. Keep keyboard type and autofill hints correct for each field.

## Navigation

- With the plain `Navigator`, `push` puts a screen on top of the stack and `pop` removes it. The top screen is the visible one.
- If the project uses a router package such as `go_router`, use its API for every route and do not mix in `Navigator.push` for named routes.
- Combine at most two navigation styles, such as tabs at the top with stack navigation inside each tab. Reaching a drawer or tab child by another route can hide the back button and strand the user.
- Pass the smallest thing a route needs, such as an id, not a whole mutable object.

## Dialogs and modals

- `showDialog` and `showModalBottomSheet` need a context below a `Scaffold` and `MaterialApp`. Await the result and check `context.mounted` before acting on it.

## Animations

- Prefer implicit animations (`AnimatedContainer`, `AnimatedOpacity`, `TweenAnimationBuilder`). Flutter runs them for you.
- Use explicit animations (`AnimationController`) only when you need to start, stop or repeat by hand. Dispose the controller and give it `vsync` through a ticker provider mixin.
- Respect the reduce-motion setting where the project offers it; see [flutter-design-system](../../flutter-design-system/SKILL.md).

## Adaptive layouts

- Change layout by available width (for example `LayoutBuilder`), not by device name.
- Material widgets can look native with the platform's adaptive constructors where they exist. Check the version's docs before assuming one is available.

## Reading errors and debugging

- Read an error from the top. The first line says what went wrong; the first stack line that points at your own file is usually where to look.
- Common ones: unbounded height or width (layout), `setState` called during build (triggering a rebuild while building), `setState` called after dispose (missing mounted check), and a null check on a value that is not set yet.
- Use the Flutter DevTools widget inspector to see the tree and sizes. Use breakpoints and `debugPrint` for flow. Debug mode is for finding bugs; it is not a speed measure.
- Turn on debug painting (VS Code: "Flutter: Toggle debug painting"; Android Studio: Flutter Inspector, Show debug paint) to see layout. Boxes get a teal border, padding blue, alignment yellow arrows, scrollables green arrows. A normal step debugger cannot show layout.
- The debugger raises some runtime assertions that a release build swallows, so a bug that disappears outside the debugger is not fixed.

## Out of scope

Network calls, caching and auth: [flutter-django-integration](../../flutter-django-integration/SKILL.md). Speed: flutter-performance-specialist if installed.
