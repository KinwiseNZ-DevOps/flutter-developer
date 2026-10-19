---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

```dart
class UserCard {
  String getUserName(bool full) => full ? '$first $last' : first;
  bool get isEmpty => items.length == 0;
  void load() {
    try { fetch(); } catch (e) { print('failed'); }
  }
}
```

Request: Review this Dart class: it has a method getUserName(true), uses list.length == 0, and catches with a bare catch (e).
