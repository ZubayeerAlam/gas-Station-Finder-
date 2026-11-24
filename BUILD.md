# FuelWise — Build Log & Development Memory

> Persistent implementation history. Records what was **actually** done and verified. Checklist lives in [PLAN.md](PLAN.md).
> Status labels: *implemented* · *locally tested* · *emulator/simulator tested* · *device tested* · *deployed* · *production verified*.

## Current status
- **Phase:** 0 — Foundation, Security & Architecture — **in progress**
- **Last checkpoint:** Batch 0.B (app ID, icon, Android/iOS runs, route-flash + location-fallback fixes) — complete, awaiting user's manual commit + "Let's proceed"
- **Next immediate task (Batch 0.C):** live Places verification as soon as a working key is in `config/dev.json` + `ios/Flutter/Secrets.xcconfig` (nearby → details → route on both platforms; record fuelOptions/EV coverage). Then App Check once a Firebase project exists → Phase 0 acceptance review.

## Blockers / needs user
1. **Fix + rotate the Google API key.** Re-checked after user's Console changes (2026‑11‑24, Batch 0.B): **still 403** with the key in `config/dev.json` (unchanged old key) for both iOS and Android identity headers. If a new key was created, it must be placed in `config/dev.json` and `ios/Flutter/Secrets.xcconfig`. Key restrictions must use the new IDs: Android `com.fuelwise.app` + debug SHA‑1 `2D:5C:C4:55:84:56:0D:08:A4:94:D8:E2:01:B1:71:84:84:28:71:91`; iOS `com.fuelwise.app`. A single key can only have one application-restriction type → use "None" during dev or separate Android/iOS keys. Earlier live check (2026‑11‑24): Places API (New) returns `403 PERMISSION_DENIED — Permission denied on the service` → **enable "Places API (New)"** in the key's Cloud project (and Maps SDK for iOS/Android; map tiles are blank on the simulator, same key). Legacy Places also refuses requests from this machine (key has app/IP restrictions). It was hardcoded and is in git history (commit `d481cb0`, `lib/repository/place_repository.dart`). It has been moved to gitignored local files so the app keeps working, but the old value must be revoked in Google Cloud Console and replaced with a restricted key (Android package + SHA‑1, iOS bundle ID, allowed APIs only).
2. ~~Application ID / bundle ID~~ — resolved in Batch 0.B: `com.fuelwise.app` (user confirmed).
3. **Firebase project** — none configured. App Check (Phase 0) and all Phase 1 backend work require `flutterfire configure` by the user (Spark/free plan is fine for emulator work; no billing).

## Configuration requirements
- `config/dev.json` (gitignored; copy from `config/example.json`) → **always** run/build with `--dart-define-from-file=config/dev.json`. Android reads `GOOGLE_MAPS_API_KEY` from these dart-defines in `build.gradle.kts` (not local.properties — Flutter rewrites that file).
- `ios/Flutter/Secrets.xcconfig` → `GOOGLE_MAPS_API_KEY = ...` (gitignored; template `Secrets.example.xcconfig`)
- Google Cloud: enable Maps SDK for Android/iOS and **Places API (New)**.

---

## Phase 0 — Session 1 (2026‑11‑24)

