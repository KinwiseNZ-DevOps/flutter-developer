---
name: flutter-django-integration
description: >
  Guides the Flutter side of integrating with a Django REST Framework backend:
  service and repository layering, OpenAPI contract and client generation, JSON
  model mapping, JWT authentication and token storage, error and validation
  mapping, pagination, environments and web CORS. Use when a Flutter app calls a
  Django API, when adding or changing an endpoint client, auth flow, error
  handling or list loading, or when the app and API disagree. Do not use for
  writing the Django server code or for UI theming.
---

# Flutter Django Integration

Stance: the backend's real behaviour is the contract, and the client must follow it. Frozen: the service and repository layering, the Result return type, one place for token handling, one place for error parsing. Flexible: hand-written or generated client, and the exact retry policy.

## Hard rules

- Never parse money as `double`. Mechanism: DRF sends decimals as strings by default because binary floating point cannot hold most decimal fractions exactly, so a `double` parse silently loses precision.
- Never call the API from `build`. Mechanism: `build` runs on every rebuild, so each rebuild fires another request.
- Throw or return an error on a non-success status; never return null. Mechanism: null leaves a loading state showing forever.
- Never hard-code tokens or base URLs as literals. Mechanism: literals ship inside the app and cannot differ per environment.
- Send auth only over HTTPS. Mechanism: bearer and token credentials are readable in transit otherwise.
- Check the backend's actual auth scheme before writing the header. Mechanism: Simple JWT uses `Bearer`, DRF's built-in token auth uses `Token`.
- Do not retry a 400, 401-after-refresh, or 403, and treat any failed refresh (400 or 401) as sign-out. Mechanism: the same request cannot succeed without a changed input or credential.
- Retry only reads, only on network, timeout and 5xx, with exponential backoff, jitter and a total budget, and never inside the 401 recovery path. Mechanism: fixed-delay nested retries multiply attempts and stack load on a struggling server.
- Serialise concurrent token refreshes, and persist the new refresh token before retrying when rotation is on. Mechanism: with rotation and blacklisting, a second refresh with a spent token fails and signs the user out.
- Do not assume an `Idempotency-Key` header is honoured. Mechanism: many backends get replay safety from database constraints instead, so a key the server ignores leaves duplicate writes possible.
- Partition any cache or write queue by user and tenant, and clear it on sign-out. Mechanism: a shared store can show one user's data to another.
- Use an isolate for JSON work only after a profile shows the main thread blocked. Mechanism: isolates add copying cost and complexity, and small pages rarely need them.
- Do not enable broad CORS on the server to make a web build work. Mechanism: allowing all origins lets any site call the API; list the exact web origin instead. Native apps are not subject to browser CORS.
- Mark inference as inference. The reference separates official facts from advice.
- Never open a bank or payment-provider page in an embedded `WebView`. Mechanism: banks block framed pages, and a `WebView` the app controls defeats the point of the customer authenticating directly with their bank rather than through the app; use the platform's in-app browser (Custom Tabs / `SFSafariViewController`) instead.
- Never treat a payment return link as proof of an outcome; re-fetch status from the backend on both the link and on app resume. Mechanism: the link can be forged (any app can claim the same custom scheme), can carry a stale or unrelated `cid`, and frequently never arrives at all if the customer backgrounds or kills the app mid-flow.

## Gate

| Situation | Action |
|---|---|
| The API is mid-design and the contract is unclear | Ask for the schema or a real sample response before writing models |
| The backend publishes an OpenAPI schema | Prefer generating or checking models against it |
| One endpoint, one screen, throwaway prototype | A small hand-written service is enough |
| A claim about backend behaviour is not in the schema, the code or a sample | Mark it "unverified, check with the backend" |
| Offline writes are wanted | Queue only writes the backend makes safe to replay; do not assume an idempotency header is honoured |
| A performance question comes up (large payloads, caches, aggregation) | Measure first, then hand off to the performance companion below |
| The change needs backend edits | State what the server must change; do not guess its code from the client |
| The app presents a bank payment or bank data consent (BlinkPay or similar) | See [open-banking-blinkpay.md](references/open-banking-blinkpay.md); the app never calls the provider directly |

Reason: a client built on guessed server behaviour works until the first real response differs, and then fails in production.

## Steps

1. **Read the contract.** Get the schema (drf-spectacular produces OpenAPI), the serializer, or a recorded real response for every endpoint touched. Work through the "confirm from the schema" checklist in the guide (auth scheme, failure codes, error envelope, pagination cap, decimals, versioning, idempotency) and mark each item verified or unverified.
2. **Layer it.** A stateless service wraps the HTTP calls and returns API models. A repository owns caching, retry and mapping to domain models, and returns `Result`. ViewModels never see raw HTTP. See [flutter-architecture](../flutter-architecture/SKILL.md).
3. **Map fields carefully.** Money arrives as a string, so use a decimal type. Dates arrive as ISO 8601. Keys are snake_case. Nested models need explicit serialisation. Details: [integration-guide.md](references/integration-guide.md).
4. **Handle auth in one place.** Attach the bearer header in one interceptor or wrapper, keep the refresh token in secure storage, attempt a single refresh on 401, and treat 403 as "not allowed".
5. **Parse errors in one place.** Turn 400 field errors, `non_field_errors`, 401, 403, 429 and network failures into one sealed error type that the ViewModel can show.
6. **Page lists properly.** Follow the `next` link, keep pagination state in the repository, and block overlapping loads.
7. **Verify.** Unit test service parsing against saved real responses, repositories against fake services, and error mapping for each documented shape. Run `dart analyze` and `flutter test`.

## Companion plugins (use when installed)

Use these alongside this skill; if they are not installed, follow this skill and say the hand-off was skipped.

| Concern | Companion skill |
|---|---|
| Profiling, isolates, list scrolling, cache need, client versus server aggregation | flutter-performance-specialist (flutter-perf-audit first, then flutter-perf-isolates, flutter-perf-lists-and-scrolling, flutter-perf-derived-state) |
| Server error handler, pagination helper, schema, response shape | django-apis-serializers (via django-api-architect) |
| Token endpoints, refresh, blacklist, login throttling | django-auth |
| Constraint-backed writes and replay safety | django-services-selectors |
| CORS origins and settings | django-project-structure |
| BlinkPay payment and account-data API, server side | django-open-banking (via django-api-architect) |

This skill decides what the client needs; the Django skills own how the server provides it. Never edit server code from the Flutter side; state the required backend change instead.

## References

- [integration-guide.md](references/integration-guide.md): layering, contract, field mapping, auth, errors, pagination, environments, offline writes, tests, with sources.
- [open-banking-blinkpay.md](references/open-banking-blinkpay.md): presenting a BlinkPay bank payment or data consent from the app, the in-app browser, the return link, and reconciling the outcome.

## Next

For layering and the Result and Command patterns see [flutter-architecture](../flutter-architecture/SKILL.md). For Dart rules see [dart-code-standards](../dart-code-standards/SKILL.md). To investigate an unfamiliar API first see [flutter-task-research](../flutter-task-research/SKILL.md). Back to [flutter-developer](../flutter-developer/SKILL.md).
