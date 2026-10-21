---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features and shared widgets under lib/shared. Answer from this description and the code below.

A State class creates a TextEditingController inside build() and a Timer in initState, and after await api.save() it calls Navigator.of(context).pop() directly. Nothing is disposed.

Request: Review this widget.
