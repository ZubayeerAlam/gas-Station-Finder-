# FuelWise — Build Log & Development Memory

> Persistent implementation history. Records what was **actually** done and verified. Checklist lives in [PLAN.md](PLAN.md).
> Status labels: *implemented* · *locally tested* · *emulator/simulator tested* · *device tested* · *deployed* · *production verified*.

## Current status
- **Mode (2026‑11‑25):** user authorized **autonomous development** — commit + push each verified batch to `origin/main`, no approval stops. No Firebase deploy / billing / paid APIs. Never force-push or commit secrets.
- **Done:** Phase 0 (except items awaiting keys / a Firebase project), Phase 1 (1.A–1.F), Phase 2 (AI trip assistant), Phase 3 batches 3.A (offline positions cache, CI, coverage gate, l10n foundation, a11y tests, README) and 3.B (full EN+BN, translated errors, splash, signing wiring, privacy policy draft, release guide).
- **Next:** everything left needs you: keys, a Firebase project (monitoring, push, deploy), signing keystore, store accounts, Bengali wording review.
- **Blocked on the user:** working Google Maps key · Open Charge Map key · Anthropic key · Firebase project (monitoring, push, deploy) · release signing + store accounts.

## Awaiting the new Google Maps API key (user will supply later)
- Live Places (New) nearby search / details / fuelOptions / evChargeOptions verification on iOS + Android.
- Map tiles (Maps SDK for Android/iOS).
- Country coverage notes for `fuelOptions.fuelPrices` / `evChargeOptions` based on real responses.
- Places Autocomplete (New), Text Search along route, destination details (trip planning, Batch 1.D) — request reaches Google from the simulator and returns 403 with the current key.
- Everything above is implemented and tested with **fixtures/mocks only**.

## Awaiting an Open Charge Map API key (free; user registers at openchargemap.org → `OCM_API_KEY` in config/dev.json)
- Live EV charger loading in EV mode (currently shows "Open Charge Map API key is not configured").

## Awaiting a Firebase project (user runs `flutterfire configure`, Spark plan, no billing)
- App Check, Auth, Firestore, Cloud Functions (emulator-tested code can be written before this).

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
- **Commit:** `a91860c` pushed to `origin/main` (verified `main...origin/main` in sync).

---

## Phase 1 — Batch 1.A: True Trip Cost engine (2026‑11‑25)
*(implemented, unit-tested; pure domain logic — no API key needed; not yet wired to UI)*
- `lib/core/utils/units.dart`: US/Imperial mpg, km/L, Wh/km, mi/kWh → per‑100 km; price per US gallon → per litre. Rejects non-positive input.
- `lib/features/garage/domain/vehicle_profile.dart` (freezed): `EnergyType {fuel, electric}`, consumption per 100 km, capacity (L / kWh), preferred fuel code, `chargingEfficiency` (default **1.0** — no invented loss), `unitsForDistance`, `unitsToBuyForDistance`, `rangeMeters(level)`; asserts positive values.
- `lib/features/ranking/domain/ranking_models.dart` (freezed): `StationOffer`, `FillRequest` (`FillToLevel` / `FillAmount`), `RankingStrategy {cheapestTotal, shortestDetour, bestValue}`, `CostMode {totalCost, unitPriceOnly}`, `RankingBadge`, `Caveat {closed, unreachable, otherCurrency, priceUnknown, stalePrice}`, `RankedStation`, `RankingResult`.
- `lib/features/ranking/domain/trip_cost_engine.dart`:
  - `total = (purchaseUnits + detourUnits) × price`; detour energy valued at the same station's price; EV purchase/detour divided by charging efficiency.
  - **Honesty:** unknown price → `unpriced` (never estimated); other currency → `unpriced` (never converted); no vehicle → `unitPriceOnly` mode (no invented totals); stale prices (> 3 days) flagged but ranked.
  - Eligibility: closed (`openNow == false`) or unreachable (distance > current range) stations are listed last and get no badges; unknown open status stays eligible.
  - Savings vs nearest = real difference vs smallest-detour eligible priced station.
  - Best value (heuristic, documented): `0.60·cost + 0.25·detour + 0.15·reliability`, min-max normalised; detour uses time when all candidates have it; unknown reliability = 0.5.
- Decision: engine is pure + synchronous; callers (route/along-route features) build `StationOffer`s. Makes it reusable by the AI assistant tools in Phase 2.

### Tests (Batch 1.A)
- `test/features/ranking/trip_cost_engine_test.dart` → **22/22 passed**, incl. hand-computed case where the lowest pump price (1.65 €/L, 30 km detour = 69.22 €) loses to 1.70 €/L with 6 km detour (68.66 €); savings 3.3838 € vs nearest.
- Full suite: **68/68 passed**; `flutter analyze`: no issues.


---

## Phase 1 — Batch 1.B: My Garage (2026‑11‑25)
*(implemented, locally tested; widget-tested; not yet checked on a device)*
- **Local DB decision:** Isar is unmaintained upstream (community fork), Hive v2 is untyped key/value. Chose **drift 2.35 + drift_flutter** (SQLite): typed tables, migrations, streams, in-memory DB for tests. `lib/core/database/app_database.dart` — `Vehicles` table + `Settings` key/value table, `schemaVersion 1`, `appDatabaseProvider`.
- `garage/domain`: `GarageRepository` (watch/save/delete/active vehicle → `Result`), `ConsumptionUnit` (L/100 km, km/L, mpg US, mpg UK, kWh/100 km, Wh/km, mi/kWh) — always stored as per‑100 km.
- `garage/data/drift_garage_repository.dart`: first saved vehicle becomes active; deleting the active vehicle activates the oldest remaining one; DB errors → `UnknownFailure`.
- `garage/presentation`: stream providers (`vehiclesProvider`, `activeVehicleIdProvider`, `activeVehicleProvider`), `GarageController`; `GarageScreen` (empty state, cards, tap = set active, edit/delete with confirm + Undo snackbar, full tank/charge range); `VehicleFormScreen` (Fuel/Electric toggle, unit dropdown converts the typed value, comma decimals, validation, EV charging efficiency %).
- **Navigation:** `StatefulShellRoute.indexedStack` with bottom bar (Map, Garage); routes in `core/router/app_routes.dart`; form routes on the root navigator; deep-linked form falls back to `go(garage)` when nothing to pop.
- **Test decision:** drift streams inside `testWidgets` hang in the fake-async zone. Repository is tested against a real in-memory drift DB in plain `test`s; widget tests inject `FakeGarageRepository` (`test/helpers/`) via `garageRepositoryProvider` override (DI).

### Tests (Batch 1.B)
- `test/features/garage/garage_test.dart` → **13/13 passed** (4 drift repository, 3 unit conversion, 1 parser, 5 widget: add in km/L → stored 8 L/100 km + active, unit switch converts, validation, EV efficiency + deep-link return, select active + delete/undo).
- Full suite **81/81 passed**; `flutter analyze` no issues.
- **Commit:** `f4ca6d4` pushed to `origin/main` (verified in sync).

