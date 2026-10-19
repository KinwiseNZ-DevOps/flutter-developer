---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final items = ref.watch(cartItemsProvider);
  final sorted = [...items]..sort((a, b) => a.name.compareTo(b.name));
  final total = sorted.fold(0.0, (s, i) => s + i.price * i.qty);
  return Column(children: [CartList(sorted), TotalBar(total)]);
}
```

Request: Where should the code that sorts and totals my cart items live? Right now it is inside the widget's build method.
