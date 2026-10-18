# Web UI blocks and their Flutter equivalents

Use a web component catalogue as a checklist of UI needs, not as code. Commercial component kits are licensed, so do not copy their markup or code into your repository. Take the category names ("tables", "empty states", "command palettes"), decide which ones your app needs, and build each with Flutter's own widgets and your theme.

Trust levels: rows marked (official) were checked against the Flutter API page named in Sources. "(general)" means standard Flutter practice that was not re-checked in this pass. "(inference)" is the author's reading. Checked 2026-10-18.

## How to adapt a block

1. **Abstract.** Pull out the data the block shares between layouts (for example, one list of destinations for both a bar and a rail).
2. **Measure.** Use `MediaQuery.sizeOf(context)` for whole-window decisions and `LayoutBuilder` inside reusable widgets (official).
3. **Branch.** Switch at the breakpoint, 600 logical pixels from the Material window size classes (official).
4. **Theme it.** Take colours, text styles and spacing from the theme and tokens, never literals. See [theming-and-accessibility.md](theming-and-accessibility.md).
5. **Check it.** Semantics label, 48 px tap targets, dark mode, 200 percent text, and widths of 360 and 900 px.

## Application shells and layout

| Web block | Flutter implementation | Notes |
|---|---|---|
| Stacked, sidebar and multi-column shells | `Scaffold` with `NavigationBar` on narrow windows and `NavigationRail` on wide ones | The rail suits wide viewports and a small number of destinations, typically three to five (official). `NavigationDrawer` is the menu alternative for more destinations (official: listed in the Material catalogue). Starter: `AdaptiveShell` |
| Page, card and section headings | A `PageHeading` widget: title, one line of context, actions | Actions sit on the right when wide and wrap below when narrow. Mark the title as a semantic header. Starter: `PageHeading` |
| Containers, cards, list containers, media objects, dividers | `Card`, `ListTile`, `Divider` (official: all in the Material catalogue) | One radius family and hairline borders. See [dashboard-ui.md](dashboard-ui.md) |
| Grid lists | `GridView.builder` with a max-cross-axis-extent delegate (general) | Lets the column count follow the width without a breakpoint |

## Data display and lists

| Web block | Flutter implementation | Notes |
|---|---|---|
| Stats | A stat strip of stat tiles with a change chip | See the starter in [dashboard-starter.dart](dashboard-starter.dart) |
| Description lists | `ListTile` rows in a `Card`, or two-column rows | Keep the label small and quiet, the value normal weight |
| Stacked lists and feeds | `ListView.builder` or `ListView.separated` (general) | Build lazily. For feeds, load the next page near the end (see the Django integration skill) |
| Tables | Small data: `DataTable`. Large data: `PaginatedDataTable` with a `DataTableSource`, or `TableView` from the `two_dimensional_scrollables` package | `DataTable` is not lazy: it measures content twice, so large data sets are expensive, and a `SingleChildScrollView` does not fix that. `PaginatedDataTable` shows one page at a time and has `rowsPerPage`, `availableRowsPerPage` and `onPageChanged` (official). On a phone, consider a list of cards instead of a wide table (inference). Starter: `PagedTableCard` |
| Calendars | `CalendarDatePicker` for an inline calendar, `showDatePicker` for a dialog | `CalendarDatePicker` takes `firstDate`, `lastDate`, `onDateChanged` and a `selectableDayPredicate` (official) |

## Forms and inputs

| Web block | Flutter implementation | Notes |
|---|---|---|
| Form layouts, input groups, textareas | `Form` with `TextFormField`, `InputDecoration` prefix and suffix, `maxLines` (general) | Label above or in the field, hint below, one primary action |
| Select menus and comboboxes | `DropdownMenu` | Can filter as you type (`enableFilter`) and search (`enableSearch`), supports keyboard traversal and skips disabled items (official). `Autocomplete` is the plain-text alternative (general) |
| Radio groups and button groups | `Radio` for a longer list, `SegmentedButton` for two to five short options | `SegmentedButton` is in the Material catalogue (official). Check the `Radio` API for your Flutter version, because radio grouping has changed over time (inference) |
| Checkboxes and toggles | `Checkbox`, `Switch`, `SwitchListTile` (general) | Put the label in the tappable row so the target is large |
| Action panels | A `Card` with a title, a sentence and one button | |

## Feedback and navigation

