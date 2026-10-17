---
name: dart-code-standards
description: >
  Applies the official Effective Dart rules to written Dart code: identifier
  naming, import ordering, formatting, doc comments, null safety usage,
  collections, async, error handling, types, parameters, equality and public API
  design. Use when writing, reviewing or cleaning up Dart code, naming things, or
  designing a library API. Do not use for app structure or state management
  (flutter-architecture) or for performance work.
---

# Dart Code Standards

Stance: the Effective Dart guidelines are the baseline. Frozen: casing rules, `dart format` output, and rules marked DO and DON'T. Flexible: PREFER, AVOID and CONSIDER rules, which bend when you understand and can state the reason.

## Gate

| Situation | Action |
|---|---|
| The project's `analysis_options.yaml` or existing code already settles the question | Follow the project, do not reopen it |
| New or changed code that breaks a DO or DON'T rule | Fix it in the lines you touched |
| Old code that breaks a rule but is outside the task | Leave it alone, mention it once |
| A PREFER or AVOID rule conflicts with a good reason | Break it, and keep the reason short in the review note |

Reason: restyling untouched code buries the real change in the diff and invites merge conflicts.

## Steps

1. **Detect.** Run `dart analyze` and `dart format --output=none --set-exit-if-changed .` to find mechanical issues. Then read the changed code for what tools miss: names, comments, boolean parameters, nullable returns, bare `catch`.
2. **Fix.** Start with what the formatter can do. Then apply the matching rule file for each remaining issue:
   - Names, ordering, comments, null, strings, collections, async, errors: [style-docs-usage.md](references/style-docs-usage.md)
   - Public API shape, types, parameters, equality, class design: [api-design.md](references/api-design.md)
3. **Verify.** Re-run analyse and format, then the tests. Confirm no behaviour changed; most fixes here are meant to be behaviour-neutral.

## Hard rules

- Run `dart format` and accept its output. Mechanism: formatting arguments are subjective, so automation ends them and keeps diffs small.
- Use `///` for documentation and start with a one-sentence summary paragraph. Mechanism: tools show only the first paragraph in hovers and listings.
- Do not write a `catch` without an `on` clause, and do not catch `Error` types. Mechanism: a bare catch swallows programming errors together with the expected failure.
- Use `rethrow`, not `throw e`. Mechanism: `rethrow` keeps the original stack trace.
- Use `isEmpty` and `isNotEmpty`, not `length == 0`. Mechanism: `length` can be O(n) on some iterables.
- Avoid `Iterable.forEach` with a function literal; use a `for` loop. Mechanism: loops allow `break`, `continue` and `await`.
- Avoid positional boolean parameters; use named ones. Mechanism: `connect(true)` says nothing at the call site.
- Override `hashCode` whenever you override `==`, and avoid custom equality on mutable classes. Mechanism: mutating an object stored as a map key or set member breaks lookups.
- Do not import another package's `src` directory. Mechanism: it is private and can change without notice.
- Do not restyle code outside the task. Mechanism: unrelated edits hide the real change from reviewers.

## References

- [style-docs-usage.md](references/style-docs-usage.md): identifiers, ordering, formatting, documentation, usage rules.
- [api-design.md](references/api-design.md): names, classes, members, types, parameters, equality.

## Next

For app structure see [flutter-architecture](../flutter-architecture/SKILL.md). To understand a codebase before changing it see [flutter-task-research](../flutter-task-research/SKILL.md). Back to [flutter-developer](../flutter-developer/SKILL.md).
