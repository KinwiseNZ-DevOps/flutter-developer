# Flutter design system, theming and accessibility

Sources fetched 2026-10-18 unless marked. "(inference)" marks the author's reading or general Flutter practice not stated on the fetched page.

- Themes: https://docs.flutter.dev/cookbook/design/themes (official)
- ThemeExtension: https://api.flutter.dev/flutter/material/ThemeExtension-class.html (official)
- Accessibility: https://docs.flutter.dev/ui/accessibility (official)
- Architecture naming guidance: https://docs.flutter.dev/app-architecture/recommendations (official)

## 1. One source of design values

Official: set `MaterialApp.theme` to a `ThemeData`. The two properties most themes set are `colorScheme` and `textTheme`, and both affect the whole app. `ColorScheme.fromSeed(seedColor: ..., brightness: ...)` generates a full colour scheme from one seed colour, and switching `brightness` recolours everything for a light or dark background.

Read values with `Theme.of(context)`, for example `Theme.of(context).colorScheme.primary`. Styling resolves in this order: styles on the specific widget, then a `Theme` widget that overrides the parent, then the app theme.

Rules that follow (inference from this):

- Do not hard-code colours, font sizes or radii in widgets. Reason: a value written in a widget cannot follow a rebrand, dark mode or user text settings.
- Use `colorScheme` roles (`primary`, `onPrimary`, `surface`, and so on) so text on a coloured surface always uses the paired `on` role.
- Use theme text styles (`textTheme`) and adjust with `copyWith`, rather than building `TextStyle` values from scratch.
- Provide a dark theme as well as a light one through `darkTheme` and `themeMode` on `MaterialApp` (standard Flutter practice; the fetched themes page shows only `brightness`).

Material 3: the fetched Flutter pages did not document `useMaterial3`. Flutter's own changelog made Material 3 the default from version 3.16 (general knowledge, verify against the Flutter version the project uses). Do not set `useMaterial3: false` in new code.

## 2. Local overrides

Official: wrap a subtree in `Theme`, either with a fresh `ThemeData` (ignoring the app theme) or with `Theme.of(context).copyWith(...)` to change only some values. Prefer `copyWith`, so the subtree still follows the app theme.

## 3. Custom design tokens with ThemeExtension

Official: `ThemeExtension` is an interface for custom additions to `ThemeData`, typically custom colours. A subclass defines its fields and implements `copyWith` (copy with replaced non-null fields) and `lerp` (interpolate with another instance, so values change smoothly when the theme switches).

Registration and reading (the fetched API page did not show these; standard Flutter usage, verify in the API docs): pass instances in `ThemeData(extensions: [...])` and read with `Theme.of(context).extension<MyTokens>()`. Provide both a light and a dark instance.

Use an extension for values `ColorScheme` and `TextTheme` do not model: spacing scale, corner radii, semantic colours (success, warning), elevation or motion durations (inference). Keep a token set small and named for meaning, not for appearance (`danger`, not `redDark`). Reason: a name tied to appearance breaks when the palette changes.

## 4. Matching an external design system

When a design team supplies tokens (for example exported from a design tool or a shared tokens file):

- Treat the token file as the source of truth, and map each token to exactly one place: a `ColorScheme` role, a `TextTheme` style, or a `ThemeExtension` field (inference).
- Do not scatter token values through widgets. Convert once, in the theme layer.
- Put shared, themed widgets in one directory such as `ui/core/`. Flutter's architecture guide suggests `ui/core/` rather than `widgets/`, to avoid names that clash with SDK concepts.
- Where the design system and Material defaults disagree, theme the component (for example through `ThemeData` component themes) before writing a custom widget (inference).

Generated token code is a project decision. If used, keep the generated file out of hand edits and regenerate it in CI like any other generated file (inference).

## 5. Accessibility as part of the design system

Official release checklist (Flutter accessibility page):

- UI stays legible and usable at very large text and display scale factors.
- Contrast ratio of at least 4.5:1 between text or controls and their background. Disabled components are exempt. Controls should remain usable in colour-blind and grayscale modes.
- Tappable targets at least 48 by 48 logical pixels.
- Screen readers (TalkBack on Android, VoiceOver on iOS) describe every control intelligibly.
- Every active control does something; do not leave no-op callbacks.
- Important actions can be undone, and error fields suggest corrections.
- Context does not change automatically while the user types.

Practice (general Flutter guidance, the fetched page did not show code): use theme text styles so user text settings apply; avoid fixed heights on text containers; wrap custom tappable widgets in `Semantics`; and run `flutter_test` guideline matchers (`androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`) in widget tests. These matchers complement, and do not replace, manual screen reader testing.

Because themed shared widgets are used everywhere, accessibility fixed in a shared widget is fixed for the whole app (inference).

## 6. Review checklist

- No literal colours, font sizes or radii in feature widgets.
- Light and dark themes both exist and both pass the contrast check.
- Custom tokens live in a `ThemeExtension` with `copyWith` and `lerp`.
- Shared widgets live in one core directory and read from the theme.
- Large text and a narrow screen do not overflow.
- Tap targets and labels pass the guideline tests.
