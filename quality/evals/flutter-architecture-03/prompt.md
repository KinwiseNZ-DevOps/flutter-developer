---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

docs/architecture.md was written two years ago and says state management uses provider. pubspec.yaml lists flutter_riverpod and no provider package, and every screen uses Riverpod providers.

Request: The architecture guide says use provider but this project uses Riverpod everywhere. Should I switch?
