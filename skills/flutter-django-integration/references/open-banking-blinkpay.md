# Open banking payments on Flutter (BlinkPay)

Contents: architecture, opening the gateway, the return link, handling the outcome, platform setup, what the reference demo gets wrong on purpose

The Django side of this integration (the API the app calls) is owned by the `django-open-banking` skill in the django-api-architect repo. This file covers only the Flutter client half: presenting the bank step and finding out what happened. Distilled from BlinkPay's own Mobile Integration documentation; check it directly for anything this file does not cover.

## Architecture: the app never talks to BlinkPay directly

```
Flutter app -> your Django backend -> BlinkPay API
                      |
          redirect_uri returned to app
                      |
   in-app browser -> BlinkPay Gateway -> banking app
                      |
     return link (cid) -> Flutter app -> your Django backend -> GET status
```

The app authenticates to the Django backend the same way it does for everything else (the existing JWT flow in this skill), never with BlinkPay credentials. The backend decides the amount and payment reference from its own order record, the same "never trust the client" rule as the general integration guide, just applied to money moving through a bank instead of a card.

The app's job is three steps: ask the backend to start a payment and get back a `redirect_uri`, open that URL in an in-app browser, and once a return link or app-resume happens, ask the backend for the outcome again. The app never calls `sandbox.debit.blinkpay.co.nz` or `data.blinkpay.co.nz` itself.

## Opening the gateway

Open the `redirect_uri` in the platform's in-app browser, never an embedded `WebView`: `flutter_custom_tabs` gives Chrome Custom Tabs on Android and `SFSafariViewController` on iOS. A `WebView` is blocked by banks' anti-framing policies and defeats the point of the customer authenticating directly with their bank rather than through your app.

```dart
await launchUrl(
  Uri.parse(redirectUri),
  customTabsOptions: CustomTabsOptions(/* ... */),
  safariVcOptions: SafariViewControllerOptions(/* ... */),
);
```

SFSafariViewController does not close itself when the return link arrives; dismiss it from native code when the link is received (see Platform setup). An `ASWebAuthenticationSession`-based package closes itself automatically, but shows an iOS system prompt ("this app wants to use [site] to sign in") first, which reads oddly for a payment rather than a login; prefer the plain in-app browser unless that prompt is acceptable for the product.

## The return link

Register a return link as the `redirect_uri` sent when the backend creates the consent. A custom scheme (`myapp://callback`) is simplest and what BlinkPay's own Flutter demo uses; it must include a host part (`myapp://callback`, not `myapp:callback`). A universal link / app link (`https://app.example.com/blinkpay/return`) needs `apple-app-site-association` and `assetlinks.json` hosted on that domain, and should be tested on a real device since it does not always reopen the app through a redirect the way a tap does.

Whichever is used, it must be registered in the BlinkPay portal (Settings > API Settings, Whitelisted Redirect URLs) for each environment, separately from the Django backend's own web redirect URIs if it has one.

Handle the link with a package such as `app_links`, in both states: while the app is running, and as the app's launch link, since the OS may have closed the app while the customer was in their banking app.

## Handling the outcome: the link is a hint, never proof

When the return link arrives:

1. Check it is your own scheme, host and path. Any app can claim the same custom scheme, so this is not optional.
2. Check its `cid` matches the consent or quick-payment ID the backend returned for this order. The backend must have stored that ID before the browser opened, not only in the app's own state, because the OS can kill the app mid-flow.
3. If it carries a `status`, read it from a typed field, never from the human-readable `error` text, which can change without notice.
4. Treat the link itself as a trigger to re-check, not as the outcome. Call the backend's own status endpoint and let it be the one source of truth, since the backend is the one that actually asks BlinkPay.

The return link frequently never arrives at all: closing the browser, pressing back, or switching apps fires no redirect. So the same status check belongs in `AppLifecycleState.resumed`, not only in the return-link handler:

```dart
class _CheckoutPageState extends State<CheckoutPage> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _paymentInProgress) {
      _checkPaymentStatus(); // ask the backend, not BlinkPay directly
    }
  }
}
```

## Reconciling, not failing fast

If the backend reports the consent is still awaiting authorisation, the customer may still approve it in their banking app; don't show a failure or let the app offer to pay again. Poll the backend every second or so until a final status, the same cadence BlinkPay itself recommends for the server-to-BlinkPay leg, and stop polling once a final status arrives. While it is not final, tell the customer their bank is confirming the payment, and block a second payment attempt on the same order until the first has a final status, so they cannot be charged twice.

## Platform setup

- **iOS**: register the custom scheme in `CFBundleURLTypes` in `Info.plist` (or set up the universal link entitlement). Dismiss `SFSafariViewController` from `AppDelegate.swift` when the return link opens the app; the demo linked below shows the exact code.
- **Android**: add an intent filter (`VIEW`, `DEFAULT`, `BROWSABLE`, your scheme and host) to the activity that handles the return. Keep the default launch mode (`singleTop` for Flutter); the return link must reach the already-running activity, not start a second instance. From Android 11, add a `<queries>` entry for `https` `VIEW` intents so the app can find a Custom Tabs browser.
- **Emulators**: the Android emulator reaches a local backend at `10.0.2.2`, not `localhost`; the iOS Simulator can use `localhost`; a physical device needs the machine's network address or a tunnel. Bank apps are not installed on emulators, but the sandbox test bank (PNZ) runs entirely in the browser, so the full sandbox flow is still testable there.
- **Device testing**: install real NZ banking apps to confirm deep links out to them resolve correctly, and test closing the browser, backgrounding the app, and killing it mid-payment, checking that each ends with the right status shown.

## Reference implementation, and what not to copy from it

BlinkPay publishes a working Flutter demo built exactly this way (gateway flow, `flutter_custom_tabs`, `app_links`, a `blinkpaydemo://callback` custom scheme), with a small backend proxy holding the credentials. It is explicitly a reference, not an SDK, and BlinkPay's own docs flag three shortcuts in it that must not be copied into a real app: the app sends the amount and PCR and the demo's proxy passes them through unchecked (a real backend must compute them itself); the app authenticates to the proxy with a fixed demo API key compiled into the app (use the project's own user sessions instead); and the consent ID lives only in the app's memory (store it on the backend as soon as it is created, per Architecture above).
