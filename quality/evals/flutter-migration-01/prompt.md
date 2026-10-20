---
max_turns: 10
allowed_tools: [Read, Glob, Grep, Skill]
---

Project context (nothing else is available to read): a Flutter app called shop-app (Riverpod for state, go_router, Dio for HTTP) with screens under lib/features (orders, settings, cart, dashboard), shared widgets under lib/shared and a Django REST backend. Answer from this description and the code below.

android/app/build.gradle.kts applies id("kotlin-android") and has a kotlinOptions { jvmTarget = ... } block. The team just upgraded to Android Gradle Plugin 9.0.0 and the Android build now fails to compile.

Request: Fix our Android build, it stopped compiling after the Gradle Plugin upgrade.
