---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The orders list screen janks when the API returns a 4 MB payload of 5,000 orders. Elsewhere the app parses small payloads (under 5 KB) for settings and profile.

Request: The list screen janks when the API returns a big payload. Move all JSON parsing to isolates everywhere.
