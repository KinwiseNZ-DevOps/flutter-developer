---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The Django invoices endpoint GET /api/invoices/ returns 200 invoices per page and takes about 4 seconds. You have no access to the backend code or a running server in this session.

Request: Our Django API is slow on the invoices endpoint, can you profile and speed it up?
