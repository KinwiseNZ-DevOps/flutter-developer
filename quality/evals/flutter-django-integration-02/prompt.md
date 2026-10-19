---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The backend uses djangorestframework-simplejwt: POST /api/auth/token/ returns access and refresh tokens, POST /api/auth/token/refresh/ returns a new access token. The Flutter app has a Dio client and a login screen with email and password fields that currently does nothing.

Request: Add login to the Flutter app against our Simple JWT backend and keep the user signed in.