---

## Phase 1 — Batch 1.C: Fill-up & charging history (2026‑11‑25)
*(implemented, locally tested; iOS-simulator smoke-tested)*
- `history/domain`: `FillUp` (freezed; amount in L/kWh, total cost + ISO-like currency code, optional odometer, full/partial, station), `FillUpRepository`, `HistoryAnalytics`:
  - `monthly` — grouped by (month, **currency**); currencies are never mixed or converted.
  - `consumption` — **full-to-full** method: litres/kWh bought since the previous full fill (partials included) ÷ km driven; segments with no odometer or no distance are skipped; cost/km only when the segment has a single currency.
  - `averagePer100Km` (distance-weighted), `primaryCurrency`, `spendByMonth` (zero-filled, crosses year boundary).
- DB: `FillUps` table (row class `FillUpRow`), **schemaVersion 2** with `onUpgrade` creating the table for v1 installs. Fill-ups are kept when a vehicle is deleted so the garage "Undo" restores history (orphans are hidden; cleanup = later task).
- UI: new **History** tab (bottom bar: Map · History · Garage). Stats (this month, avg consumption, cost/km), 6-month spend bar chart (primary currency; caption counts entries in other currencies), consumption line chart with the garage value as a dashed reference, entry list with delete + Undo. Charts have text semantics labels for screen readers.
- `FillUpFormScreen` (`/history/new`): date picker (no future dates), amount, total + currency (reuses last currency, never guessed from locale), live unit-price preview, optional odometer validated against earlier readings, full/partial switch, station; Save pinned to the bottom so it stays reachable.
- Dependency: `fl_chart ^1.3.1`.

### Tests (Batch 1.C)
- `test/features/history/history_test.dart` → **13/13 passed**: full-to-full with partials, no-distance/mixed-currency cases, weighted average, monthly per-currency grouping, spend window incl. year boundary, odometer validation helper, drift round-trip/filter/order/delete, history kept across vehicle delete+undo, UI: no vehicle, add fill-up end-to-end (unit price preview, saved values), validation, stats + charts + delete/undo.
- Full suite **94/94 passed**; `flutter analyze` no issues.
- **Commit:** `105431a` pushed to `origin/main`.
- iOS simulator (iPhone 17e): debug build installs; drift DB opens on device; bottom bar with 3 tabs and Garage empty state render. **Not verified on device:** typing into forms (simulator text injection did not reach Flutter fields) — covered by widget tests only.

---

## Phase 1 — Batch 1.D: Stations along my route (2026‑11‑25)
*(implemented, locally tested; OSRM parts live-verified; Places parts mocked — key blocked)*
- **Pipeline** (`along_route/domain/along_route_planner.dart`): OSRM route → split into ≤ 4 pieces (piece size ≥ length/4 + longest edge, so the count is bounded) → Douglas–Peucker (30 m) → encoded polyline → Places **Text Search with `searchAlongRouteParameters`** per piece (parallel) → dedup by place id → 5 km corridor filter via point-to-polyline projection → 25 closest-to-route stations get detours from **one OSRM `/table` request** → details (price + open now) only for the 8 smallest detours (Enterprise SKU cost control, 10 min in-memory cache) → sorted by position along the route.
- **Decision:** used Google's search-along-route instead of sampling many nearby searches: 1 request per piece instead of ~30 for a long trip, and results are route-aware. Pieces keep long trips from returning only stations near the start (20 results per request).
- **Detour math:** `detour = d(origin→station) + d(station→destination) − d(origin→destination)` from the table (distance + duration), clamped ≥ 0. If the table call fails: `2 × off-route distance` and the plan is flagged **approximate** (shown in UI). Unroutable stations (null cells) are dropped.
- **Prices:** exact fuel-type match only (`PlacesQuoteLookup.pickPrice`); a Premium price is never used for Regular. EVs: no Google price → unpriced (honest).
- **Search target:** EV vehicle → `electric_vehicle_charging_station`; fuel → `gas_station` priced by the vehicle's fuel (default Regular when no vehicle).
- **Ranking:** `alongRouteRankingProvider` feeds `TripCostEngine` locally — strategy / fill level / vehicle changes re-rank without network calls.
- **UI:** "Plan trip" button on the map → `DestinationSearchScreen` (Autocomplete New, 350 ms debounce, stale-response guard, one session token for autocomplete + details) → `AlongRouteScreen`: map with route + markers (top 3 green, selected azure) under a draggable sheet with route summary, approximate/skipped notices, vehicle fill slider (or "add vehicle" prompt + unit-price mode), strategy segmented button, ranked cards (rank, detour km + min, position on trip, badges/caveats, total cost or unit price) with expandable plain-language explanation, and an "unpriced" section.
- `OsrmRouteRepository` now also implements `DetourRepository` (separate interface, so existing route fakes are unaffected).

### Tests (Batch 1.D)
- `test/features/along_route/along_route_domain_test.dart` → **16 passed**: projection, simplification, split bounds/connectivity, encoded polyline vs Google's reference example, OSRM table parsing (real response shape) incl. null cells/error code, autocomplete + destination parsing, missing-key guard, exact-match price lookup + cache, planner (dedup, corridor, bounded piece count, detour mapping, quote budget, approximate fallback, error propagation), explanation lines with hand-computed totals (EUR 60.62 vs 63.77, saves 3.15), search target per vehicle.
- `test/features/along_route/along_route_ui_test.dart` → **4 passed**: ranking + strategy re-order + explanation, fill slider recomputes (EUR 40.62 at 50 %), no-vehicle unit-price mode, full flow map → Plan trip → debounced search (1 request) → suggestion → plan rendered (shared session token).
- **Live:** OSRM route + table on router.project-osrm.org (Berlin → Potsdam, 36.1 km): on-route point detour 0 m, 2 km off-route point detour 5.5 km (temporary test, not committed).
- **iOS simulator:** Plan trip button → search screen; typing "Potsdam" sends a real Autocomplete request → Google 403 → error view with retry.
- Full suite **114/114 passed**; `flutter analyze` no issues.
- **Commit:** `073be94` pushed to `origin/main`.

---

