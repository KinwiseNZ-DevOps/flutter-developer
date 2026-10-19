---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The repository has about 400 Dart files across lib, test and a generated folder. It currently builds and the tests pass. Formatting is inconsistent in places.

Request: Reformat and rename everything in the repo to match Effective Dart.
