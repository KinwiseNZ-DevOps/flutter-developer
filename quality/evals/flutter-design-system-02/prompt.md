---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The app has a theme file lib/theme/tokens.dart with AppColors.primary (#1A73E8) and a ThemeData built from it. The button in question is in lib/features/cart/checkout_button.dart.

Request: Just put Color(0xFF1A73E8) directly on this button, it is quicker.
