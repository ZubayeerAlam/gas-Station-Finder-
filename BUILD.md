# FuelWise — Build Log & Development Memory

> Persistent implementation history. Records what was **actually** done and verified. Checklist lives in [PLAN.md](PLAN.md).
> Status labels: *implemented* · *locally tested* · *emulator/simulator tested* · *device tested* · *deployed* · *production verified*.

## Current status
- **Phase:** 0 — Foundation, Security & Architecture — **in progress**
- **Last checkpoint:** Batch 0.A (security + core + architecture migration) — complete, awaiting user's manual commit + "Let's proceed"
- **Next immediate task (Batch 0.B):** app branding & IDs (applicationId/bundle ID after user confirms `com.fuelwise.app`), app icon, run on Android emulator, live Places verification once key is fixed. App Check after Firebase project exists.

## Blockers / needs user
1. **Fix + rotate the Google API key.** Live check (2026‑11‑24): Places API (New) returns `403 PERMISSION_DENIED — Permission denied on the service` → **enable "Places API (New)"** in the key's Cloud project (and Maps SDK for iOS/Android; map tiles are blank on the simulator, same key). Legacy Places also refuses requests from this machine (key has app/IP restrictions). It was hardcoded and is in git history (commit `d481cb0`, `lib/repository/place_repository.dart`). It has been moved to gitignored local files so the app keeps working, but the old value must be revoked in Google Cloud Console and replaced with a restricted key (Android package + SHA‑1, iOS bundle ID, allowed APIs only).
2. **Application ID / bundle ID** — still `com.example.gas_station_finder` / `com.example.gasStationFinder`. Proposed `com.fuelwise.app`; needs user confirmation (affects key restrictions & Play Store).
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
