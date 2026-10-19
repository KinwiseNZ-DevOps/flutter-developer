---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The lib folder has about 250 files. Known signs: 14 TODO comments, a 900-line cart_screen.dart, three different ways of calling the API, tests for only two of the feature folders, and a mix of setState and Riverpod state.

Request: Audit the lib folder for technical debt and give me a remediation plan.
