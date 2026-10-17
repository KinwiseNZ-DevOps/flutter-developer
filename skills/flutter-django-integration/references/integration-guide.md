# Integrating a Flutter client with a Django REST Framework API

Facts here come from official or maintainer documentation fetched on 2026-10-18. Each section says which source it rests on. "(inference)" marks the author's reading, which should be checked against the project's own backend before being relied on.

Sources:

- Flutter: https://docs.flutter.dev/cookbook/networking/fetch-data, /authenticated-requests, /background-parsing, https://docs.flutter.dev/data-and-backend/serialization/json
- Flutter architecture: https://docs.flutter.dev/app-architecture/case-study/data-layer, /design-patterns/result
- Django REST Framework (DRF): https://www.django-rest-framework.org/api-guide/exceptions/, /pagination/, /authentication/, /throttling/, /fields/
- Simple JWT: https://django-rest-framework-simplejwt.readthedocs.io (getting started, settings)
- drf-spectacular: https://drf-spectacular.readthedocs.io
- django-cors-headers: https://github.com/adamchainz/django-cors-headers
- flutter_secure_storage: https://pub.dev/packages/flutter_secure_storage
- openapi_generator: https://pub.dev/packages/openapi_generator

## 1. Shape of the client

The Flutter data layer has two parts: services and repositories (Flutter data-layer case study, official).

- A **service** is a stateless class that only wraps an external API. Typically one per data source. It returns raw API models.
- A **repository** is the source of truth for one kind of app data and the only place that data is changed. It owns caching, retries, and the transformation from API models to domain models. The service is a private dependency, so the UI cannot bypass the repository.
- Use an abstract repository class so a remote, local or fake implementation can be swapped per environment.
- Return a `Result` (Ok or Error) from services and repositories instead of throwing, so callers are forced to handle failure (Flutter Result pattern, official; described as a recommendation, not a requirement).

Do not call the API inside `build`. Start the call once, for example in `initState`, or better in a ViewModel, and keep the future or state. Reason: `build` runs on every rebuild (Flutter fetch-data recipe, official).

For plain HTTP, the Flutter recipe uses the `http` package and advises against using `dart:io` or `dart:html` directly because they are platform dependent. Throw on any non-success status; do not return null, because a null result leaves a `FutureBuilder` showing a spinner forever.

## 2. Contract: keep both sides in step

Drift between the Django API and the Dart models is the most common integration failure (inference). Two official routes reduce it:

1. **Generate a schema from Django.** drf-spectacular produces an OpenAPI 3 schema from DRF serializers and views (`manage.py spectacular --file schema.yml`, `--validate` to check it). It lists producing a schema that works well with client generators as one of its goals.
2. **Generate or hand-write the Dart client.**
   - `openapi_generator` generates a client from an OpenAPI spec during `build_runner`. Its documented generator is `dio`. It needs Java 8 or later on the PATH, bug reports about generated code belong upstream, and in CI `build_runner` may need to run twice with a `pub get` between.
   - `json_serializable` generates `fromJson`/`toJson` from annotated models. Flutter's JSON guide recommends hand-written methods for small projects and code generation for medium and large ones; generation catches field-name typos at compile time, hand-written code does not.

Whichever is chosen, test the mapping: hand-written `fromJson`/`toJson` methods need unit tests (Flutter JSON guide, official). A recorded sample response from the real API is a good fixture (inference).

## 3. Field mapping facts that cause bugs

From the DRF fields documentation (official):

- `DecimalField` serialises to a **string** by default (`COERCE_DECIMAL_TO_STRING` is `True`). Parse it with `Decimal` (the `decimal` package) or keep it as a string. Never parse money as `double`. Reason: binary floating point cannot represent most decimal fractions exactly (general numeric fact).
- `DateTimeField` serialises to ISO 8601, for example `2013-01-29T12:34:56.000000Z`. With `USE_TZ` off, values are naive and carry no zone. Parse with `DateTime.parse` and treat the zone deliberately.
- `UUIDField` serialises as the canonical hyphenated string.
- `read_only` fields appear in responses but are ignored on input. `write_only` fields are accepted on input but never returned. A client must not expect to read back a `write_only` field.

