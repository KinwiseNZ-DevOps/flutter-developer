---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

lib/features/auth contains login_screen.dart, auth_repository.dart, token_store.dart and an auth interceptor in lib/core/network. You cannot open them in this session; only this description is available.

Request: Research how authentication is handled in this app before we change the login flow.
