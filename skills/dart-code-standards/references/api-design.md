# Dart API design rules

Condensed from the Design section of Effective Dart (https://dart.dev/effective-dart/design). Trust level: official. "(inference)" marks reasons that are the author's reading rather than stated by the guide.

## Names

- Use terms consistently across the API; one concept, one word.
- Avoid abbreviations. Put the most descriptive noun last (`pageCount`, not `countPage`).
- Aim for code that reads like a sentence at the call site.
- Non-boolean properties and variables: noun phrase. Boolean ones: non-imperative verb phrase using the positive form (`isEnabled`, not `isDisabled`). A named boolean parameter may omit the verb (`growable: true`).
- Methods whose purpose is a side effect: imperative verb phrase (`add`, `close`). Methods whose purpose is a returned value: noun phrase or non-imperative verb phrase.
- Avoid starting method names with `get`; use a getter or a better verb. Reason: a getter already means "fetch".
- Use `to...()` when a method copies state into a new object (`toList`) and `as...()` when it returns another view backed by the original (`asMap`). Reason: callers can tell at once whether mutation affects the source.
- Do not describe parameters in the method name (`addTodo`, not `addTodoItemToList`).

## Libraries

- Make declarations private by default; expose only what callers need. Reason: every public member is a promise you must keep.
- Declaring several closely related classes in one library is fine; Dart privacy is per library, not per class.

## Classes and mixins

- Avoid one-method abstract classes where a function type will do, and avoid classes that only hold static members; use top-level functions and constants.
- Use class modifiers (`final`, `base`, `interface`, `sealed`) to state whether your class may be extended or implemented. Reason: unstated intent becomes an accidental public contract.
- Avoid extending or implementing a class not designed for it.
- Prefer a pure `mixin` or pure `class` over a `mixin class`.

## Constructors and members

- Make constructors `const` when the class allows it.
- Prefer `final` fields and top-level variables.
- Use getters for operations that conceptually read a property and setters for ones that conceptually change one. Never define a setter without a getter.
- Avoid runtime type tests that fake overloading; use differently named methods.
- Avoid public `late final` fields without initialisers; a caller can trigger an error or set them at the wrong time.
- Avoid returning nullable `Future`, `Stream` or collection types; return an empty collection or a future of nullable instead. Reason: callers then do not need two kinds of emptiness check.
- Avoid returning `this` just to chain calls; use cascades (`..`).

## Types

- Annotate variables without initialisers, fields and top-level variables whose type is not obvious, and all function return and parameter types.
- Do not annotate initialised locals, inferred closure parameters, or initialising formals. Reason: redundant annotations add noise and drift when the initialiser changes.
- Write type arguments on generic calls that cannot be inferred; omit them when they can.
- Avoid incomplete generic types (a bare `List`); write `List<dynamic>` if dynamic is meant.
- Use `dynamic` only to opt out of static checking on purpose.
- Use `Future<void>` for async members that return nothing. Avoid `FutureOr<T>` as a return type.
- Prefer inline function types over typedefs, and function-type syntax for parameters. Do not use the legacy typedef syntax.

## Parameters

- Avoid positional boolean parameters; `connect(true)` says nothing at the call site. Use named parameters.
- Avoid optional positional parameters when a caller may want to skip an earlier one.
- Avoid mandatory parameters that accept a special "no argument" value.
- Ranges take an inclusive start and an exclusive end. Reason: matches the core library and makes lengths `end - start`.

## Equality

- Override `hashCode` whenever you override `==`.
- Make `==` obey the mathematical rules (reflexive, symmetric, transitive, consistent).
- Avoid custom equality on mutable classes. Reason: mutating an object that sits in a hash set or map key breaks lookups.
- Do not make the parameter of `==` nullable; the language handles null before the call.
