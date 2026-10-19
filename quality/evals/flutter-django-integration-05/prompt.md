---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The offline queue stores failed writes (POST and PATCH) in a local database and replays them when the connection returns. The Django API does not look at any Idempotency-Key header today.

Request: Make the offline queue send an Idempotency-Key on every write so duplicates are impossible.
