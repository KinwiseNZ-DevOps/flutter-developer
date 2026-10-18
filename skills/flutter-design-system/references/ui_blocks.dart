import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Small Flutter-native equivalents of common web application blocks, built from
/// Material widgets. Starting points: read the theme, add your own tokens, and
/// run `dart analyze` and a widget test before relying on them.

/// The 600 logical pixel breakpoint from Material window size classes, as used in
/// Flutter's adaptive design guidance. Keep one value in your tokens.
const double kWideBreakpoint = 600;

/// A navigation destination shared by the bar and the rail (the "Abstract" step
/// of Abstract, Measure, Branch).
class ShellDestination {
  const ShellDestination({required this.label, required this.icon, IconData? selectedIcon})
      : selectedIcon = selectedIcon ?? icon;

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// App shell: a bottom [NavigationBar] on narrow windows and a [NavigationRail]
/// on wide ones. Measures the whole window with [MediaQuery.sizeOf].
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
    this.breakpoint = kWideBreakpoint,
  });

  final List<ShellDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= breakpoint;
    if (!wide) {
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          destinations: [
            for (final d in destinations)
              NavigationDestination(icon: Icon(d.icon), selectedIcon: Icon(d.selectedIcon), label: d.label),
          ],
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected,
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(icon: Icon(d.icon), selectedIcon: Icon(d.selectedIcon), label: Text(d.label)),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: SafeArea(child: child)),
        ],
      ),
    );
  }
}

/// Page heading: a title, one line of context, and actions. Actions sit on the
/// right on wide areas and wrap below on narrow ones.
class PageHeading extends StatelessWidget {
  const PageHeading({super.key, required this.title, this.context_, this.actions = const []});

  final String title;
  final String? context_;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(title, style: text.headlineSmall)),
        if (context_ != null) ...[
          const SizedBox(height: 4),
          Text(context_!, style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ],
    );
    return LayoutBuilder(builder: (context, box) {
      final wide = box.maxWidth >= kWideBreakpoint;
      if (actions.isEmpty) return titles;
      final buttons = Wrap(spacing: 12, runSpacing: 8, children: actions);
      return wide
          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(child: titles), buttons])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titles, const SizedBox(height: 12), buttons]);
    });
  }
}

/// Empty state: an icon, one sentence and one action.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message, this.actionLabel, this.onAction});

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: scheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class BreadcrumbItem {
  const BreadcrumbItem(this.label, {this.onTap});

  final String label;
  final VoidCallback? onTap;
}

/// Breadcrumbs: Flutter has no built-in widget, so this composes buttons and
/// chevrons. The last item is the current page and is not tappable.
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({super.key, required this.items});

  final List<BreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final last = i == items.length - 1;
      if (i > 0) {
        children.add(ExcludeSemantics(child: Icon(Icons.chevron_right, size: 16, color: scheme.onSurfaceVariant)));
      }
      children.add(
        last
            ? Semantics(
                label: 'Current page: ${items[i].label}',
                excludeSemantics: true,
                child: Text(items[i].label, style: Theme.of(context).textTheme.labelLarge),
              )
            : TextButton(onPressed: items[i].onTap, child: Text(items[i].label)),
      );
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Breadcrumb',
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: children),
    );
  }
}

class Command {
  const Command(this.label, this.onRun);

  final String label;
  final VoidCallback onRun;
}

/// Command palette: a search view over a list of commands, opened by a button or
/// by Ctrl+K or Cmd+K. Built on [SearchAnchor].
class CommandPalette extends StatefulWidget {
  const CommandPalette({super.key, required this.commands, required this.child});

  final List<Command> commands;
  final Widget child;

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final SearchController _controller = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): _controller.openView,
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _controller.openView,
      },
      child: Focus(
        autofocus: true,
        child: Column(
          children: [
            SearchAnchor(
              searchController: _controller,
              builder: (context, controller) => IconButton(
                tooltip: 'Search commands',
                icon: const Icon(Icons.search),
                onPressed: controller.openView,
              ),
              suggestionsBuilder: (context, controller) {
                final query = controller.text.toLowerCase();
                return [
                  for (final command in widget.commands)
                    if (command.label.toLowerCase().contains(query))
                      ListTile(
                        title: Text(command.label),
                        onTap: () {
                          controller.closeView(command.label);
                          command.onRun();
                        },
                      ),
                ];
              },
            ),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

class _ListSource extends DataTableSource {
  _ListSource(this.rows);

  final List<List<String>> rows;

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) return null;
    return DataRow.byIndex(index: index, cells: [for (final cell in rows[index]) DataCell(Text(cell))]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}

/// Table in a card with paging. [PaginatedDataTable] reads rows lazily, one page
/// at a time. [DataTable] measures every row, so avoid it for large data.
class PagedTableCard extends StatelessWidget {
  const PagedTableCard({super.key, required this.title, required this.columns, required this.rows, this.rowsPerPage = 10});

  final String title;
  final List<String> columns;
  final List<List<String>> rows;
  final int rowsPerPage;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: Text(title),
      rowsPerPage: rowsPerPage,
      showCheckboxColumn: false,
      columns: [for (final c in columns) DataColumn(label: Text(c))],
      source: _ListSource(rows),
    );
  }
}
