---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features and shared widgets under lib/shared. Answer from this description and the code below.

A screen has Column(children: [Text('Orders'), ListView(children: rows)]) and Flutter throws a 'Vertical viewport was given unbounded height' error.

Request: Fix the error.
