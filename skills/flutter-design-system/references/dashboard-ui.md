# Dashboard UI in Flutter

Contents: Six principles, a starting scale, page shapes, components, layout rules for dashboards, accessibility, dark mode, checklist for a new dashboard screen, starter widgets, worked example, sources

Trust levels: the starting scale and the "ethic" below are team-written practice, not an official Flutter standard. Items marked (official) were checked against the page named in Sources. "(inference)" marks the author's reading. Checked 2026-10-18.

## 1. Six principles

1. **Quiet chrome, loud numbers.** Labels are small and grey. The figure is large and semibold.
2. **Depth from hairlines, not heavy shadows.** Use 1 px borders and dividers.
3. **One radius family.** A small radius for cards and inputs, a full pill for badges and avatars.
4. **Tight, regular spacing.** Everything sits on a 4 px grid.
5. **Colour is a second cue.** Pair it with an arrow, a sign or a word.
6. **One layout, two shapes.** Stack on narrow windows, split on wide ones.

## 2. A starting scale

Suggested values to adapt, not rules. Keep them in the theme layer (a `ThemeExtension` or a small tokens class) so screens never use raw numbers. See the theming and accessibility reference.

| Thing | Starting value | Where it lives |
|---|---|---|
| Body text | 14 | theme `bodyMedium` |
| Dense secondary text | 12 | theme `labelSmall` |
| Big stat | 30, weight 600, letter spacing about -0.5 | theme `headlineMedium` adjusted with `copyWith` |
| Weights | 600 and 500 for emphasis; avoid very bold headings | text theme |
| Radius | cards 8, inputs 6, badges and avatars full pill | tokens |
| Horizontal padding | 12, 16, 24 | tokens |
| Vertical padding | 8, 16, 20 | tokens |
| Gaps | 12, 16, 24 | tokens |
| Shadow | none, or a 1 px ring. In dark mode use the ring only | tokens |

## 3. Page shapes