From the Flutter JSON guide (official):

- Django's default JSON keys are snake_case while Dart fields are camelCase. Map with `@JsonKey(name: '...')` per field, or `@JsonSerializable(fieldRename: FieldRename.snake)` for all fields.
- Nested objects need `explicitToJson: true` on the outer class, otherwise `toJson` yields `Instance of 'Address'`.
- `@JsonKey(required: true)` throws on a missing key; `defaultValue` covers missing or null keys.
- Generate with `dart run build_runner build --delete-conflicting-outputs`.

Large payloads: decoding on the main isolate can cause jank when parsing exceeds about 16 ms. Flutter's recipe moves parsing to a background isolate with `compute()`. Only simple messages can cross isolates, not objects such as `http.Response` (Flutter background-parsing recipe, official). Move work to an isolate only after a profile shows it blocking; small pages rarely need it (inference). Isolates are for CPU work, never for ordinary network waits.

## 4. Authentication

Official facts:

- Simple JWT: `POST` credentials to the token endpoint, receive `access` and `refresh`. Send `Authorization: Bearer <access>` (the default `AUTH_HEADER_TYPES` is `Bearer`). `POST` the refresh token to the refresh endpoint to get a new access token.
- Default lifetimes: access token 5 minutes, refresh token 1 day.
- `ROTATE_REFRESH_TOKENS` (default off) returns a new refresh token with each refresh. `BLACKLIST_AFTER_ROTATION` (default off) blacklists the submitted refresh token, and works only with rotation on and the blacklist app installed.
- DRF returns **401** with a `WWW-Authenticate` header when the first authentication class supplies a challenge, and **403** when it does not. A request that authenticated but lacks permission always gets 403. Simple JWT's `Bearer` setting is what the first prefix in `AUTH_HEADER_TYPES` becomes in that header.
- DRF's built-in token authentication uses the keyword `Token`, not `Bearer`, unless subclassed. Check which scheme the backend uses before writing the header.
- Token authentication should be served over HTTPS only.
- Flutter's authenticated-requests recipe sets the header with `headers: {HttpHeaders.authorizationHeader: ...}` and gives no storage guidance. Do not hard-code tokens as string literals in client code.
- `flutter_secure_storage` stores values in the iOS and macOS Keychain, with Android using Keystore-backed ciphers. Android Auto Backup can cause key-unwrap errors, so disable backup (`android:allowBackup="false"`) or exclude the package's preferences. The web implementation is experimental and needs HTTPS and HSTS. Call `WidgetsFlutterBinding.ensureInitialized()` before use.

Inference (verify against the backend):

- Keep the access token in memory and the refresh token in secure storage, so a short-lived credential is the one most often exposed.
- On a 401, attempt one refresh and retry the original request once; if the refresh fails, clear tokens and send the user to sign in. Serialise concurrent refreshes so parallel requests do not each spend the refresh token, which matters when rotation and blacklisting are on.
- Treat 403 as "signed in but not allowed", not "refresh and retry". This holds only when the first authentication class supplies a challenge header; if a non-challenging class comes first, unauthenticated requests also return 403. Confirm from the schema or a real response.
- Treat any failed refresh (the status may be 400 for an invalid or blacklisted token, or 401) as sign-out. Do not retry it.
- With rotation on, the refresh response carries a new refresh token. Persist it before retrying the original request, and keep refreshes serialised. Logout should call the backend's token blacklist endpoint if one exists, then clear local tokens.

## 5. Error contract

DRF official behaviour:

- Most errors are JSON with a `detail` key, for example `{"detail": "Method 'DELETE' not allowed."}`.
- Validation errors (HTTP 400) use field names as keys, each with a list of messages. Errors not tied to a field appear under `non_field_errors` (or the `NON_FIELD_ERRORS_KEY` setting) in stock DRF. A project's exception handler may reshape this, so treat `non_field_errors` as "if present" until the schema or a saved response shows it (reviewed against a service-layer DRF standard, 2026-10-18).
- 401 not authenticated, 403 permission denied, 429 throttled. A custom exception handler can reshape all of these, but only for raised exceptions.
- Throttling: a `Retry-After` header is sent when the throttle implements `wait()` (the built-in rate throttles do, inference from DRF source, not stated on the fetched page). DRF itself warns throttling is not a brute-force or denial-of-service defence.

Mapping to the Flutter side (inference):

- Decode the body defensively; a gateway or proxy error may return HTML, not JSON.
- Model failures as a sealed type (network, timeout, unauthorised, forbidden, validation with field messages, throttled with retry delay, server, unknown) and carry it in `Result.error`. The ViewModel then shows field errors beside inputs and `non_field_errors` as a form-level message.
- Retry only idempotent requests (reads), and only for network errors, timeouts and 5xx. Use exponential backoff with jitter, a maximum attempt count and an overall time budget. Do not run the retry loop inside the 401 recovery path, or attempts multiply. For a 429, wait for `Retry-After` when present and fall back to a default delay when it is absent. Never retry a 400.
- If the backend wraps errors in its own envelope, the envelope is the contract. Read it from the backend and write one parser.

## 6. Lists and pagination

DRF official behaviour: pagination is off unless both `DEFAULT_PAGINATION_CLASS` and `PAGE_SIZE` are set.

| Style | Query params | Response | Use when |
|---|---|---|---|
| Page number | `page`, optional `page_size` | `count`, `next`, `previous`, `results` | Jumping to a page is needed |
| Limit and offset | `limit`, `offset` | `count`, `next`, `previous`, `results` | Client chooses a window |
| Cursor | `cursor` | opaque `next` and `previous` links | Large or changing data sets and a fixed ordering; no random page access |

Offset and page-number styles run a count and slow down at high offsets on growing tables (the DRF cursor documentation gives offset slowdown as a reason to use cursors), so prefer cursor pagination for large, growing lists when the backend offers it. Servers often cap the page size; never request more than the cap, and do not assume every list endpoint is paginated.

Client rules (inference): follow the `next` link as given instead of building page numbers by hand, and keep the pagination state in the repository. For infinite scroll, load the next page when the user approaches the end, and prevent two loads at once. Use a cursor-style list when rows are inserted while the user scrolls, to avoid duplicates and gaps.

## 7. Environments, web and CORS

- Inject the base URL and environment through configuration, not literals. `--dart-define` compile-time values are one way (Flutter pattern; the data-layer guide itself only describes swapping implementations by abstract class).
- Native mobile and desktop apps are not governed by browser CORS (inference; django-cors-headers documents CORS only for browser requests). A Flutter **web** build is a browser app, so the Django side needs CORS settings: list the exact web origin in `CORS_ALLOWED_ORIGINS`, keep `CORS_ALLOW_ALL_ORIGINS` off because it lets any site call the API, and place the CORS middleware as high as possible in `MIDDLEWARE`.
- If cookies or sessions are used from web, `CORS_ALLOW_CREDENTIALS`, `SESSION_COOKIE_SAMESITE` and `CSRF_TRUSTED_ORIGINS` all come into play. Bearer tokens in a header avoid most of this.
- Android needs the `INTERNET` permission in the manifest, and macOS needs the network client entitlement (Flutter fetch-data recipe, official).

## 8. Testing the integration

- Unit test services against recorded or faked responses, repositories against fake services, ViewModels against fake repositories (Flutter testing recommendations, official: fakes over deep mocks).
- Keep a small set of contract tests: given a saved real response, the model parses; given each documented error shape, the error parser yields the right type (inference).
- Regenerate the schema and client in CI and fail on a diff, so a backend change that breaks the client is seen in review (inference).

