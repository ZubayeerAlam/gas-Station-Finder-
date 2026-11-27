# Key setup (local development)

No key ever goes into source code, `BUILD.md`, `PLAN.md`, a commit, a chat message or a log.
Every file below is gitignored. Check with `./tool/check_keys.sh`: it says whether each key is set, never its value.

## 1. Google Maps Platform: two keys

An application restriction is either Android or iOS, never both, so FuelWise uses **one key per platform**.
The map, Places search and Place Details all use the same key on a given platform.

| | Android key | iOS key |
|---|---|---|
| Application restriction | Android apps: package `com.fuelwise.app` + SHA-1 of the signing cert | iOS apps: bundle ID `com.fuelwise.app` |
| API restriction | Maps SDK for Android, Places API (New) | Maps SDK for iOS, Places API (New) |
| Where it goes | `config/dev.android.json` → `GOOGLE_MAPS_API_KEY` (and `ANDROID_CERT_SHA1`, no colons) | `config/dev.json` → `GOOGLE_MAPS_API_KEY` **and** `ios/Flutter/Secrets.xcconfig` → `GOOGLE_MAPS_API_KEY` |

Places is called over REST from Dart: `places:searchNearby`, `places:searchText`, `places:autocomplete` and `GET places/{id}`.
The app sends `X-Android-Package` / `X-Android-Cert` or `X-Ios-Bundle-Identifier`, so the restricted keys work for REST too.
Routing uses OSRM, not Google, so the Routes API and Directions API are **not** needed.

Debug SHA-1 on this Mac: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1`.
Add the release / Play App Signing SHA-1 to the same Android key later.

Recommended in Cloud Console:
- Set per-API daily quotas (Places API (New) → Quotas) so usage cannot run away.
- Set a budget alert.

### Revoke the old exposed key (required)

The previous Google key was committed to git history. Removing it from the code does **not** make it safe: anyone with a copy of the history can still use it until Google stops accepting it.

1. Create and restrict the two new keys above, put them in the gitignored files, and run `./tool/check_keys.sh` (both show `set`).
2. Run the app once on iOS and once on Android and check that the map and nearby stations load with the new keys.
3. Cloud Console → APIs & Services → Credentials → open the **old** key (compare the last characters it shows with the old value; never paste the value anywhere) → **Delete API key**. Google gives a short grace period in which it can be restored; after that it is gone.
4. Check APIs & Services → Metrics over the next days: requests from the old key should drop to zero.

FuelWise cannot do this for you; it needs your Google account.

Run:
```bash
flutter run --dart-define-from-file=config/dev.json            # iOS Simulator
flutter run --dart-define-from-file=config/dev.android.json    # Android phone
```

## 2. Gemini API (assistant backend only)

- Create the key in Google AI Studio (API keys) in a Google Cloud project **without billing**. With billing enabled, the project moves to the paid tier.
- Restrict the key to the Generative Language API (Cloud Console → Credentials).
- Model: `gemini-3.8-flash` (the `GEMINI_MODEL` default).
  - Its free tier is listed as free of charge through 2026‑12‑31; re-check the pricing page before then.
  - Free-tier fallback, changed by hand only: `gemini-3.5-flash-lite`.
  - Free-tier content may be used by Google to improve its products; the privacy policy says so.
- Local emulator: `functions/.secret.local` holds one line, `GEMINI_API_KEY=...`. The Functions emulator reads it, and the Flutter app never sees it.
- Production (later, needs your approval): `firebase functions:secrets:set GEMINI_API_KEY` (Secret Manager).
  - Deploying Cloud Functions needs the Blaze plan, which is a billing decision.
- Over quota (HTTP 429), the assistant says the free daily limit is reached. It never switches model or tier on its own.

## 3. Open Charge Map (EV chargers)

- Needed only for live EV charger data (map chargers, nearby charger list). Nothing else depends on it.
- Free: openchargemap.org → sign in → My Profile → My Apps → register an app → API key.
- This is a client key, not a secret: it ships in the app like the Maps key.
- Put it in both `config/dev.json` and `config/dev.android.json` → `OCM_API_KEY`.
- Data is CC BY 4.0; the charger sheet already shows the attribution.
