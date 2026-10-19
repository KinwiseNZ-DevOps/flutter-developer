---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The web catalogue lists these components: data tables with sorting and column resize, tabs, empty states with an illustration, and a command palette (Ctrl+K search). The Flutter app targets iOS, Android and web.

Request: Here is a web component catalogue with tables, tabs, empty states and a command palette. Which of these can we build in our Flutter app and how?
