---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The Django API returns validation errors as {"email": ["Enter a valid email."], "password": ["Too short."]} with status 400. The signup form has an email and a password field, each a TextFormField with its own controller.

Request: Show field errors from the API next to the form inputs.
