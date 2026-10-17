# Dart style, documentation and usage rules

Condensed from Effective Dart (https://dart.dev/effective-dart). Trust level: official. Reasons are given for each group; where a reason is the author's reading rather than stated by the guide, it is marked (inference).

## How to read the rules

- DO and DON'T: follow almost always.
- PREFER and AVOID: follow unless there is a clear, understood reason not to.
- CONSIDER: judgement call.
- Two themes sit behind every rule: be consistent (two pieces of code should look different only when they differ in meaning) and be brief (pick the most concise clear form, but economical, not dense).

## Style: identifiers

| Rule | Reason |
|---|---|
| Types and extensions use `UpperCamelCase` | One casing per kind of name lets a reader tell a type from a value at a glance |
| Packages, directories, source files and import prefixes use `lowercase_with_underscores` | File systems differ in case sensitivity, so lower case avoids clashes (inference) |
| Everything else, including constants, uses `lowerCamelCase` | Constants are not special in Dart; one rule for values is simpler |
| Treat acronyms longer than two letters as words (`HttpClient`, not `HTTPClient`) | Keeps word boundaries readable when acronyms sit next to each other |
| Use `_` for unused callback parameters | Signals the value is deliberately ignored |
| No leading underscore on non-private names, no prefix letters, no explicit `library` names | The underscore means private in Dart; Hungarian-style prefixes add noise the type system already covers |

## Style: ordering and formatting

- Order imports: `dart:` first, then `package:`, then relative. Put exports in their own section after imports. Sort each section alphabetically. Reason: a predictable order makes diffs small and missing imports easy to spot.
- Run `dart format` and do not argue with it. Reason: formatting arguments are subjective and unresolvable; automation ends them.
- Keep lines to 80 characters where practical, and always use braces on flow control. Reason: braces prevent the dangling-else class of bug (inference).

## Documentation

- Use `///` for documentation and `//` for ordinary comments. Never use block comments for documentation.
- Write comments as sentences: capital letter, full stop.
- Start every doc comment with a one-sentence summary in its own paragraph. Reason: tools show only the first paragraph in hovers and listings.
- Document public APIs. Documenting private members is optional but useful.
- Avoid repeating what the name and type already say. Reason: redundant comments rot and add reading cost.
- Wording conventions:
  - Functions whose main purpose is a side effect start with a third-person verb ("Deletes the file").
  - Non-boolean properties start with a noun phrase.
  - Boolean properties start with "Whether".
  - Value-returning functions start with a noun phrase or non-imperative verb phrase.
- Document a property once, on the getter, not on both getter and setter.
- Refer to in-scope identifiers with square brackets (`[name]`) so tools can link them.
- Explain parameters, return values and exceptions in prose, not in tag lists.
- Put doc comments before metadata annotations.
- Use Markdown sparingly, backtick fences for code, no HTML.

## Usage: libraries

- Do not import another package's `src` directory; it is private and may change without notice.
- Do not use import paths that reach out of or into `lib` from the wrong side. Prefer relative imports within a package. Reason: mixing relative and package imports for the same file can load it as two different libraries (inference).

## Usage: null

- Do not initialise variables to `null`; they already default to it.
- Do not compare to `true` or `false` in equality tests; test the boolean directly.
- Avoid `late` when you need to check whether the variable has been set; the check itself can throw.
- Prefer type promotion and null-check patterns to use nullable values. Reason: the compiler then proves safety instead of you asserting it.

## Usage: strings and collections

- Prefer interpolation to concatenation, and omit braces when interpolating a plain identifier.
- Use adjacent string literals to join literals.
- Use collection literals, not constructors, where possible.
- Use `isEmpty` and `isNotEmpty`, never `length == 0`. Reason: `length` can be O(n) on some iterables.
- Avoid `Iterable.forEach` with a function literal; use a `for` loop. Reason: loops allow `break`, `continue`, `await` and read as plain control flow.
- Use `whereType<T>()` to filter by type. Avoid `cast()` when a nearby operation, such as a typed literal or `List.of`, does the job. Do not use `List.from` unless you intend to change the element type.

## Usage: functions, variables, members, constructors

- Use a function declaration, not a variable holding a lambda, to bind a function to a name. Use a tear-off instead of a lambda that only forwards its arguments.
- Choose one rule for `var` versus `final` on locals and apply it consistently.
- Avoid storing what you can calculate. Reason: stored copies go stale and must be kept in sync.
- Do not wrap a field in a trivial getter and setter. Use a `final` field for a read-only property. Use `=>` for simple members.
- Use `this.` only to avoid shadowing or to redirect to a named constructor.
- Use initialising formals (`this.x`) and `;` for empty constructor bodies. Do not use `new`. Do not write `const` where it is already implied. Do not use `late` where an initialiser list will do.

## Usage: error handling

- Avoid `catch` without an `on` clause, and never silently discard what such a catch receives. Reason: a bare catch swallows programming errors along with the expected failure.
- Throw `Error` subtypes only for programmer mistakes that should never be caught, and do not catch `Error` types. Throw `Exception` subtypes for runtime conditions callers may handle.
- Use `rethrow` to rethrow, not `throw e`, so the original stack trace survives.

## Usage: asynchrony

- Prefer `async`/`await` to raw `Future` chains. Reason: error handling and control flow read like synchronous code.
- Do not mark a function `async` when it has no useful effect, such as an `await`-free body returning a plain value.
- Avoid using `Completer` directly; it is rarely needed and easy to leave incomplete.
- Prefer higher-order methods when transforming a stream.
- When disambiguating a `FutureOr<T>` whose `T` could be `Object`, test for `Future<T>`, not for `T`.

Official source: https://dart.dev/effective-dart/style, /documentation, /usage
