---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

lib/features/settings/settings_screen.dart is about 300 lines. The button label reads 'Sigh out' instead of 'Sign out'. The file also has long build methods, some unused imports and inconsistent naming.

Request: Fix the typo in the label on the settings button, then also tidy up that whole file while you are there.