## Phase 1 — Batch 1.E: EV mode (2026‑11‑25)
*(implemented, locally tested; fixture-tested OCM — key required; iOS-simulator checked)*
- `ev/domain`: `ChargePoint` (connectors, max kW, fast ≥ 50 kW, operational status, operator, free-text usage cost, last verified/status dates), `ChargeConnector` (type, kW, AC/DC, quantity, status), `EvFilter` (min power, connector types, operational only — a connector must satisfy power **and** type together), `chargeMarkerLabel`.
- `ev/data/open_charge_map_repository.dart`: `GET /v3/poi` (lat/lng, 10 km, max 100, `compact=false` for connector/status titles, `verbose=false`), key in `X-API-Key` header (never in URL/logs), tolerant parser (skips entries without id/coordinates, dedups, unknown connector → "Connector <id>"). Missing key → `ConfigFailure` without a request. `OCM_API_KEY` added to `AppConfig` + `config/example.json`.
- **Probe:** OCM API without a key → `403 You must specify an API key` (so live data needs the user's free key).
- **Map:** Fuel/EV segmented toggle (defaults to the active vehicle's type), filter button with active badge, status banner per mode (no Retry for configuration errors), **marker clustering** via `ClusterManager`, **custom pill markers** drawn with `dart:ui` showing max kW (teal fast, tertiary slow, grey not operational), cached per label/colour. Only the selected mode's API is called (saves Places requests in EV mode).
- `ChargePointSheet`: status chip, max power, connector list, cost shown verbatim as "listed by the community; not verified", last verified, Directions (OSRM route), attribution "Charging data © Open Charge Map contributors (CC BY-SA 4.0)" — also shown on the map when chargers are visible.
- `EvFilterSheet`: power steps, connector chips built from connectors present nearby, operational-only switch, reset.

### Tests (Batch 1.E)
- `test/features/ev/ev_test.dart` + fixture `test/fixtures/ocm_poi_berlin.json` → **13 passed**: parsing (fields, dates, AC/DC, invalid/duplicate entries skipped, unknown values stay unknown), missing-key guard, request parameters, filter combinations, labels, status texts incl. no retry for config errors, map mode default from vehicle + switching, PNG marker rendering + cache, charge point sheet (known + unknown data), filter sheet, and map-level flow (EV loads chargers once, no repeated fuel search, local filtering).
- Full suite **127/127 passed**; `flutter analyze` no issues.
- **Commit:** `0167c85` pushed to `origin/main`.
- iOS simulator: toggle visible; EV mode shows filter button and "Open Charge Map API key is not configured" banner. **Not verified:** pill markers/clustering with real data on a device (needs OCM key).

---

## Phase 1 — Batch 1.F (part 1): Crowdsourced price backend (2026‑11‑25)
*(implemented, unit-tested, emulator-tested — **not deployed**, no Firebase project, no billing)*
- **Emulator project:** `.firebaserc` → `demo-fuelwise` (the `demo-` prefix makes the Emulator Suite run fully offline; no real project or login). `firebase.json`: Firestore rules/indexes, functions codebase (runtime nodejs22, region europe-west1, `maxInstances: 5`, 256 MiB — cost caps), emulator ports.
- **Data model:**
  - `priceReports/{id}` — client creates only (own uid, `reportedAt == request.time`, fuel type whitelist, price 0.01–1000, ISO currency, station coords); no update/delete; author-only read.
  - `stations/{id}` (name, lat/lng, lastPriceAt, reliability, votes), `stations/{id}/prices/{fuel}` (consensus), `stations/{id}/priceHistory/{fuel_day}` (close/min/max/samples per UTC day) — read for signed-in users, **write only by functions**.
  - `stations/{id}/verifications/{uid}` — one private vote per user (open / fuelAvailable, server time).
  - `users/{uid}` (trust stats, function-written, owner-read), `users/{uid}/alertRules/{id}` (validated owner CRUD), `users/{uid}/private/messaging` (FCM token), `alertLog` (server-only).
- **`functions/src/pricing.ts` (pure):** consensus (TTL 72 h → majority currency → leave-one-out outlier > 15 % when ≥ 3 reports → weighted median, weight = trust × 0.5^(age/12 h); confidence = (1 − e^(−Σw)) × (1 − mean deviation / 15 %)), Laplace trust, reliability (mean of known components: freshness, vote agreement; null when unknown), rate limits, alert matching (fuel, currency, threshold, radius or specific station), haversine.
- **`functions/src/handlers.ts`:** `processReport` (idempotent: rate limit → consensus → aggregate + station + report status in one batch → trust → daily history in a transaction → reliability → alerts) and `refreshReliability`. Alerts: collection-group query on `alertRules` (composite index in `firestore.indexes.json`) then exact match in code; duplicate prevention by a transactional `alertLog` claim with 12 h cooldown; FCM in production, **log-only in the emulator**.
- **Triggers (`index.ts`):** `onPriceReportCreated`, `onVerificationWritten` (v2 Firestore triggers). No HTTP/callable endpoints → no public attack surface besides rules.
- **Decisions:** report trust only changes on evidence (corroborated or outlier) so spamming isolated reports cannot farm trust; two disagreeing reports never veto each other (outlier test needs ≥ 3); minority-currency reports stay `pending` (never converted).
- `functions/node_modules` (≈ 280 MB) and `lib/` are gitignored.

### Tests (1.F part 1) — run with `cd functions && npm test`
- `test/unit/pricing.test.ts` → **13 passed** (`node --test`).
- `test/emulator/rules.test.ts` → **6 passed** (Firestore emulator + `@firebase/rules-unit-testing`): report validation (auth, own uid, server time, ranges, currency, fuel, coords, no status, required fields), no update/delete, author-only read, read-only aggregates, private votes, validated alert rules, private FCM token.
- `test/emulator/functions.test.ts` → **4 passed** with the **real triggers in the Functions emulator**: 3 reports → consensus 1.80 EUR, 4th at 2.50 rejected as outlier (trust 0.3333), corroborated reporter trust 0.6667, daily history + station doc; duplicate report rate-limited; votes → reliability 0.667 + out-of-stock count; alert fires for the matching rule only and exactly once inside the cooldown (1 emulator FCM log line).

## Phase 1 — Batch 1.F (part 2): Community prices client (2026‑11‑25)
*(implemented, unit/widget-tested, iOS-simulator-tested against the Firebase Emulator Suite — **nothing deployed**, no Firebase project, no billing)*
- **Packages:** `firebase_core 5.2`, `firebase_auth 7.1`, `cloud_firestore 7.2` (iOS pulls the Firebase SDK via Swift Package Manager; first simulator build 3 min 21 s, later builds ~30 s).
- **Config (`lib/core/config/app_config.dart`):** `FIREBASE_MODE` = `off` (default) · `emulator` (project `demo-fuelwise`, host `FIREBASE_EMULATOR_HOST`, default `localhost`) · `project` (client options via `FIREBASE_PROJECT_ID/_API_KEY/_APP_ID/_MESSAGING_SENDER_ID` dart-defines — nothing committed, no `GoogleService-Info.plist`/`google-services.json` in git).
- **`lib/core/firebase/firebase_bootstrap.dart`:** starts Firebase before `runApp`, never blocks the app; result injected as `firebaseStatusProvider`. **Bug found on the simulator and fixed:** the native iOS Firebase Installations SDK aborts the whole process (uncatchable from Dart) when the API key is not 39 chars starting with `A` → emulator mode uses a format-valid placeholder, and project mode checks key/app-id format in Dart first (bad config = community off, not a crash). Regression test added.
- **Domain (`features/prices/domain`):** `CommunityPrice` (consensus, report count, confidence, `expiresAt` → `isFresh`), `PriceHistoryDay`, `StationReliability` (null score = unknown), `PriceReportDraft`, `StationVote`, `PriceAlertRule`; validation mirrors the rules (price 0.01–1000, ISO currency, fuel whitelist incl. `EV_KWH`); plain-language reliability bands and server-verdict messages.
- **Data:** `FirestoreCommunityRepository` — lazy anonymous sign-in shared by concurrent callers, real-time listeners, writes contain exactly the fields the rules allow (`reportedAt`/`at` = server timestamp), Firebase errors mapped to `AppFailure`s; pure, unit-tested mappers. `UnavailableCommunityRepository` when Firebase is off: empty reads, `ConfigFailure` writes — nothing faked.
- **UI:**
  - Station sheet → **Community prices** section: consensus per fuel (reports, age, "outdated" after TTL), tap → **price history chart** (7 / 30 days; consensus line + min–max band; one currency only), **reliability** (bar, %, band, vote counts, "not an official check"), **votes** (Open / Closed / Out of fuel).
  - **Report a price** screen (`/prices/report`): fuel defaults to the active vehicle (EV → per-kWh), currency from the station's existing real prices (never from locale), live server verdict (accepted / outlier / duplicate / rate limited).
  - **Price alerts** screen (`/alerts`, bell on the Map app bar): create (fuel, currency, max price, 1–50 km around current location), pause, delete. Honest note that push is not enabled yet.
- **Ranking:** `CombinedQuoteLookup` — Google price first; a *fresh* community consensus for the exact fuel fills the gap (`PriceSource.community`); community reliability attached to stops → `StationOffer.reliability` (used by Best value). EV planning uses `EV_KWH`. Community failures/timeouts (5 s) never break planning.
- `firestore.indexes.json`: + `priceHistory (fuelType, day)`.
- **Bugs found and fixed while testing:** default fuel / currency read once in `initState` before the garage / price streams loaded (now follow the data until the user edits); alert sheet hid its fields behind the keyboard (used the screen's context for `viewInsets` instead of the sheet's).

### Tests (1.F part 2)
- `test/features/prices/community_prices_test.dart` → **22 passed**: Firestore mapping (Timestamps, incomplete docs, unknown reliability stays null, alert-rule keys ⊆ rule whitelist, UTC day key), Firebase error mapping, validation/defaults, `FIREBASE_MODE` parsing, Firebase option format guards, `CombinedQuoteLookup` (Google wins, stale/other-fuel ignored, reliability attached, backend off = Google only, EV kWh), widgets (prices + history 7→30 + votes, vote failure, backend off, report validate/submit/verdict, outlier verdict, alerts create/pause/delete, alerts off), unavailable repo.
- Full suite: **149 passed**; `flutter analyze`: no issues.
- **iOS simulator (iPhone 17e) + Emulator Suite (auth, firestore, functions):** app starts in emulator mode; Price alerts → anonymous sign-in + listener (empty state); created "Regular ≤ EUR 1.75 within 10 km" → stored under `users/{anonUid}/alertRules` through the real rules; a matching report (1.699 EUR, 0.4 km away) processed by the real trigger → consensus written and the **app-created rule matched** (`alertLog` cooldown claim; 0 pushes because no FCM token); pause → `enabled=false`; delete → doc gone (404).
- **Not verified on device:** community section / report screen / history chart — they live in the station sheet, which needs stations from Places (current Google key → 403). Covered by widget tests only.

### Run community features locally (no Firebase project needed)
```bash
cd functions && npm run build && cd ..
firebase emulators:start --only auth,firestore,functions --project demo-fuelwise
flutter run --dart-define-from-file=config/dev.json --dart-define=FIREBASE_MODE=emulator
```
Android emulator: add `--dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2`; physical device: the Mac's LAN IP (and start the emulators with `host: 0.0.0.0`). **Not verified on Android yet:** Android 9+ blocks cleartext HTTP, so the Auth emulator may need a debug-only network security config.

## Phase 2 — AI Trip Assistant (2026‑11‑25)
*(implemented, unit/emulator/widget-tested, iOS-simulator-tested against the Emulator Suite with the **offline demo model** — **no live Claude call** (no API key), **nothing deployed**, no billing)*
- **Backend (`functions/src/assistant.ts`, callable `assistantChat`, europe-west1, max 5 instances, 120 s):**
  - Claude via the official `@anthropic-ai/sdk` 1.14; model **`claude-haiku-5-5`** (ID checked in the SDK's model list); `max_tokens` 4096, `output_config.effort: medium`, strict tools, prompt caching on; SDK timeout 60 s, 1 retry.
  - Key: `defineSecret('ANTHROPIC_API_KEY')` — Secret Manager in production, `functions/.secret.local` in the emulator (gitignored). Never sent to or stored in the app.
  - Manual tool loop; history is **append-only** and stored server-side in `assistantSessions/{id}` (thinking blocks replayed unchanged). The client can't read or edit it (catch-all deny in the rules; rules test added).
  - Tools are split by where the data lives. **Client tools** (`get_vehicle`, `plan_route_stops`) run on the device; the function returns `needs_client_tools`, and the app posts results only for the pending tool ids. **Server tools** (`get_community_prices` = fresh Firestore consensus; `show_station_cards`) run in the function. Card ids are accepted only if the app's own plan returned them, and unknown tools get an error result.
  - Guards: auth required; text 1–1000 chars; tool results ≤ 16 KB and ≤ 4; per-user quota of 20/hour and 100/day (Firestore transaction, `assistantQuota/{uid}`, server-only); ≤ 6 model calls per request and ≤ 20 user turns per session; refusal → polite reply; `max_tokens` → partial reply marked as cut short; model failure → `unavailable` and the session is left consistent; internal errors are never shown to users.
  - **Offline demo model** (`demo_model.ts`): used **only in the emulator when no key is set**. It is a scripted stand-in that speaks the same protocol. Every response carries `demo: true` and the app labels it "Offline demo — not Claude".
- **App (`lib/features/assistant`):**
  - `cloud_functions 7.1`; the functions emulator is wired in `FirebaseBootstrap`.
  - `FirebaseAssistantApi`: anonymous sign-in. **Bug found on the simulator and fixed:** a stored user whose token can no longer refresh (reset emulator, or a deleted user in production) made every call fail with an opaque `internal`; the app now detects this and signs in again.
  - `AssistantToolRunner` runs `plan_route_stops` with the **same** `AlongRoutePlanner` + `offersFromPlan` + `TripCostEngine` as the trip screen (destination via Places autocomplete → details, vehicle + fill level from the garage). The model sees the engine's ranked order and figures and never estimates anything.
  - `AssistantController` (Riverpod) loops through client-tool rounds (max 4). Cards are resolved against the planned trip snapshot. A failure mid-tool-call starts a fresh session.
  - `AssistantScreen`: welcome + suggestions, chat bubbles, tool status ("Planning your route…"), demo label, ranked `StationResultCard`s with "Show on map" (opens the trip screen with that plan and strategy), new chat, and an unavailable state when Firebase is off.

### Tests (Phase 2)
- Functions:
  - `test/unit/assistant.test.ts` → 6 tests (validation, strict closed schemas, plan id extraction, demo destination parsing); unit total 19.
  - `test/emulator/assistant.test.ts` → **7 passed** against the Firestore emulator with a scripted fake Claude. It checks:
    - full client and server tool round trip, with results in tool_use order and thinking kept;
    - append-only history; wrong or foreign session ids rejected;
    - stale community prices dropped; bogus card ids rejected;
    - unknown tool not executed; refusal and max_tokens handling;
    - model failure; pending-state guard; loop cap; hourly quota, per user, resetting each hour.
  - `rules.test.ts` + "assistant sessions and quota are server-only" → 7 passed.
  - `functions.test.ts` + real callable through the auth + functions emulators (unauthenticated rejected, empty text rejected, demo round trip with cards) → 5 passed.
- Flutter: `test/features/assistant/assistant_test.dart` → **12 passed**. It covers:
  - protocol parsing of platform maps; error mapping;
  - `get_vehicle`; **plan_route_stops order == TripCostEngine order**; same totals as the trip screen (EUR 60.62 / 63.77);
  - tool errors reported, not invented;
  - controller round trip and card resolution; session reset on failure; `cardsFor`;
  - screen: unavailable state, chat with cards in server order plus demo label plus new chat, and the suggestion chip.
- Full suite: **161 passed**; `flutter analyze`: no issues.
- **iOS simulator (iPhone 17e) + emulators:** opened the assistant and tapped a suggestion. The function ran twice (message, then the app's tool result). The app's `plan_route_stops` called Places autocomplete, which returned **403** (current Google key), so the tool honestly reported an error and the demo replied "I could not plan that route in the app." The Firestore session has 4 append-only messages with nothing pending, and the quota counted 1.
- **Not verified:** a real Claude conversation (no `ANTHROPIC_API_KEY`) · station cards on device (needs Places) · Android.

### Run the assistant locally
```bash
cd functions && npm run build && cd ..
# optional, real Claude in the emulator (never commit this file):
#   echo 'ANTHROPIC_API_KEY=<your key>' > functions/.secret.local
firebase emulators:start --only auth,firestore,functions --project demo-fuelwise
flutter run --dart-define-from-file=config/dev.json --dart-define=FIREBASE_MODE=emulator
```

## Phase 3 — Batch 3.A: offline, CI, localization, accessibility, README (2026‑11‑25)
*(implemented, unit/widget-tested, iOS-simulator-tested for localization; CI verified green on GitHub)*
- **Offline (Places-policy compliant):** Google's Places policies (checked on developers.google.com, Places API (New) → Policies) allow storing only **place IDs** (indefinitely) and **lat/lng for ≤ 30 consecutive days**; names, addresses and other content may not be stored. The Service Specific Terms page could not be read by the fetch tool, so the stricter reading is used.
  - New drift table `place_locations(place_id, lat, lng, fetched_at)` (schema v3 + migration). Nothing else from Places is written to disk.
  - `OfflineFallbackStationsRepository` wraps the Places repository. Live results pass through and their id + position are saved. On a **network/timeout** failure it returns saved positions within the radius, nearest first, named "Saved station" with `offlineSavedAt`. Config/403/server errors are **not** masked. Rows older than 30 days are purged on every read/write.
  - Map banner: "Offline · N saved station positions (age). Names and prices need a connection." + Retry. Details still need a connection (honest error).
  - Already local: garage, fill-up history, settings. Community data: Firestore SDK's default offline cache on iOS/Android (not separately tested offline).
- **CI (`.github/workflows/ci.yml`):** Flutter job: pub get → build_runner + `git diff --exit-code` on generated files → analyze → `test --coverage` → **domain coverage gate ≥ 70 %** (`tool/domain_coverage.py`) → upload lcov → debug APK artifact. Functions job: Node 22 + Java 21 + firebase-tools → `npm test` (unit, rules, assistant, callable integration on the `demo-` project). No deploy step, no secrets.
- **Coverage:** domain layer **97.3 %** (431/443 lines in 16 files, generated code excluded). Note: lcov only lists files loaded by tests.
- **Localization:** `flutter_localizations` + `intl`, `l10n.yaml`, `lib/l10n/app_en.arb` / `app_bn.arb` (93 keys each, plurals), generated `AppLocalizations`. `context.l10n` falls back to English when no delegates are installed (keeps pure functions and old widget tests working). Language menu (translate icon on Garage): System default / English / বাংলা, stored via `LocalePreferenceStore` (drift setting `locale`). Translated: bottom navigation, Map (app bar, status banner incl. plurals, location problems, mode toggle, route card), station details sheet, Garage list + delete flow, Assistant, shared loading/error views. Bengali text drafted by Claude — **please review wording** (you are a native speaker).
- **Accessibility:** automated `meetsGuideline` checks (Android tap-target size, labelled tap targets, text contrast) on Garage and Assistant, at **200 % text scale**, in English and Bengali, with no overflow.
- **README:** replaced the Flutter template: features with honest status, Mermaid architecture diagram, folder map, setup, emulator instructions, tests, privacy, CI badge.
- **Flaky test fixed:** `ev_test` "map mode defaults to the active vehicle" waited a fixed 20 ms for the garage stream; failed once under full-suite load → now awaits the providers' futures.

### Tests (3.A)
- `test/features/stations/data/offline_cache_test.dart` → 6 passed (only id+position stored — column list asserted; offline fallback nearest-first without names; timeout falls back but config/403 don't; 30-day purge; empty cache keeps the error; banner text).
- `test/l10n/l10n_a11y_test.dart` → 10 passed (every EN key has a BN translation and vice versa; locale preference; EN/BN plurals; Bengali navigation + garage; language menu switches the whole app and back to system; drift store round-trip; accessibility guidelines at 200 % for Garage and Assistant EN/BN; Bengali unavailable state).
- Full suite: **177 passed**; `flutter analyze`: no issues; functions: unit 19, rules 7, assistant 7, integration 5 — all passed.
- **iOS simulator (iPhone 17e):** Garage → translate menu → বাংলা: title, empty state, buttons and navigation switch to Bengali; choice survives an app restart (Map app bar, Fuel/EV toggle, Retry in Bengali). Visible gap: failure messages from the data layer are still English.
- **CI on GitHub:** run 45639465141 for commit 9ba7cfb — **both jobs passed** (Functions 1m36s, Flutter 9m21s; artifacts `coverage` + `app-debug-apk`). Warnings only: actions v4 run on Node 20 (deprecated) and setup-java v4 is deprecated → bump to v5 in a later batch.
- **Not verified:** offline fallback on a device (cache can't fill while Places returns 403).

## Phase 3 — Batch 3.B: full Bengali, translated errors, release prep (2026‑11‑25)
*(implemented, unit/widget-tested, iOS-simulator-checked, CI green)*
- **Errors translated without losing detail:** `AppFailure` gained a nullable `FailureCode` (25 codes). Data sources tag their failures (network, timeout, 403 key rejected, 429, 5xx, missing keys, no route, location reasons, community/assistant). `describeFailure(error, l10n, fallback:)` turns a code into text; a failure **without** a code (e.g. a specific message from the server) is shown as-is. The English `message` stays for logs and for the AI's tool results.
- **Every screen translated:** History (stats, charts, semantics labels), fill-up form, vehicle form, Alerts + alert form, community prices/history/votes, Report price + server verdicts, trip planning (destination search, route results, vehicle controls), ranking badges/caveats/strategies and the "why" explanation, EV filter + charger sheet, assistant errors. Domain stays English: `lib/l10n/domain_labels.dart` maps fuel types, connectors, reliability bands, report verdicts and price validation to translations (codes like E10/CCS2 stay as-is). Relative times and month names come from ARB (`monthsShort`), because intl's `DateFormat` needs locale data that isn't loaded in tests. 327 keys in each language.
- **A11y bug found by the new tests and fixed:** at 200 % text the fuel-type dropdowns (vehicle form, alert form, report form) and the consumption unit dropdown overflowed horizontally → `isExpanded` + ellipsis.
- **iOS:** `CFBundleLocalizations` = en, bn (so iOS treats Bengali as supported).
- **Splash:** `flutter_native_splash` (dev dependency) with brand green `#0B8A6F` + the icon foreground; generated Android (incl. Android 12 splash API, night variants), iOS LaunchScreen and web. The generator also rewrote Info.plist formatting → reverted, only the localization key added by hand.
- **Signing wiring:** `android/app/build.gradle.kts` reads `android/key.properties` (already gitignored with `*.jks`/`*.keystore`); without it release falls back to the debug key. Not exercised with a real keystore.
- **Docs:** `docs/privacy-policy.md` (draft; based on what the code sends: Google Maps/Places, OSRM, Open Charge Map, Firebase anonymous auth + Firestore, assistant via Cloud Functions → Claude; contact/retention placeholders for you) and `docs/RELEASE.md` (keys, keystore, build, store checklist — nothing executed).
- **CI:** actions bumped to current majors (checkout v7, setup-java v6, setup-node v7, upload-artifact v7) to clear the Node 20 deprecation warnings.

### Tests (3.B)
- `test/l10n/l10n_screens_test.dart` → 10 passed: every `FailureCode` has non-empty, distinct EN/BN text; default constructors carry codes, uncoded custom messages pass through; fallbacks; relative time + months EN/BN; domain labels; ranking labels (BN in UI, EN default for AI); Bengali History with entries, fill-up form validation, vehicle form, Alerts-unavailable — each at **200 % text** with tap-target/label/contrast guidelines; destination search hint.
- Updated `history_test` expectation for the corrected singular ("1 entry in another currency…").
- Full suite **188 passed**; `flutter analyze` clean; domain coverage **97.1 %** (430/443).
- **iOS simulator (iPhone 17e, Bengali):** Map shows the Places 403 error **in Bengali** (was English in 3.A); History empty state, Garage, vehicle form (labels, segmented control, unit dropdown, fuel type "রেগুলার (অকটেন)", validation messages) all Bengali, no overflow.
- **CI on GitHub:** run 45644565363 for commit 5df7501 — both jobs passed (Functions 1m06s, Flutter 7m45s incl. debug APK); the Node 20 / setup-java deprecation warnings are gone.
- **Not verified:** release build with a real keystore; splash on a physical device (simulator launch is too fast to capture reliably); screens that need live data (station results, route ranking, chargers) in Bengali on a device.

## Final report (2026‑11‑25)
- Written: [docs/FINAL_REPORT.md](docs/FINAL_REPORT.md).
- **Correction to the key note in "Next steps" above:** commit `d481cb0` belongs to the older parent repository `~/FluterDev/Project`, not to this repo. `git log -S AIza` over this repo's whole history finds nothing. That commit is not on any remote branch there, and the GitHub repo its remote points to cannot be reached. The key was still kept in plain text locally, so rotating it remains recommended.

## Phase 4 — Vehicle care reminders (user-chosen problem, 2026‑11‑25)
Plan: document-expiry and service reminders per vehicle (BRTA tax token, fitness, insurance, route permit, CNG cylinder retest, oil change, tyre rotation, custom), due by date, by km, or both, using odometer readings already logged in History. Fully offline; no API key or paid service. No existing feature is removed or changed.

### Batch 4.A — domain + data *(implemented, unit/repository-tested)*
- `lib/features/care/domain/care_reminder.dart`: freezed `CareReminder`; `CareType` enum.
- `lib/features/care/domain/care_schedule.dart` (pure):
  - `CareStatus.of`: bands overdue / dueSoon / upcoming / needsSetup / done. Days are calendar days, so the time of day and DST don't shift them. "Due soon" = within the reminder's notice days, within 500 km, or an estimated date within the notice days. The effective due date is whichever of the real date and the km/day estimate comes first, and estimates are flagged. Progress is computed from the last done point.
  - Also: `sortByUrgency`, `markDone` (rolls repeating reminders forward; one-offs become *done*), `addMonths` (31 Jan + 1 → 28 Feb), presets via `kCarePresets` / `suggestedCareTypes` / `reminderFromPreset`, and `careNotices` (N days before + on the day at 09:00; past times dropped).
  - Preset intervals are starting values only. Document dates always come from the user.
- `HistoryAnalytics.odometerStats`: the latest odometer is the **highest** reading (entries can be logged out of order). km/day comes from the earliest to the latest dated reading, needing ≥ 1 day between them.
- Drift: new `care_reminders` table, schema **v3 → v4** (`createTable` on upgrade). The type is stored by name, so reordering the enum can't corrupt data, and unknown types are skipped. Rows outlive a deleted vehicle, like fill-ups, so Undo works.
- `DriftCareRepository`; failures → `FailureCode.careSaveFailed`, with EN/BN text.
- Tests:
  - `test/features/care/care_domain_test.dart`: 21 tests (bands and boundaries, time of day, progress, km-only / both, estimates, mark-done, month clamping, presets per vehicle type, notices, urgency sort, odometer stats).
  - `care_data_test.dart`: 4 tests (round-trip, per-vehicle list/update/delete, unknown type skipped, failure code) plus a **real v3 → v4 upgrade test** (a database built from the v3 tables with `user_version = 3` keeps its settings and gains the new table).
  - Full suite **213 passed**; analyze clean.

### Batch 4.B — UI + EN/BN *(implemented, widget-tested; not yet checked on the Simulator)*
- `care_screen.dart`:
  - One screen per vehicle with an odometer line ("Odometer N km (from your history) · about N km per day", or a hint to log one).
  - Reminders grouped by band, each with a status line ("Overdue by 5 days", "Due in 12 days · 7 Dec 2026", "In 600 km (≈ date)") and a progress bar with a spoken percentage.
  - Empty state with **Add suggested reminders**; a disclaimer that preset intervals are only starting points.
  - Tile menu: **Mark done** (sheet: date + odometer prefilled from History; the SnackBar shows the next due point), Edit, Delete with Undo.
- `care_form_screen.dart`:
  - Type, name (required for Custom), due date (picker + clear), due odometer, repeat months / km (preset defaults on a new reminder), notice days (0/1/3/7/14/30), note. A date or a km is required.
  - Uses a `Column` instead of a lazy `ListView`, so fields scrolled off screen are still validated. A test caught this.
- Routes `/garage/care` and `/garage/care/edit`: root navigator, redirect to Garage when the route argument is missing.
- Garage card: new menu item **Care & reminders** (Edit/Delete unchanged) and an attention chip ("1 reminder needs attention") when anything is overdue or due soon.
- About 60 new `care*` strings in EN and BN (plurals for days and reminders).
- **Bug fix found by the new tests:** `Fmt.number(v, maxDecimals: 0)` stripped an integer's own trailing zeros (11900 → "119"). Zeros are now trimmed only after a decimal point. Output with decimals is unchanged; a unit test was added.
- Tests: `test/features/care/care_ui_test.dart`, 6 widget tests:
  - suggestions for a petrol car (no CNG retest)
  - Garage chip, then mark done rolls to 25 May 2027 / 16,900 km
  - delete + Undo
  - form validation, then a custom km reminder
  - preset repeat defaults
  - Bengali at 200 % text passes the tap-target, label and contrast guidelines

  Full suite **220 passed**; analyze clean.
- **Batch 4.B pushed:** `4056a3b`.

### Batch 4.C — local notifications *(implemented, unit-tested, iOS Simulator-checked)*
- Packages, pinned exactly and all at least 2 weeks old:
  - `flutter_local_notifications` 22.3.3 (23.x was under 2 weeks old and a new major)
  - `timezone` 0.11.2
  - `flutter_timezone` 5.1.1

  The lockfile only gained these packages; no existing dependency changed.
- `domain/reminder_notifier.dart`: `ReminderNotifier` interface (`requestPermission`, `sync`), `ScheduledCareNotice`, reserved ids 7000–7049 (`kMaxCareNotices = 50`, under iOS's limit of 64 pending notifications).
- `data/local_reminder_notifier.dart`:
  - Lazy setup (time zones, device zone via `flutter_timezone`, UTC fallback), no permission prompt at start-up.
  - `sync` is serialized, skips an unchanged list, cancels the reserved ids and schedules again with `inexactAllowWhileIdle`, so no exact-alarm permission is needed.
  - Never throws: when the plugin is missing or fails it logs and does nothing, and the in-app status stays the source of truth.
  - Debug builds log `Care reminders: N notification(s) scheduled`.
- `presentation/care_notifications.dart`:
  - Pure `buildCareSchedule`: soonest first, capped at 50, skips overdue / undated / past / deleted-vehicle reminders. Text is in the user's language, e.g. "Tax token · Axio" / "Due in 7 days · 7 Dec 2026"; for km-based dates it adds "(estimated from your driving)".
  - `careScheduleProvider` and `careSyncProvider`, watched by `FuelWiseApp`, so any change to reminders, vehicles, odometer or language re-syncs.
- Permission: asked **once, on the first save of a reminder with a due date or km**. Undated presets never prompt. The request is not awaited, so the form closes at once.
- Android:
  - `POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED`.
  - The plugin's scheduled and boot receivers.
  - Core-library desugaring (`desugar_jdk_libs` 2.1.4), as the plugin README requires.
- iOS: `UNUserNotificationCenter.current().delegate = self` in `AppDelegate`, so notices also show while the app is open.
- **Bug found on the Simulator, then fixed:** on iOS, `initialize()` returns *permission granted*, which is false until the user is asked, not *setup succeeded*. The first version treated `false` as "unavailable", so neither the prompt nor any scheduling ever happened, while unit tests with the fake notifier passed. Setup now counts as successful whenever `initialize` doesn't throw.
- **UI fix found on the Simulator:** the Garage attention chip clipped the Bengali label ("…মনোযোগ দর"). It is now an outlined button whose label wraps.
- Tests:
  - `care_notifications_test.dart`, 7 tests: schedule order, times, ids and English text; skipping rules; notify 0; km estimate + Bengali; the 50 cap; sync provider re-syncs on change; permission asked once; the real notifier doesn't throw without the plugin.
  - The UI tests now use `FakeReminderNotifier` and assert: undated presets don't prompt, the first dated save prompts once.
  - Full suite **227 passed**, analyze clean, domain coverage **94.7%**.
- **iOS Simulator (iPhone 17e, Bengali):**
  1. Added a vehicle; the Garage menu shows "যত্ন ও রিমাইন্ডার".
  2. Empty state, then "add suggested" adds 5 reminders (no CNG retest for petrol) with a Bengali SnackBar.
  3. Set Tax token to 30 Nov 2026: it moves to "শীঘ্রই করতে হবে · 5 দিন বাকি · 30 নভে 2026", and the Garage shows "1টি রিমাইন্ডারে মনোযোগ দরকার".
  4. The log shows `Care reminders: 1 notification(s) scheduled`: the 7-days-before notice was already in the past, so only the on-day one.
  5. The first dated save showed the iOS permission dialog; after Allow, the schedule was unchanged, so it was not rescheduled.
- **Not verified:**
  - a notification actually firing at 09:00 (needs real time passing on a device)
  - Android notification permission, delivery and reboot rescheduling (CI only builds the debug APK)
  - the Android channel name is English only (set once at creation; the notification text itself is localized)
- **Batch 4.C pushed:** `0763927`. CI run [45651331824](https://github.com/ZubayeerAlam/gas-Station-Finder-/actions/runs/45651331824) is **green**: generated code, analyze, tests, the coverage gate, the debug APK build (so the desugaring and manifest changes compile), and Cloud Functions tests. GitHub created no run for `4056a3b` (4.B); its code is included in and covered by this run.

## Phase 5 — Batch 5.A: Privacy & data, user data deletion (2026‑11‑27)
*(implemented, unit/widget-tested, callable emulator-tested; not deployed, not run on a device)*
- **Server (`functions/src/account.ts`, `index.ts`):**
  - New callable `deleteMyData` (europe-west1, sign-in required). It deletes only the caller's price reports, votes, alert rules + alert log, assistant sessions + quota, and `users/{uid}` (recursive), then deletes the Auth user. Only counts are logged, never content.
  - Votes are stored at `stations/{id}/verifications/{uid}`, so `onVerificationWritten` now also records `users/{uid}.votedStations` (arrayUnion) to find them.
- **Client (`lib/features/account/`):**
  - `CommunityAccount` / `LocalDataStore` interfaces.
  - `FirebaseCommunityAccount`: calls the callable, then signs out. With no signed-in user there is nothing to delete.
  - `DriftLocalDataStore` → `AppDatabase.wipeAll()`: one transaction over every table.
  - `PrivacyScreen` at `/garage/privacy`, opened from a shield icon in the Garage app bar. Two cards (device / community), each delete behind a confirm dialog; results in a SnackBar; `FailureCode.dataDeletionFailed` with EN/BN text.
  - Wiping the device also clears the care notifications, because the sync provider sees the empty data.
- **Privacy policy** now describes in-app deletion.
- **Tests:**
  - `test/features/account/account_test.dart`, 7 tests: `wipeAll` empties every table; wipe cancels care notifications; summary parsing; device delete cancel/confirm; online delete success ("3 items deleted online") and failure; community off; Bengali at 200% text with accessibility guidelines.
  - Emulator: "deleteMyData callable: removes only the caller's data and account". A second user's data is untouched.
  - Flutter **234 passed**, analyze clean, domain coverage **94.8%**. Functions: unit 19, rules 7, assistant 7, integration 6, all passed.
- **Known limitations:**
  - Firestore's offline cache on the phone is not cleared by "delete online data".
  - Station price aggregates keep the user's contribution until their 72 h TTL; they hold no user ID.
  - Votes made before this version have no `votedStations` record, so they are not found. Nothing is deployed yet, so no real user has any.
  - A report upload still in flight could recreate `users/{uid}` (trust score) just after deletion.
  - `FirebaseCommunityAccount` itself has no unit test (no Firebase Auth mock); the callable it calls is emulator-tested.
- **Needs your approval:** deploying `deleteMyData` and the updated `onVerificationWritten` (`firebase deploy --only functions`). Not done.
- **Pending physical-device verification:** see PLAN.md, "Pending physical-device verification". Deferred by the user; development continues.

## Phase 5 — Batch 5.B: assistant on the Gemini API free tier (2026‑11‑27)
*(implemented, unit + emulator-tested with fakes; no live Gemini call yet (no key); not deployed)*
- **Why:** the user prefers a free-tier model to a paid API. Checked on Google's official docs on 2026‑11‑27 (ai.google.dev now redirects to aistudio.google.com/docs):
  - Stable text models: `gemini-3.8-flash`, `gemini-3.6-flash`, `gemini-3.5-flash-lite`, `gemini-3.1-flash-lite`. Free tier is "Free of charge" for 3.8-flash, 3.6-flash and 3.5-flash-lite. `gemini-2.5-flash` / `2.5-pro` are deprecated (rerouted on 1 Dec 2026), so they are avoided.
  - On the free tier Google says content is **used to improve its products**; the privacy policy now says so.
  - Bangladesh is in the supported-regions list.
  - The docs give **no free-tier RPM/RPD numbers** for text models ("view in Google AI Studio"); limits are per project and reset at midnight Pacific. Not verified here: the actual quota for the chosen model.
- **Default model:** `gemini-3.8-flash`, the newest stable Flash on the free tier, picked for reliable multi-step tool calling. If its free quota is too small, set `GEMINI_MODEL=gemini-3.5-flash-lite` with no code change.
- **Design** (`functions/src/`):
  - `assistant.ts` stays provider-neutral: `ModelClient` now carries `modelId`, and the session stores the model actually used. New `ModelQuotaError` maps to `resource-exhausted` "free daily limit". There is **never an automatic switch** to another or paid model.
  - `gemini_model.ts`: translates the Messages shape ↔ `generateContent` REST.
    - Tools become `functionDeclarations`, `additionalProperties` is stripped, `toolConfig` AUTO.
    - `tool_use` / `tool_result` become `functionCall` / `functionResponse` (by id + name).
    - Gemini `thoughtSignature`s are kept on the stored blocks and sent back.
    - Thought parts are dropped; SAFETY / blocked becomes a refusal, MAX_TOKENS becomes a cut-short reply.
    - The key goes only in the `x-goog-api-key` header; the model id is validated; HTTP errors carry the status only.
  - `claude_model.ts`: the previous Claude client as an optional adapter (not bound).
  - `index.ts`: binds `GEMINI_API_KEY` (secret) and `GEMINI_MODEL` (param, default above). Without a key the emulator keeps the labelled offline demo.
  - Unchanged and still enforced: sign-in required, input validation, 20/h + 100/day per-user limits, 6 model calls and 4096 output tokens per request, 20 turns per session, server-only session storage.
- **App:** demo label "Offline demo, not the AI" (EN/BN); comments and README now name Gemini.
- **Tests:** `test/unit/gemini_model.test.ts`, 6 tests: schema stripping; request shape; history translation with signatures; response mapping and stop reasons; key only in the header; 429 → quota error and bad model ids rejected. Emulator: a quota error gives `resource-exhausted`. Functions unit 25, rules 7, assistant 8, integration 6, all passed; Flutter 234 passed, analyze clean.
- **Not verified:** a real Gemini response (no key yet), so the request shape is checked only against the documented format, not the live API; free-tier quota numbers; answer quality in Bengali.
- **Needs your approval:** creating the `GEMINI_API_KEY` secret in Secret Manager and deploying the function.

## Phase 5 — Batch 5.C: export fill-up history as CSV (2026‑11‑27)
*(implemented, unit + widget-tested, iOS Simulator-checked; not run on Android)*
- **Why:** drivers want their fuel log in a spreadsheet (tax, reimbursement, fleet owners), and the data is theirs to take out.
- **Package:** `share_plus` **13.3.1**, pinned; released 2026‑10‑01, so more than 2 weeks old. The lockfile only gained packages (`share_plus`, its platform interface, `cross_file`, `url_launcher_*`); no existing version changed.
- `domain/fill_up_csv.dart`, pure:
  - Columns `date, vehicle, amount, unit, total_cost, currency, unit_price, odometer_km, full_fill, station`, oldest first.
  - The same machine-readable format in both languages: `.` decimals, `yyyy-MM-dd HH:mm`.
  - RFC 4180 quoting, CRLF line endings, and a UTF-8 BOM so Excel shows Bengali correctly.
  - **CSV formula injection is defused:** a text cell starting with `= + - @`, tab or CR gets a `'` prefix.
  - File name `fuelwise_<ascii-slug>_<date>.csv`, so a vehicle name can't change the path.
- `data/share_history_exporter.dart`: `HistoryExporter` interface. `ShareHistoryExporter` writes to the temp folder and opens the system share sheet, with an iPad popover anchor. It never throws; failures become `FailureCode.exportFailed` (EN/BN). Nothing leaves the phone unless the user picks a destination.
- **UI:** share icon in the History app bar, tooltip "Export as CSV" / "CSV হিসেবে এক্সপোর্ট করুন". Shown only when there are entries.
- **Tests:**
  - `fill_up_csv_test.dart`, 5 tests: format, EV + Bengali, quoting + injection, empty, file-name slug.
  - History widget tests, 4 new: no button when empty, the exported content and name, translated failure, and the real exporter returns an error without the platform.
  - Flutter **243 passed**, analyze clean, domain coverage **95.0%**.
- **iOS Simulator (iPhone 17e, Bengali):**
  1. Empty history shows no export icon.
  2. Added 20 L / BDT 250 at "Meghna,"; the icon appeared.
  3. Tapping it opened the iOS share sheet: "FuelWise ইতিহাস: Axio · CSV · 146 bytes", with Save to Files.
  4. The written file (read from the app container) had the BOM, CRLF and `"Meghna,"` quoted.
- **Not verified:** Android share sheet; opening the file in Excel or Google Sheets.