- Phone: one column, with a bottom or top bar for navigation.
- Wide: a sidebar or rail shell, content in a column with a maximum width, cards in a grid.
- Page heading: a title, one line of context, and actions on the right. Actions wrap below the title on phones.
- Breakpoint: Flutter's adaptive guidance uses 600 logical pixels from the Material window size classes (bottom navigation below 600, navigation rail at 600 or wider) (official). The team guide that this reference started from used 720 for "wide"; choose one number, put it in the tokens, and prefer 600 unless the design says otherwise.
- Measure with `MediaQuery.sizeOf(context)` for the whole window (for example, choosing the app's navigation), and with `LayoutBuilder` inside reusable widgets so they respond to the space they are given (official). Do not use device type to decide, because a small window on a large screen is misread as a phone (official). The method is Abstract, Measure, Branch (official).

## 4. Components

| Need | Pattern |
|---|---|
| Stat strip with change | A row of stat tiles. Each shows a label, the figure and a change chip |
| Card | Header padding smaller than body, footer smaller again |
| Lists | `ListView` with dividers, about 20 px row padding, truncate the secondary line |
| Badges | Pill or 6 px radius, tinted background at about 10 percent, text in the strong tone |
| Alerts | Tinted block, icon on the left, title in medium weight, body in the softer tone |
| Empty state | An icon, one sentence, one action. A dashed border suits "add your first" |
| Tabs | Underline tabs on wide windows, a dropdown on narrow ones |
| Progress | A thick rule with step labels |
| Forms | Label above the field, hint below, one primary action |
| Dialogs and toasts | A bottom sheet on phones, a centred dialog on wide windows |

## 5. Layout rules for dashboards

From Quarto's dashboard layout guidance (official, https://quarto.org/docs/dashboards/layout.html):

- Build a dashboard from rows and columns of cards, and size them relatively (for example 70 percent, 60 percent), not in fixed pixels.
- Decide for each area whether it fills the space (charts) or flows to its natural height (text).
- Put secondary content in tabs instead of making the page longer.

Inputs (official, https://quarto.org/docs/dashboards/inputs.html): controls that affect the whole dashboard belong in a sidebar or toolbar; a control that affects one card belongs in that card.

Stat tiles (value boxes) sit together in one row (official: Quarto's example places them in a row). Keeping them at the top and never mixed into chart rows is the team guide's rule (team-written).

Theme with a handful of tokens (primary, surface, outline, error) and do not hand-colour widgets. Flutter mapping: `ColorScheme` roles plus a `ThemeExtension`.

## 6. Accessibility

- Colour is never the only signal (WCAG 2.2 success criterion 1.4.1, Use of Color, level A) (official). Use an arrow, a sign or a word as well. Check green, gold and orange pairs for red-green colour vision difference, the team guide's practical test.
- Give each change chip a spoken label such as "Decreased by 1.4 percent", using `Semantics`.
- Use tabular figures for numbers that line up in a column: `TextStyle(fontFeatures: [FontFeature.tabularFigures()])`. It only changes fonts that include tabular digits, so check the chosen font (official).
- Wrap big numbers in `FittedBox(fit: BoxFit.scaleDown)` so very large text settings do not overflow (practice; Flutter's accessibility page asks that the UI stay usable at very large text scales).
- Tap targets are at least 48 by 48 logical pixels (official, Flutter accessibility page).

## 7. Dark mode

- Surfaces step up in lightness; they do not gain shadow.
- Borders use a low-alpha white.
- Tinted fills drop to about 10 percent alpha.
- Never reuse the light-mode shade of a status colour; choose a dark-mode shade and check its contrast.

These are team-written. Material 3's tonal approach to elevation is consistent with the first point (inference; not confirmed in this pass because the Material elevation page returned no text).

## 8. Checklist for a new dashboard screen

1. Page heading, then a stat strip, then cards.
2. Every number goes through one formatter (locale, currency, rounding), never a raw `toString()`.
3. Render at 360 and 900 px wide, in light and dark.
4. Run at 200 percent text.
5. Empty, loading and error states each have a design.

## 9. Starter widgets

[dashboard-starter.dart](dashboard-starter.dart) holds `DashTokens`, `DashCard`, `DeltaChip`, `StatTile` and `StatStrip`. It was analyser-clean and rendered at 360 and 900 px wide in light and dark in the KinWise app. Treat it as a starting point: move the token values into your own theme layer and replace the `StatStrip` breakpoint (720) with the one your project uses.

## Worked example

[dashboard-starter.dart](dashboard-starter.dart) is a small starter that follows this reference: `DashTokens` (the numbers in one place), `DashCard` (header and footer separated by hairlines), `DeltaChip` (arrow, signed percentage and a spoken label), `StatTile` (quiet label, loud figure, tabular figures, `FittedBox` for large text) and `StatStrip` (stacks on narrow widths, splits with vertical dividers on wide ones).

Notes on using it:

- Its `wideBreakpoint` of 720 is applied to the strip's own width through `LayoutBuilder`, a component-level decision. The app shell should still decide from the window width, using 600 unless the design says otherwise.
- It was written as a starting point. It uses `Color.withValues(alpha: ...)`, which needs a recent Flutter version, and a few small literals (for example icon size 14 and one padding of 14) that you may want to move into your tokens.
- It reads colours from `ColorScheme` (`outlineVariant`, `surfaceContainerLow`, `primary`, `error`). Check that the status colours keep enough contrast in both light and dark mode.
- Checked on 2026-10-18 in a throwaway project with a recent Flutter: it renders without errors at 360 and 900 px wide, in light and dark, at normal and 200 percent text, the change chip exposes its spoken label, and the strip stacks on narrow widths and splits on wide ones. `flutter analyze` reported one style hint, `use_null_aware_elements` on `if (action != null) action!`. It is safe to leave, or change to `?action` on Dart 3.8 or later. Re-run `dart analyze` and a widget test in your own project, because lints and Flutter versions differ.

## Sources

Official, fetched 2026-10-18:

- Flutter adaptive and responsive design: https://docs.flutter.dev/ui/adaptive-responsive/general (Abstract, Measure, Branch; `MediaQuery.sizeOf`; `LayoutBuilder`; 600 breakpoint).
- Quarto dashboards, layout, inputs and data display: https://quarto.org/docs/dashboards/layout.html, /inputs.html, /data-display.html.
- WCAG 2.2 Use of Color: https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html
- `FontFeature.tabularFigures`: https://api.flutter.dev/flutter/dart-ui/FontFeature/FontFeature.tabularFigures.html
- Flutter accessibility: https://docs.flutter.dev/ui/accessibility

Not confirmed: Material 3's page on window size classes could not be fetched (404), so the 600 figure rests on Flutter's page; the Material elevation page returned no text.