## 9. Confirm from the schema checklist

Before writing the client, mark each item verified (seen in the schema, code or a saved real response) or unverified:

- Authentication scheme and header keyword (`Bearer` or `Token`).
- Status codes for unauthenticated, forbidden, invalid refresh and throttled requests.
- Error envelope for validation, detail and throttle responses, and whether `non_field_errors` appears.
- Pagination style, default and maximum page size, ordering stability, and which lists are paginated.
- Whether decimal fields are strings, and whether datetimes are timezone aware.
- Whether the API version is carried in the URL or a header, or not at all.
- Whether any idempotency mechanism exists (see section 10).

Keep one saved sample response per error shape as a test fixture: field map, `detail`, throttled with and without `Retry-After`, and an HTML body from a proxy.

## 10. Offline writes and caching

Field-tested patterns, team-written, generalised from a production client and reviewed against performance and server-side guidance.

- **Queue only writes the server can safely replay.** A client may send an `Idempotency-Key` header with each queued write, but the key helps only if the backend documents that it honours it. Many service-layer backends get safety from database constraints and update-or-create logic instead, with no request key. Never assume a key is honoured; confirm with the backend owner, and treat it as a backend change if it is missing.
- **Give each queued write a stable id, a dependency link and a status** (pending, conflict, failed) with a retry count. Flush in dependency order, and do not send a dependent write when what it depends on failed.
- **Partition queues and caches by signed-in user and tenant** (for example household or organisation), and clear them on sign-out. Reason: a shared cache can show one user's data to another.
- **Network first, stale on transient failure.** Read from the network and write the result to the cache. Fall back to the cached copy only for network, timeout and server errors; rethrow auth and validation errors. Return the cached value with a staleness flag so the UI can say it is old.
- **Cache only where measurement shows repeated cost.** Every cache needs a key, a lifetime and an invalidation rule, or it serves stale data.
- **Flush on a real connectivity change or a user trigger, not on a tight idle timer.** Polling a reachability probe while idle wakes the radio and costs battery. Back off when offline.
- **Batch disk writes.** Rewriting a whole queue file on every change is fine for small queues and becomes costly as they grow.

## 11. Single client, single refresh, single parser

Patterns seen in a working production client, generalised:

- One API client class owns base URL, version header, timeouts and the auth interceptor. A per-request flag lets login and refresh calls skip the auth header.
- A shared in-flight future makes concurrent 401 responses wait on one refresh, then each retries once. If the refresh does not succeed, the original error is rethrown.
- Reads retry on transient failures; writes are never retried automatically.
- Errors become one `Failure` type with a category (network, timeout, server, validation, auth, client, unknown), a status code, a user-safe message and the raw payload. Keep the payload so field errors can be mapped later; do not flatten a validation response to a single message.
- Gaps worth closing in such a design: separate 403 from 401, add a throttled category with the retry delay, and add backoff with jitter.
- A pagination parser that accepts both a bare list and an envelope is tolerant, but still confirm the real envelope from the backend, because stock DRF limit/offset returns `count`, `next`, `previous` and `results`.
- A configuration switch between a mock and a real data source is a simple way to supply fakes in development and tests.

## 12. Hand-offs to companion skills

- Profiling, isolates, caching need, list scrolling and client versus backend aggregation: the Flutter performance companion (flutter-performance-specialist and its flutter-perf skills), if installed.
- Server-side contract (error handler, pagination helper, auth endpoints, schema, CORS, settings): the Django API architect companion (django-apis-serializers, django-auth, django-services-selectors, django-project-structure), if installed.
- Large totals and grouping over many rows belong on the server; ask the backend for aggregate endpoints, with decimal-safe money, rather than downloading every row (inference, aligned with the performance companion's derived-state guidance).
