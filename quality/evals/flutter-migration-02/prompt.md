---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The Flutter breaking-changes index lists "Migrate to standalone material_ui and cupertino_ui packages" under "not yet released to stable".

Request: Get ahead of it and migrate shop-app to the new material_ui and cupertino_ui packages now.