### Initial repository state (inspected)
- Flutter 3.47.5 stable. Package `gas_station_finder`. Single screen app.
- `lib/Provider/locationProvider.dart`: one `ChangeNotifier` for location permission, position, nearby places, place details, OSRM route.
- `lib/Screen/home_screen.dart`: GoogleMap + markers + details bottom sheet + "Direction" button.
- `lib/repository/place_repository.dart`: **legacy** Places `nearbysearch` (5 km, `type=gas_station`) + `details`; **API key hardcoded**.
- `lib/repository/Route_Repository.dart`: OSRM over **plain `http://`**.
- `lib/Core/services/api_services.dart`: raw `http` GET wrapper, generic `Exception`s.
- Models hand-written (`Place`, `PlaceDetails`, `RouteModel` with GeoJSON parsing).
- Duplicates/shims: `lib/MyApp.dart`, `lib/Screen/homeScreen.dart`. Non-snake_case names.
- `test/widget_test.dart`: default counter test (broken — references a counter that doesn't exist).
- Same API key also hardcoded in `AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`.
- Working features (by code reading; not yet run): permission + current location, nearby stations, markers, details sheet, route polyline, straight-line distance.

### Done this session
**Dependencies** *(implemented; `flutter pub get` succeeded)*
- Removed: `provider`, `http`, `permission_handler`, `flutter_lints` (from deps)
- Added: `flutter_riverpod ^3.5.0`, `riverpod_annotation ^4.0.8`, `go_router ^18.1.4`, `dio ^5.11.1`, `freezed_annotation ^3.1.0`, `json_annotation ^4.12.0`
- Dev: `flutter_lints ^6.0.0`, `build_runner ^2.17.1`, `freezed ^4.0.3`, `json_serializable ^6.15.2`, `riverpod_generator ^4.0.10`, `mocktail ^1.0.5`

**Secure key config** *(implemented; gitignore verified with `git check-ignore`; builds not yet verified)*
- Created `config/dev.json` (gitignored), `config/example.json`.
- `android/app/build.gradle.kts`: (initially local.properties — superseded in Batch 0.A, see below) → `manifestPlaceholders`; `AndroidManifest.xml` uses `${MAPS_API_KEY}`; label → `FuelWise`.
- `ios/Flutter/{Debug,Release}.xcconfig` include optional `Secrets.xcconfig`; `Info.plist` `GMSApiKey = $(GOOGLE_MAPS_API_KEY)`; `AppDelegate.swift` reads it from the bundle; display name → `FuelWise`; location usage text updated.
- `.gitignore`: `/config/*.json` (except example), `/ios/Flutter/Secrets.xcconfig`.
- Remaining hardcoded key: `lib/repository/place_repository.dart` (removed when the Places data source is rewritten).

**Batch 0.A — Core layer + architecture migration** *(implemented, locally tested, iOS-simulator tested)*
- Riverpod: plain `Provider`/`AsyncNotifierProvider`/`FutureProvider.family` (no codegen — `riverpod_annotation`/`riverpod_generator` removed after evaluation to keep providers explicit). `ProviderScope(retry: null)` — Riverpod 3's auto-retry disabled; Dio handles network retries, permission errors aren't silently retried.
- `lib/core/`: `config/app_config.dart` (dart-define config, client-key note), `error/{app_failure,result}.dart` (sealed failures + `Ok`/`Err`), `network/dio_client.dart` (timeouts, `RetryInterceptor`: GET/flagged-idempotent only, 429/5xx/timeouts, 2 retries exp. backoff; `RedactingLogInterceptor` debug-only, no headers/bodies, key params redacted), `network/failure_mapper.dart`, `location/{geo_point,location_service,location_controller}.dart` (domain `GeoPoint` w/ haversine; Geolocator behind interface), `theme/app_theme.dart` (M3 light/dark, seed #0B8A6F, spacing/radius tokens), `widgets/state_views.dart`, `utils/formatters.dart`, `router/app_router.dart` (go_router).
- `features/stations`: freezed `Station`, `StationDetails`, `FuelPrice`, `EvChargeInfo`, `EvConnector`; `PlacesRemoteDataSource` (Places API **New**: `POST /v1/places:searchNearby` with Pro-tier mask, `GET /v1/places/{id}` with details mask incl. `fuelOptions`, `evChargeOptions`); `PlacesMapper` (dedupe, skips invalid, never fabricates prices; google.type.Money parsing); `PlacesStationsRepository` (returns `ConfigFailure` without network if key missing); app-identity headers; `MapScreen` (location states, markers, status banner, route polyline + summary card, fit-to-route) and `StationDetailsSheet` (draggable; open/rating chips, fuel prices with source + age, EV connectors labelled "reported", hours, phone).
- `features/route`: freezed `RouteInfo`, `OsrmRouteRepository` (HTTPS, `NoRoute` → `NotFoundFailure`), `RouteController`.
- Deleted legacy: `lib/{Provider,Screen,Model,repository,Core}/`, `lib/MyApp.dart`, `lib/my_app.dart`, `test/widget_test.dart`.
- **Issue & fix:** macOS case-insensitive FS — `rm -rf lib/Core` also deleted the new `lib/core`; files were recreated. *Lesson: never delete paths differing only by case.*
- **Issue & fix:** Flutter rewrites `android/local.properties` on build → Android key silently empty. Switched Gradle to decode `dart-defines`. Verified with `aapt2 dump xmltree`: `com.google.android.geo.API_KEY` populated in the APK; app label `FuelWise`.
- Decision: Places field masks split by billing tier (search on every refresh = Pro fields only; Enterprise fields only on tap for one place).
- Decision: `applicationId`/bundle ID left as `com.example…` pending user confirmation (affects key restrictions).

### Tests executed (Batch 0.A)
- `flutter analyze` → **No issues found**.
- `flutter test` → **43/43 passed**: RetryInterceptor (6), failure mapping (6), redaction (1), GeoPoint/formatters (7), PlacesMapper (7), repository w/ mocktail (4), headers (3), OSRM parsing (3), StationDetailsSheet widget states loading/data/no-price/error+retry/directions (4), MapScreen permission states (2).
- `flutter build apk --debug --dart-define-from-file=config/dev.json` → **built**; manifest key verified.
- `flutter build ios --simulator --debug` → **built**. `flutter run` on iPhone 17e simulator (location set to Berlin): app launched, location resolved, Places request sent over HTTPS, **403 from Google** shown as banner "The map service rejected the request…" with Retry (error path verified). Map tiles blank (same key issue).
- Live OSRM HTTPS check (curl): `Ok`, 1492 m / 224 s / 109 points.
- Not yet verified: live nearby results/details/route on device (blocked by key), Android emulator run.

---

## Phase 0 — Session 2 (2026‑11‑24) — Batch 0.B

### Repo state at session start
- Project now has its own git repo (root = project folder), commit `e3d281e first commit` + user-staged files. Docs matched code. Places (New) still 403.

### Done *(implemented, locally tested, Android-emulator tested, iOS-simulator tested)*
- **App ID → `com.fuelwise.app`** (user confirmed): `android/app/build.gradle.kts` namespace + applicationId; `MainActivity.kt` moved `kotlin/com/example/gas_station_finder/` → `kotlin/com/fuelwise/app/` (plain `mv`, not staged) with new package; iOS `PRODUCT_BUNDLE_IDENTIFIER` (Runner + RunnerTests) in `project.pbxproj`; `AppConfig` defaults. Dart package name stays `gas_station_finder` (internal only).
- **App icon:** `tool/make_icon.swift` (CoreGraphics, reproducible; no ImageMagick/PIL needed) → `assets/icon/icon.png` (1024, teal gradient + white map pin + fuel drop) and `icon_foreground.png` (adaptive, 62% safe zone). `flutter_launcher_icons ^0.14` (dev) config in `pubspec.yaml` → Android mipmaps + adaptive icon (`#0B8A6F` bg, `res/values/colors.xml`), iOS AppIcon set (alpha removed). Verified on Android 12+ splash screen.
- `config/dev.json`: `ANDROID_CERT_SHA1` set to debug keystore SHA‑1 (sent as `X-Android-Cert`).
- **Bug fix:** "Calculating route…" card flashed on app start — `RouteController.build()` was `async` → initial `AsyncLoading`. Now synchronous `FutureOr` → initial `AsyncData(null)`. Verified on emulator (no card while searching) + new unit test.
- **Robustness fix:** cold GPS can exceed the 15 s limit → `GeolocatorLocationService` now falls back to `getLastKnownPosition()` before failing. Verified on emulator: location resolved and Places request sent.
- **Android emulator:** existing shared AVD `nx-api33` could not resolve the activity (`Activity class does not exist`, `ceDataInode=0`) although the APK was correct (verified via `aapt2`); state polluted by other projects. Created dedicated AVD **`fuelwise-api33`** (Pixel 6, API 33, google_apis arm64) → app installs and runs.
- **ANR observation:** one ANR on first launch after a cold emulator boot — reason `executing service com.baseflow.geolocator.GeolocatorLocationService`, system load avg 37 + heavy memory pressure (emulator overload). **Not reproduced** on two subsequent launches (0 ANRs). Watch for it on a real device/release build.

### Tests executed (Batch 0.B)
- `flutter analyze` → **No issues found**.
- `flutter test` → **46/46 passed** (+3 `RouteController`: initial data(null), routeTo uses current location as origin, failure → typed error + clear).
- Android `fuelwise-api33` emulator (Berlin): splash with new icon → map widget renders → Places request → 403 banner (full text, 4 lines) → no route-card flash. Log: `Google Maps Android API: Authorization failure` (key).
- iOS iPhone 17e simulator: build has `CFBundleIdentifier = com.fuelwise.app`; new location permission text shown; after "Allow While Using App" → Places request → 403 (key).
- Live Places check via curl with iOS/Android identity headers → `403 PERMISSION_DENIED`.
- **Not verified:** live stations/details/route (blocked by key), App Check (no Firebase project), physical device.

