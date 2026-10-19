---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The app currently has one layout for all screens. Phones and tablets both run it. The team has not decided on a breakpoint.

Request: Show a phone layout if the device is a phone and a tablet layout if it is a tablet.
