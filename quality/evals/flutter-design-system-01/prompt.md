---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The designer's token file (tokens.json) has colours (brand.primary #1A73E8, surface, error), spacing (4, 8, 16, 24) and radii (4, 8, 16). The app currently hard-codes colours and numbers in widgets and has a ThemeData with the default seed colour.

Request: Our designer sent a token file with brand colours, spacing and radii. Wire it into the Flutter app.
