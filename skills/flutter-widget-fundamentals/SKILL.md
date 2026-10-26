---
name: flutter-widget-fundamentals
description: >
  Applies core Flutter widget practice when writing or fixing widget code:
  stateless versus stateful choice, const widgets, the State lifecycle and
  disposing controllers, keys in reorderable lists, layout constraint errors,
  updating state without mutating shared lists, forms and validation, basic
  screen navigation, implicit animations, adaptive layout and reading error
  messages. Use when building or reviewing a widget or screen, fixing a layout
  or "unbounded height" error, a state that does not update or resets, a form,
  or when a newcomer needs the basics explained. Do not use for app layers and
  state management choice (flutter-architecture), theming (flutter-design-system),
  API calls (flutter-django-integration) or profiling.
---

# Flutter widget fundamentals

Stance: the Flutter framework rules and the project's own widgets, state tool and router are fixed points; how many widgets a screen is split into is flexible. Reach for the simplest widget that works. Frozen: dispose what you create, never use a `BuildContext` unsafely after an `await`, and follow the project's state and navigation packages. Flexible: file layout of small widgets and whether a form is split into parts.

## Hard rules

- Never mutate a list or map held in state and expect the screen to update; build a new one and set it through the state tool. Mechanism: the framework sees a change only when the reference or notification changes.
- Never create a controller inside `build`. Mechanism: `build` runs often, so each run leaks a new controller and loses the typed text.
- Never use an index as a key for items that can move. Mechanism: the index stays put while the item moves, so the state sticks to the wrong item.
- Never silence a constraint error with a guessed size. Mechanism: it hides the unbounded parent and breaks on another screen size.

## Gate

| Situation | Action |
|---|---|
| Widget, screen, layout, form or local state problem | Continue |
| Question is where logic lives, or which state tool to use | Hand to [flutter-architecture](../flutter-architecture/SKILL.md) |
| Question is theme, colour, contrast or text scaling | Hand to [flutter-design-system](../flutter-design-system/SKILL.md) |
| Question is a slow or janky screen | Say profiling is owned by flutter-performance-specialist if installed |
| Project already uses a state or navigation package | Use it; do not add a second one |

Reason: a second pattern in one codebase costs every later reader more than a better pattern saves.

## Steps

1. **Orient.** Open the widget and its parents. Note the state tool, router and lint rules in the project, as in [flutter-developer](../flutter-developer/SKILL.md).
2. **Choose the widget kind.** Default to a stateless widget. Use a stateful widget only for data that belongs to that widget and changes the screen, such as a text controller or an animation. See [widget-patterns.md](references/widget-patterns.md).
3. **Place the state.** If two widgets need the same changing data, move it to their nearest shared parent or to the project's state tool, not into copies. Pass changes down as callbacks.
4. **Fix layout by reading constraints.** A parent gives limits, the child picks a size inside them, and the parent places it. A scrolling or `Column` child inside an unbounded parent needs `Expanded`, `Flexible` or a fixed size. Check the cause before wrapping things in `SizedBox`.
5. **Clean up.** Anything the `State` creates (controllers, focus nodes, listeners, subscriptions, timers) is disposed in `dispose`. After an `await`, check `context.mounted` before using the context.
6. **Use keys only when needed.** Give a stable key (the item's id, not its index) to stateful items in a list that can reorder, insert or remove.
7. **Verify.** Run the checks in [flutter-developer](../flutter-developer/SKILL.md) and, for layout, look at a small and a large screen. Say what was not looked at.

## Checklist

```text
- [ ] Stateless unless the widget owns changing data
- [ ] const used where the lints allow it
- [ ] Shared state sits above every widget that uses it
- [ ] Controllers and listeners disposed
- [ ] context.mounted checked after await
- [ ] Reorderable stateful list items have stable keys
- [ ] No fixed pixel sizes where the screen can vary
- [ ] Project's state and router used, not a new one
```

## Example

Input: "My list of checkbox rows shows the wrong ticks after I delete the first row."
Output: the rows are stateful and have no keys, so Flutter reuses the old state by position. Give each row a `ValueKey` built from the item id, and keep the ticked value in the list data rather than in each row.

## References

- [widget-patterns.md](references/widget-patterns.md): rules and short examples for each step, in the order above.

## Next

[flutter-architecture](../flutter-architecture/SKILL.md) when state needs a home, [flutter-design-system](../flutter-design-system/SKILL.md) for looks. Back to [flutter-developer](../flutter-developer/SKILL.md).
