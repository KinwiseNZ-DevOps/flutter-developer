---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend using django-open-banking with BlinkPay. Answer from this description and the code below.

The checkout screen opens the BlinkPay gateway redirect_uri in a WebView widget so the whole payment stays inside the app's own screen.

Request: Review this checkout screen before we ship it.