| Web block | Flutter implementation | Notes |
|---|---|---|
| Alerts (persistent) | `MaterialBanner` through `ScaffoldMessenger` | Persistent and non-modal, content and actions are required, and a user action is needed to dismiss it (official). Use an inline tinted block for a message that belongs to one section |
| Notifications and toasts (transient) | `SnackBar` through `ScaffoldMessenger` | Short-lived. Do not put a required decision in one |
| Empty states | An `EmptyState`: icon, one sentence, one action | Starter: `EmptyState`. Give loading and error states a design too |
| Tabs | `TabBar` with `TabBarView` | On narrow windows a dropdown can replace a long tab row (inference) |
| Breadcrumbs | No built-in widget. Compose text buttons and chevrons | Last item is the current page and not tappable. Wrapper needs `explicitChildNodes` so a screen reader announces each item (checked by test). Starter: `Breadcrumbs` |
| Pagination | The footer of `PaginatedDataTable`, or load more on scroll | Follow the server's `next` link (see the Django integration skill) |
| Progress bars and steps | `LinearProgressIndicator` for progress, `Stepper` for a multi-step form | `Stepper` does not advance by itself: the parent updates `currentStep` from `onStepContinue`, `onStepCancel` and `onStepTapped` (official) |
| Command palettes | `SearchAnchor` with a `suggestionsBuilder`, opened with `SearchController.openView` | A button opens it, and a `CallbackShortcuts` binding for Ctrl+K or Cmd+K opens it from the keyboard. Starter: `CommandPalette` |

## Overlays and elements

| Web block | Flutter implementation | Notes |
|---|---|---|
| Modal dialogs | `showDialog` with `AlertDialog` on wide windows | A bottom sheet on phones (official: both are in the Material catalogue) |
| Drawers | `showModalBottomSheet` for a bottom drawer, `NavigationDrawer` for a side menu | |
| Avatars | `CircleAvatar` (general) | Give it a semantic label when it carries meaning |
| Badges | `Badge` and `Badge.count` on an icon | `Badge.count` has a `maxCount` (default 999), and the label is meant to be one to four characters (official). A status pill is a `Chip` or a small custom widget |
| Dropdowns | `MenuAnchor` or `PopupMenuButton` (general; `Menu` is in the Material catalogue) | |
| Buttons | `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton` | One primary action per area |
| Collapsible sections and FAQs | `ExpansionTile` | Give each tile a `PageStorageKey` inside a scrolling list so it keeps its state (official) |

## Page examples

- Home: a dashboard. Page heading, stat strip, cards.
- Detail: a heading with actions, a description list, related lists.
- Settings: grouped `ListTile` and `SwitchListTile` rows in cards, one section per card.

## What to build first

For a business app, in this order, after checking what the project already has:

1. Adaptive shell (only if the app targets tablets, desktop or web).
2. Page heading.
3. Empty, loading and error states.
4. Table card with paging.
5. Search or command palette.
6. Breadcrumbs, for deep navigation only.
7. Stepper, for long forms.

Marketing and ecommerce blocks (heroes, pricing, product pages, checkout) are rarely needed in a business app. Build them only when a screen calls for them.

## Starter code

[ui_blocks.dart](ui_blocks.dart) holds `AdaptiveShell`, `PageHeading`, `EmptyState`, `Breadcrumbs`, `CommandPalette` and `PagedTableCard`, written from the Flutter APIs above. Checked on 2026-10-18 with Flutter 3.47.2 in a throwaway project: `flutter analyze` reported no issues, and 10 widget tests passed. They covered the 599 and 600 px switch between bar and rail, the heading at 360 and 900 px with 200 percent text, the empty-state action, the breadcrumb semantics, the command palette opened from the button and with Ctrl+K, and paging through a table. One test caught a real bug: the breadcrumb wrapper merged its children into one semantics node until `explicitChildNodes` was set.

They are starting points. Take colours and spacing from your theme, move the small literals into tokens, and run your own analysis and tests.

## Sources

Official Flutter API and docs pages, fetched 2026-10-18:

- Material widgets catalogue: https://docs.flutter.dev/ui/widgets/material
- Adaptive and responsive design: https://docs.flutter.dev/ui/adaptive-responsive/general
- `DataTable`: https://api.flutter.dev/flutter/material/DataTable-class.html
- `PaginatedDataTable`: https://api.flutter.dev/flutter/material/PaginatedDataTable-class.html
- `SearchAnchor`: https://api.flutter.dev/flutter/material/SearchAnchor-class.html
- `NavigationRail`: https://api.flutter.dev/flutter/material/NavigationRail-class.html
- `DropdownMenu`: https://api.flutter.dev/flutter/material/DropdownMenu-class.html
- `MaterialBanner`: https://api.flutter.dev/flutter/material/MaterialBanner-class.html
- `Stepper`: https://api.flutter.dev/flutter/material/Stepper-class.html
- `CalendarDatePicker`: https://api.flutter.dev/flutter/material/CalendarDatePicker-class.html
- `Badge`: https://api.flutter.dev/flutter/material/Badge-class.html
- `ExpansionTile`: https://api.flutter.dev/flutter/material/ExpansionTile-class.html

Not re-checked in this pass: `Autocomplete`, `GridView` delegates, `SwitchListTile`, `CircleAvatar`, `PopupMenuButton`, and the current `Radio` grouping API.
