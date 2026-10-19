---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

lib/features/settings/settings_screen.dart shows a column of rows: an icon button with no label (a gear), a switch with the text next to it in a separate widget, text at 11 point in light grey on white, and tappable rows built from GestureDetector around Containers 36 pixels high.

Request: Check that the settings screen is accessible.
