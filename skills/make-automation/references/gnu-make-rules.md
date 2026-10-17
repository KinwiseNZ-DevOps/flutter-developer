# GNU Make conventions for build and automation files

Condensed from the GNU Make manual (https://www.gnu.org/software/make/manual/). Trust level: official. In a Flutter repo a Makefile typically wraps repeatable commands such as code generation, analysis, tests and builds. "(inference)" marks the author's reading.

## Principles

- Optimise for readability and maintenance over brevity. Keep the default goal (the first target) as the most common operation, because bare `make` runs it.
- Name targets for their action (`clean`, `test`, `install`). Comment anything non-obvious.
- Name the file `Makefile` (most visible) or `makefile`. Use `GNUmakefile` only if you rely on GNU-only features that other makes would misread.

## Structure

Order the file: header comment, variables, default goal, rules, phony declarations. Variables defined before the rules that use them are easier to find.

## Variables

| Form | Meaning | Use when |
|---|---|---|
| `:=` | Simple expansion, evaluated once at definition | Default choice; faster and predictable |
| `=` | Recursive expansion, evaluated at each use | You deliberately want late binding |
| `?=` | Set only if not already set | Defaults the caller can override from the environment or command line |
| `+=` | Append | Adding flags to an existing list |

- Reference with `$(NAME)`, not `$NAME`, except for single-character names.
- Use automatic variables to keep rules generic: `$@` target, `$<` first prerequisite, `$^` all prerequisites, `$?` newer prerequisites, `$*` pattern stem.

## Rules and prerequisites

- List every real dependency, or rebuilds will be wrong.
- Use pattern rules (`%.o: %.c`) for generic transformations. Prefer overriding implicit-rule variables (`CC`, `CFLAGS`) to rewriting built-in rules.
- Use order-only prerequisites (after `|`) for things that must exist but must not trigger a rebuild, such as output directories. Order-only items are left out of `$^`, so reference them explicitly if needed.
- Avoid circular dependencies.

## Recipes

- Every recipe line starts with a tab, not spaces, unless `.RECIPEPREFIX` is changed. This is the most common beginner error.
- `@` suppresses echo. `-` ignores a command's failure; use sparingly because it hides real errors.
- Join commands that must run in one shell with `&&` or `;` plus backslash continuation. Each recipe line otherwise runs in its own shell, so `cd` on one line does not carry to the next.
- Backslash-newline continues a line; in non-recipe contexts it becomes one space. Avoid trailing whitespace after the backslash.
- Keep recipes short. Move long shell logic into a separate script file.

## Phony targets and special targets

- Declare every non-file target with `.PHONY` (`all`, `clean`, `test`, `install`). Reason: if a file named `clean` ever exists, an undeclared target silently does nothing.
- `.DELETE_ON_ERROR` removes a half-written target when its recipe fails, so a later run cannot treat a corrupt file as up to date.
- `.SECONDARY` and `.PRECIOUS` keep intermediate files; `.INTERMEDIATE` marks them as disposable; `.SILENT` silences all recipes (use sparingly).

## Includes and conditionals

- `include` shares definitions across makefiles; `-include` (or `sinclude`) tolerates a missing file, which suits optional local overrides and generated dependency files.
- Place `include` after variable definitions that affect the included file.
- Use `ifeq`, `ifneq`, `ifdef` and `ifndef` at makefile level for platform or configuration differences. Do not put them inside recipes; use shell conditionals there.

## Automatic header dependencies

Generate dependency files with compiler flags (`-MMD -MP`) and pull them in with `-include $(deps)` instead of maintaining them by hand. Reason: hand-kept lists drift and cause stale builds.

## Errors and debugging

- Check required tools and variables at the top with `$(error ...)` so failure is immediate and clear.
- `make -n` shows commands without running them; `make -p` prints the rule and variable database; `make -B` forces a full rebuild.

## Clean targets

Always provide `clean`, declared phony. Use `-rm -f` so missing files do not fail it. Consider `distclean` for everything generated, including configuration.

## Portability and performance

- Prefer POSIX shell constructs in recipes, and document GNU-only features you rely on.
- Avoid `$(shell ...)` where a built-in function works, because each call starts a process. Use `$(wildcard ...)`, not `$(shell ls ...)`, for file lists.
- Parallel builds (`make -j`) are safe only if targets do not write the same files.

## Anti-patterns

- Spaces instead of tabs in recipes.
- Hard-coded file lists that a wildcard or function could generate.
- Missing `.PHONY` declarations.
- Circular dependencies.
- Recursive make (`$(MAKE) -C dir`) unless there is no better option (it hides cross-directory dependencies; inference).
- Long inline shell scripts in recipes.
