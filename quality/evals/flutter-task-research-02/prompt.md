---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

/flutter-developer:flutter-task-research Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The app uses Dio and has no caching today. The orders and products endpoints are read often and change rarely. Some data must be fresh after a purchase.

Request: Research the best way to cache API responses and then go ahead and implement it.
