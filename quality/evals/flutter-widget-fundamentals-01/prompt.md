---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features and shared widgets under lib/shared. Answer from this description and the code below.

A CartList widget builds a ListView of CartRow widgets, each a StatefulWidget holding a local 'selected' bool. After the user deletes the first item, the wrong rows appear selected. The rows are created as CartRow(item: item) with no key.

Request: Why is the selection wrong and how do I fix it?
