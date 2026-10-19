---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

The Django API returns products as JSON like {"id": 7, "name": "Pen", "price": "12.50"} where price is a decimal string. lib/shared/models/product.dart has a Product class with id and name, and its fromJson reads json['id'] and json['name'].

Request: Our Django API returns a price field. Add it to the Flutter Product model as a double.
