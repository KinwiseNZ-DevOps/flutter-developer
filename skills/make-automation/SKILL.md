---
name: make-automation
description: >
  Use when adding or fixing a Makefile, a make target, or a task runner for a
  Flutter or Dart project. Writes and reviews GNU Make Makefiles that wrap
  repeatable project commands such as code generation, analysis, tests and
  builds, covering structure, variables, phony targets, recipes, includes and
  portability. Do not use for Dart code rules (dart-code-standards) or for CI
  workflow files.
---

# Make Automation

Stance: a Makefile is a small, readable index of project commands. Frozen: tabs in recipes, `.PHONY` for non-file targets, a clear default goal. Flexible: how much to parameterise.

## Hard rules

- Start every recipe line with a tab. Mechanism: spaces cause a "missing separator" error.
- Declare non-file targets with `.PHONY`. Mechanism: a file named `clean` with no prerequisites is always considered up to date, so the recipe would never run.
- Remember each recipe line runs in its own shell. Mechanism: `cd` on one line does not carry to the next, so join dependent commands with `&&` and a backslash, or list `.ONESHELL` to send a whole recipe to one shell.
- Use `-` to ignore failures only where failure is expected, such as `rm -f` in `clean`. Mechanism: ignoring errors elsewhere hides real breakage.
- Add `.DELETE_ON_ERROR`. Mechanism: make then deletes a target that changed when its recipe fails, so a half-written file cannot look up to date on the next run.
- Use `$(wildcard ...)`, not `$(shell ls ...)`. Mechanism: `wildcard` is built in and spawns no process.
- Move long shell logic into a script file. Mechanism: Makefile quoting and expansion make complex recipes fragile.
- Do not use recursive make unless nothing else works. Mechanism: each sub-make sees only its own directory, so dependencies across directories can be missed (the GNU Make manual covers recursive use in its own section).

## Gate

| Situation | Action |
|---|---|
| The project already has a task runner (scripts, melos, CI-only commands) | Use it; add a Makefile only if asked |
| Several commands are repeated by hand or in docs | Wrap them in targets |
| A command is used once | Leave it as a command |
| Portability beyond GNU Make is needed | Keep to POSIX shell and document GNU-only features |

Reason: a Makefile that duplicates another runner creates two sources of truth.

## Steps

1. **Detect.** Find the commands the team repeats (for example `dart run build_runner build`, `flutter analyze`, `flutter test`, `dart format`) and any existing Makefile conventions.
2. **Write.** Order the file: header comment with usage, variables, default goal, rules, phony declarations. Use `:=` by default, `?=` for overridable defaults, `$(VAR)` references, and automatic variables in generic rules. Name targets for their action: `analyze`, `test`, `format`, `generate`, `clean`.
3. **Verify.** Run `make -n target` to see commands without running them, then run the target. Confirm `clean` is idempotent.

Rule detail and examples: [gnu-make-rules.md](references/gnu-make-rules.md).

## References

- [gnu-make-rules.md](references/gnu-make-rules.md): variables, rules, recipes, includes, conditionals, anti-patterns.

## Next

For Dart rules see [dart-code-standards](../dart-code-standards/SKILL.md). Back to [flutter-developer](../flutter-developer/SKILL.md).
