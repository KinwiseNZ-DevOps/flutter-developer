---
name: flutter-design-system
description: >
  Use when theming an app, mapping a design team's tokens to Flutter, removing
  hard-coded colours or sizes, adding dark mode, checking contrast, tap targets
  and text scaling, or building a dashboard or data-heavy screen. Applies a
  design system in Flutter through the theme layer: ThemeData, ColorScheme,
  TextTheme, ThemeExtension design tokens, light and dark themes, shared themed
  widgets, accessibility checks and dashboard screens (stat strips, cards,
  adaptive layout). Do not use for app structure (flutter-architecture) or for
  API integration.
---

# Flutter Design System

Stance: design values live in the theme, once. Frozen: no literal colours, font sizes or radii in feature widgets, and accessibility minimums. Flexible: which tokens to model and whether to generate token code.

## Hard rules

- No hard-coded colours, font sizes or radii in feature widgets. Mechanism: a value written in a widget cannot follow a rebrand, dark mode or the user's text settings.
- Pair every surface colour with its `on` role for text and icons. Mechanism: the pairing is what guarantees contrast when the scheme changes.
- Always supply a dark theme, and check contrast in both. Mechanism: a scheme that passes in light mode can fail in dark mode.
- Implement both `copyWith` and `lerp` on a `ThemeExtension`. Mechanism: without `lerp`, values jump instead of animating when the theme switches.
- Name tokens for meaning (`danger`), not appearance (`redDark`). Mechanism: appearance names break when the palette changes.
- Prefer `Theme.of(context).copyWith(...)` to a fresh `ThemeData` for local overrides. Mechanism: a fresh theme ignores the app theme and breaks dark mode in that subtree.
- Build `ThemeData` and `ThemeExtension` instances once, outside `build`. Mechanism: creating them inside `build` allocates new objects on every rebuild; hand rebuild-cost questions to the performance companion.
- Provide text-on-colour "ink" variants for accent colours used as text, and cover them with a contrast test. Mechanism: a fill colour that looks right as a background often fails 4.5:1 as text.
- Do not copy a commercial UI kit's markup or code into the repository. Build each block from Flutter's own widgets and the project's theme. Mechanism: kit code is licensed, and a copy in a public or shared repository can breach the licence.
- Check what the project already has before adding a block, and extend that. Mechanism: a second empty-state or card widget beside an existing one splits the design system in two.
- Use `PaginatedDataTable` or a lazy list for large tables, not `DataTable`. Mechanism: `DataTable` measures every row twice and is not lazy, so large data makes it slow.
- Wrap a labelled group of separate controls (such as breadcrumbs) with `explicitChildNodes: true`. Mechanism: without it a screen reader merges the items into one node and cannot announce the current page.
- Never signal status with colour alone. Pair it with an arrow, a sign or a word, and give it a spoken label. Mechanism: WCAG 1.4.1 requires another cue because some users cannot tell the colours apart, and a screen reader cannot read a colour.
- Use tabular figures for numbers that line up, and check the font supports them. Mechanism: proportional digits make columns of figures jitter, and a font without tabular digits ignores the setting.
- Choose the layout from the window width (`MediaQuery.sizeOf`) for the app shell and from `LayoutBuilder` inside reusable widgets, not from device type. Mechanism: a small window on a large screen is misread as a phone, and a widget that reads the whole window cannot be reused in a narrow slot.
- Send every displayed number through one formatter, never a raw `toString()`. Mechanism: locale, currency and rounding rules differ, and scattered formatting drifts.
- Give empty, loading and error states a design, and check the screen at 360 and 900 px wide, in light and dark, and at 200 percent text. Mechanism: most of the states a screen is in are not the happy path.
- Do not use fixed heights on text containers. Mechanism: large text settings overflow them.
- Do not turn off Material 3 in new code. Mechanism: it is the framework default from Flutter 3.16 onward (verify against the Flutter version in use), so opting out leaves a one-off look to maintain.
- Act only on what the user asked. Before answering or changing anything, open the relevant files and check what is already done; report only what you checked, never guess, and do not redo finished work. Reason: guesses and repeated work waste the user's credit.

## Gate

| Situation | Action |
|---|---|
| The project already has a theme layer and tokens | Extend it; do not add a second system |
| A design token fits a `ColorScheme` role or `TextTheme` style | Use that, not a custom token |
| A value has no Material home (spacing, semantic colours, radii) | Put it in a `ThemeExtension` |
| One widget needs a one-off look | Use a local `Theme` with `copyWith`, or a widget parameter |
| The design system and Material defaults disagree | Theme the component first; build a custom widget last |
| Building a dashboard or data-heavy screen | Follow [dashboard-ui.md](references/dashboard-ui.md): stat strip, cards, adaptive layout, then its checklist |
| Someone points at a web component catalogue ("we need tables, tabs, a command palette like this") | Use [web-blocks-to-flutter.md](references/web-blocks-to-flutter.md): map each block to a Flutter widget, check what the project already has, and never copy the kit's code |

Reason: every extra token system is one more place for values to drift from the design.

## Steps

1. **Detect.** Search feature code for literal colours (`Color(0x`, `Colors.`), raw `TextStyle(fontSize`, and fixed radii and paddings repeated across files. Read the existing `ThemeData`.
2. **Map tokens.** For each design token choose one home: a `ColorScheme` role, a `TextTheme` style, a component theme, or a `ThemeExtension` field. Convert once, in the theme layer.
3. **Build the theme.** `ColorScheme.fromSeed` (or an explicit scheme from the design) plus `textTheme`, supplied as both `theme` and `darkTheme`. Add a `ThemeExtension` with `copyWith` and `lerp` for custom tokens, and read it with `Theme.of(context).extension<T>()`.
4. **Replace literals.** Swap widget literals for `Theme.of(context)` lookups. Put shared themed widgets in one core directory.
5. **Verify accessibility.** Check contrast of 4.5:1, tap targets of at least 48 by 48, labels for custom controls, and large text without overflow. Run the `flutter_test` guideline matchers in widget tests, and test with a screen reader.

6. **Dashboards.** Put the page heading first, then a stat strip, then cards. Decide the layout from the window width, give empty, loading and error states a design, and run the checklist in [dashboard-ui.md](references/dashboard-ui.md).

Full detail: [theming-and-accessibility.md](references/theming-and-accessibility.md).

## References

- [theming-and-accessibility.md](references/theming-and-accessibility.md): theme resolution order, tokens, external design systems, accessibility checklist, review list.
- [dashboard-ui.md](references/dashboard-ui.md): principles, a starting scale, page shapes, components, dashboard layout rules, accessibility, dark mode and a screen checklist.
- [dashboard-starter.dart](references/dashboard-starter.dart): a small starter with a tokens class, card, change chip, stat tile and stat strip.
- [web-blocks-to-flutter.md](references/web-blocks-to-flutter.md): web UI block types mapped to Flutter widgets, with what to build first.
- [ui_blocks.dart](references/ui_blocks.dart): a tested starter with an adaptive shell, page heading, empty state, breadcrumbs, command palette and paged table.

## Next

For where shared widgets and ViewModels live see [flutter-architecture](../flutter-architecture/SKILL.md). For Dart naming see [dart-code-standards](../dart-code-standards/SKILL.md). Back to [flutter-developer](../flutter-developer/SKILL.md).
