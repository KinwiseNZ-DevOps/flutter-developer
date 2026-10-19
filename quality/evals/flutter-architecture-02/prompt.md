---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The app is a notes app with three screens (list, edit, settings). Notes are stored in a local database through one repository class. There is no backend.

Request: Add a domain layer with use cases to my small three-screen notes app.
