import 'package:flutter/material.dart';

/// Design tokens in one place. Screens read these, never raw numbers.
class DashTokens {
  const DashTokens._();

  static const double cardRadius = 8;
  static const double gap = 16;
  static const double cardPad = 20;
  static const double footerPad = 16;
  static const double wideBreakpoint = 720;
}

/// Card with an optional header and footer, separated by hairlines.
class DashCard extends StatelessWidget {
  const DashCard({super.key, this.title, this.action, required this.child, this.footer});

  final String? title;
  final Widget? action;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final divider = Divider(height: 1, thickness: 1, color: scheme.outlineVariant);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(DashTokens.cardRadius),
        // Dark mode: depth comes from a faint ring, not a shadow.
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DashTokens.cardRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DashTokens.cardPad, vertical: 14),
                child: Row(children: [
                  Expanded(child: Text(title!, style: Theme.of(context).textTheme.titleSmall)),
                  if (action != null) action!,
                ]),
              ),
              divider,
            ],
            Padding(padding: const EdgeInsets.all(DashTokens.cardPad), child: child),
            if (footer != null) ...[
              divider,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DashTokens.cardPad, vertical: DashTokens.footerPad),
                child: footer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A change figure: arrow, signed percentage and a spoken label.
/// Colour is a secondary cue only, so it survives colour-vision differences.
class DeltaChip extends StatelessWidget {
  const DeltaChip({super.key, required this.percent, this.upIsGood = true});

  final double percent;
  final bool upIsGood;

  @override
  Widget build(BuildContext context) {
    final up = percent >= 0;
    final good = up == upIsGood;
    final scheme = Theme.of(context).colorScheme;
    final colour = good ? scheme.primary : scheme.error;
    final text = '${up ? '+' : ''}${percent.toStringAsFixed(1)}%';
    return Semantics(
      label: '${up ? 'Increased' : 'Decreased'} by ${percent.abs().toStringAsFixed(1)} percent',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colour.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(up ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: colour),
            const SizedBox(width: 2),
            Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colour)),
          ]),
        ),
      ),
    );
  }
}

/// Label small and quiet, number large, optional delta.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.delta, this.upIsGood = true});

  final String label;
  final String value;
  final double? delta;
  final bool upIsGood;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(DashTokens.cardPad),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            if (delta != null) DeltaChip(percent: delta!, upIsGood: upIsGood),
          ],
        ),
      ]),
    );
  }
}

/// Related stats in one container with hairline dividers; stacks on a phone.
class StatStrip extends StatelessWidget {
  const StatStrip({super.key, required this.stats});

  final List<StatTile> stats;

  @override
  Widget build(BuildContext context) {
    final line = Theme.of(context).colorScheme.outlineVariant;
    return DashCard(
      child: LayoutBuilder(builder: (context, box) {
        final wide = box.maxWidth >= DashTokens.wideBreakpoint;
        final children = <Widget>[];
        for (var i = 0; i < stats.length; i++) {
          if (i > 0) {
            children.add(wide
                ? VerticalDivider(width: 1, thickness: 1, color: line)
                : Divider(height: 1, thickness: 1, color: line));
          }
          children.add(wide ? Expanded(child: stats[i]) : stats[i]);
        }
        return wide
            ? IntrinsicHeight(child: Row(children: children))
            : Column(mainAxisSize: MainAxisSize.min, children: children);
      }),
    );
  }
}
