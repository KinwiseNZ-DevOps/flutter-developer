---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The workspace is a melos monorepo with 5 packages. melos.yaml already defines scripts for format, analyze, test and codegen, and CI calls those scripts.

Request: Add a Makefile even though we already run everything through melos scripts.
