---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The Django API has GET /api/dashboard/summary/ returning revenue, orders and refunds for this week and last week as numbers. The app already has a theme with colours and spacing and a shared card widget.

Request: Build a dashboard screen with revenue, orders and refunds, each with a change since last week.
