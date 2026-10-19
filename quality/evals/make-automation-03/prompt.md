---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

Makefile excerpt:
```make
clean:
	flutter clean

cd build
rm -rf cache
```
There is also a directory called clean in the repository root.

Request: My clean target does nothing and there is a folder called clean in the project. Also cd build on one line does not affect the next line.
