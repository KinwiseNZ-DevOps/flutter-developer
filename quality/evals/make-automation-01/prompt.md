---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The repository is a single Flutter package (not a monorepo) with a pubspec.yaml, build_runner in dev_dependencies and generated files under lib/gen. Developers use macOS, Linux and Windows.

Request: Create a Makefile with targets to format, analyze, test and run build_runner for our Flutter package.
