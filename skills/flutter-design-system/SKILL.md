---
name: flutter-design-system
description: >
  Applies a design system in Flutter through the theme layer: ThemeData,
  ColorScheme, TextTheme, ThemeExtension design tokens, light and dark themes,
  shared themed widgets and accessibility checks. Use when theming an app,
  mapping a design team's tokens to Flutter, removing hard-coded colours or
  sizes, adding dark mode, or checking contrast, tap targets and text scaling.
  Do not use for app structure (flutter-architecture) or for API integration.
---

# Flutter Design System

Stance: design values live in the theme, once. Frozen: no literal colours, font sizes or radii in feature widgets, and accessibility minimums. Flexible: which tokens to model and whether to generate token code.

## Gate

| Situation | Action |
|---|---|
| The project already has a theme layer and tokens | Extend it; do not add a second system |
| A design token fits a `ColorScheme` role or `TextTheme` style | Use that, not a custom token |
| A value has no Material home (spacing, semantic colours, radii) | Put it in a `ThemeExtension` |
| One widget needs a one-off look | Use a local `Theme` with `copyWith`, or a widget parameter |
| The design system and Material defaults disagree | Theme the component first; build a custom widget last |

Reason: every extra token system is one more place for values to drift from the design.

## Steps

1. **Detect.** Search feature code for literal colours (`Color(0x`, `Colors.`), raw `TextStyle(fontSize`, and fixed radii and paddings repeated across files. Read the existing `ThemeData`.
2. **Map tokens.** For each design token choose one home: a `ColorScheme` role, a `TextTheme` style, a component theme, or a `ThemeExtension` field. Convert once, in the theme layer.
3. **Build the theme.** `ColorScheme.fromSeed` (or an explicit scheme from the design) plus `textTheme`, supplied as both `theme` and `darkTheme`. Add a `ThemeExtension` with `copyWith` and `lerp` for custom tokens, and read it with `Theme.of(context).extension<T>()`.
4. **Replace literals.** Swap widget literals for `Theme.of(context)` lookups. Put shared themed widgets in one core directory.
5. **Verify accessibility.** Check contrast of 4.5:1, tap targets of at least 48 by 48, labels for custom controls, and large text without overflow. Run the `flutter_test` guideline matchers in widget tests, and test with a screen reader.

Full detail: [theming-and-accessibility.md](references/theming-and-accessibility.md).

## Hard rules

- No hard-coded colours, font sizes or radii in feature widgets. Mechanism: a value written in a widget cannot follow a rebrand, dark mode or the user's text settings.
- Pair every surface colour with its `on` role for text and icons. Mechanism: the pairing is what guarantees contrast when the scheme changes.
- Always supply a dark theme, and check contrast in both. Mechanism: a scheme that passes in light mode can fail in dark mode.
- Implement both `copyWith` and `lerp` on a `ThemeExtension`. Mechanism: without `lerp`, values jump instead of animating when the theme switches.
- Name tokens for meaning (`danger`), not appearance (`redDark`). Mechanism: appearance names break when the palette changes.
- Prefer `Theme.of(context).copyWith(...)` to a fresh `ThemeData` for local overrides. Mechanism: a fresh theme ignores the app theme and breaks dark mode in that subtree.
- Build `ThemeData` and `ThemeExtension` instances once, outside `build`. Mechanism: creating them inside `build` allocates new objects on every rebuild; hand rebuild-cost questions to the performance companion.
- Provide text-on-colour "ink" variants for accent colours used as text, and cover them with a contrast test. Mechanism: a fill colour that looks right as a background often fails 4.5:1 as text.
- Do not use fixed heights on text containers. Mechanism: large text settings overflow them.
- Do not turn off Material 3 in new code. Mechanism: it is the framework default from Flutter 3.16 onward (verify against the Flutter version in use), so opting out leaves a one-off look to maintain.

## References

- [theming-and-accessibility.md](references/theming-and-accessibility.md): theme resolution order, tokens, external design systems, accessibility checklist, review list.

## Next

For where shared widgets and ViewModels live see [flutter-architecture](../flutter-architecture/SKILL.md). For Dart naming see [dart-code-standards](../dart-code-standards/SKILL.md). Back to [flutter-developer](../flutter-developer/SKILL.md).
