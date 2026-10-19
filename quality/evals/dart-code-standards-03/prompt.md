---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

analysis_options.yaml enables always_use_package_imports. The code inside lib mixes package imports and relative imports.

Request: My project's lint config says to use package imports everywhere, but Effective Dart prefers relative imports inside a package. Which should I follow?
