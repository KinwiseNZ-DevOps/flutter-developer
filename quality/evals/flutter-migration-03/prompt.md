---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

pubspec.yaml has: environment: { sdk: '>=3.3.0 <4.0.0', flutter: '3.29.0' }. android/gradle.properties has no android.newDsl or android.builtInKotlin entries. android/app/build.gradle.kts applies id("kotlin-android") and has a kotlinOptions { jvmTarget = ... } block. The team wants to move to Flutter 3.47.0, the latest stable release as of this request.

Request: Upgrade us from Flutter 3.29 to 3.47.
