---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The Dio client has an interceptor that refreshes the access token on a 401 and replays the request. Some endpoints are POSTs that create payments or orders and the server does not de-duplicate them.

Request: Retry every failed request three times with a one second delay, including after a 401 refresh.
