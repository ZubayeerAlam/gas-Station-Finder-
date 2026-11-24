# FuelWise — Master Development Roadmap & Checklist

> *Find the cheapest fuel or EV charger along your route, not just near you.*

Legend: `[x]` completed **and verified** · `[-]` partially implemented / awaiting verification · `[ ]` not started
Implementation history and evidence live in [BUILD.md](BUILD.md). Rule: work one phase at a time; stop at phase end and wait for **"Let's proceed"**. No git commits/pushes, Firebase deploys, or billing without explicit approval.

---

## Phase 0 — Foundation, Security & Architecture (Week 1)

### 0.0 Assessment
- [x] Inspect repository, dependencies, architecture, working features, security risks, duplicates

### 0.1 Security
- [x] Remove hardcoded Google API keys from source (Dart, AndroidManifest, AppDelegate)
- [x] Keys via `--dart-define-from-file` (`config/dev.json`, gitignored; `config/example.json` committed)
- [x] Android key via dart-defines → `manifestPlaceholders` (local.properties abandoned: Flutter rewrites it)
- [x] iOS key via gitignored `ios/Flutter/Secrets.xcconfig` → Info.plist `GMSApiKey`
- [x] Places (New) app-restriction headers (`X-Android-Package`/`X-Android-Cert`, `X-Ios-Bundle-Identifier`)
- [x] HTTPS for all requests incl. OSRM
- [-] **(User)** Rotate exposed key — user changed Console settings; key in project still 403 (see BUILD.md). Rotate exposed key (it is in git history) and apply Android/iOS + API restrictions
- [ ] Firebase App Check (blocked until a Firebase project exists — `flutterfire configure`)
- [x] Document client-key vs server-secret distinction (`lib/core/config/app_config.dart`, BUILD.md)

### 0.2 Clean Architecture
- [-] Feature-first structure — `stations` and `route` done; other feature folders created when their features start (no empty placeholders)
- [x] `lib/core/{config,network,error,router,theme,location,utils,widgets}`
- [x] Riverpod state management (no Provider/BLoC/GetX/ChangeNotifier app state)
- [x] go_router navigation
- [-] Freezed immutable entities (json_serializable kept for Firestore models in Phase 1)
- [x] Repository pattern + DI via providers; MVVM controllers

### 0.3 Codebase Cleanup
- [x] snake_case file names
- [x] Remove duplicates `lib/MyApp.dart`, `lib/Screen/homeScreen.dart`
- [x] Split `locationProvider.dart` into feature notifiers
- [x] Move `home_screen.dart` into stations feature (`map_screen.dart`)
- [x] Refactor repositories
- [x] Remove unused deps (`provider`, `http`, `permission_handler`); `flutter_lints` → dev
- [x] Replace broken default counter test
- [-] Preserve working functionality — ported & widget-tested; live Places data blocked by key (see BUILD.md)

### 0.4 Networking
- [x] Dio client with timeouts
- [x] Interceptors (request/response)
- [x] Controlled retries for transient failures
- [x] Typed `AppFailure` + `Result` type
- [x] Logging without secrets

### 0.5 Google Places API (New)
- [-] Nearby search (`places:searchNearby`, `gas_station`) — implemented + unit-tested; live call 403 (key)
- [-] Place details (address, phone, rating, opening hours) — implemented + tested with fixtures; not live-verified
- [x] `fuelOptions.fuelPrices` parsing (nullable) — fixture-tested
- [x] `evChargeOptions` parsing (nullable) — fixture-tested
- [x] Minimal field masks (search = Pro fields, details = on tap)
- [ ] Verify country coverage / billing / field availability (documented)

### 0.6 UI Foundation
- [x] Material 3 light + dark themes, design tokens
- [x] Reusable loading / empty / error / permission components
- [x] FuelWise app name (Android label + iOS display name)
- [x] Application ID / bundle ID → `com.fuelwise.app` (emulator + simulator verified)
- [x] App icon (`tool/make_icon.swift` + flutter_launcher_icons; adaptive Android icon verified on emulator)

### Phase 0 Acceptance
- [x] `flutter analyze` clean
- [-] Tests pass (46/46 after batch 0.B; final run at phase end)
- [x] No hardcoded credentials in tracked source (key remains in git history → rotate)
- [x] HTTPS networking works (OSRM live-verified; Places reachable, rejected 403 by key)
- [x] App launches on iOS Simulator and Android emulator (`fuelwise-api33`)
- [ ] Existing features work after migration

---

## Phase 1 — Core Product & Signature Features (Weeks 2–4)

### 1.1 Nearby Fuel Stations
- [ ] Map + list views
- [ ] Details sheet: opening hours, ratings, fuel types, prices
- [ ] Loading / empty / error / permission states

### 1.2 Stations Along My Route ⭐
- [ ] Destination selection (search/autocomplete)
- [ ] OSRM route + polyline decode
- [ ] Sample points along route
- [ ] Corridor search (configurable width)
- [ ] Deduplicate stations
- [ ] Detour via OSRM route/table
- [ ] Map + ranked list display
- [ ] Route alternatives
- [ ] Request batching + caching + failure handling

### 1.3 True Trip Cost Ranking
- [ ] Fuel formula: fuel cost + detour fuel cost (unit-safe)
- [ ] EV formula: kWh/km, charge energy, price/kWh, detour energy
- [ ] Handle unknown price / consumption (never invent prices)
- [ ] Ranking explanations (cheapest, best value, shortest detour, most reliable, open)
- [ ] "Save $X vs nearest" from real calculated values
- [ ] Unit tests verifying the math

### 1.4 Smart Route Optimization
- [ ] Fastest / Cheapest-Fuel / Best-Overall strategies
- [ ] Compare time, distance, cost, detours, total trip cost
- [ ] User strategy selection
- [ ] Honest "heuristic" labelling

### 1.5 Crowdsourced Live Fuel Prices
- [ ] Firebase Auth (Google / anonymous)
- [ ] Firestore `stations/{stationId}/priceReports/{reportId}`
- [ ] Submit report (fuel type, price, timestamp)
- [ ] Upvote / flag reports
- [ ] Reporter reputation
- [ ] Cloud Function (TS) aggregation + trust score (recency, reputation, verification, consistency, suspicious activity)
- [ ] Stale price expiry
- [ ] Spam / duplicate / manipulation protection
- [ ] Emulator-tested

### 1.6 Price History & Analytics
- [ ] 7-day / 30-day trends (fl_chart)
- [ ] Station and fuel-type comparisons
- [ ] Verified vs unverified distinction

### 1.7 Station Reliability Score
- [ ] Score from verified reports, reporter count, consistency, accuracy, flags, freshness
- [ ] UI indicator (not presented as certification)

### 1.8 EV Mode
- [ ] Fuel/EV toggle
- [ ] Open Charge Map integration
- [ ] Places `evChargeOptions` data
- [ ] Connectors, kW, availability (reported vs verified)
- [ ] Charging cost estimate
- [ ] Route-based charger discovery
- [ ] Marker clustering
- [ ] Custom markers with price/kW

### 1.9 My Garage
- [ ] Multiple vehicles (name, make/model, fuel/energy type, tank/battery, consumption, preferred fuel)
- [ ] Range, trip cost, required fuel/energy, reachable stations

### 1.10 Fill-up & Trip History
- [ ] Record fill-ups / charging sessions
- [ ] Trip history
- [ ] Daily/monthly summaries, consumption trends, per-vehicle reports, charts

### 1.11 Price Alerts
- [ ] Threshold alerts by fuel type, radius, saved location, station
- [ ] Enable/disable alerts
- [ ] Cloud Function + FCM, duplicate prevention, cost-controlled scheduling
- [ ] Locally tested

### 1.12 Community Station Verification
- [ ] Open/closed, fuel availability, out-of-stock, closures, EV connector status, facilities
- [ ] Trust scoring, expiry, moderation

### Phase 1 Acceptance
- [ ] Nearby + destination route search work
- [ ] Along-route discovery + tested detours
- [ ] Cost ranking mathematically verified
- [ ] Price reports submit/retrieve; aggregation verified in Emulator Suite
- [ ] EV discovery works with supported data
- [ ] Garage + expenses work
- [ ] Alerts tested locally
- [ ] No fabricated live-data claims

---

## Phase 2 — AI Trip Assistant (Week 5)
- [ ] Natural-language text chat UI (voice optional)
- [ ] Cloud Function (TS) calling Claude API, key server-side only
- [ ] Verify exact Haiku model ID before use
- [ ] Tools: `search_stations_along_route`, `get_prices`, `get_vehicle` (reuse backend logic)
- [ ] Structured responses → tappable station cards (price, detour, savings, reliability, open status, navigate)
- [ ] Auth, input validation, rate limits, tool allow-list, token limits, timeout/failure handling
- [ ] Acceptance: AI results match the ranking algorithm; credentials never in client

---

## Phase 3 — Production Quality, Offline & Release (Week 6+)

### 3.1 Offline-first
- [ ] Evaluate Isar vs Hive (maintenance/compat)
- [ ] Cache stations, prices, vehicles, trip history
- [ ] Last-updated + offline indicators; resync; stale ≠ verified

### 3.2 Testing
- [ ] Unit: cost, scoring, detour, trust, aggregation, range, repositories
- [ ] Widget: details sheet, cards, route selection, Fuel/EV toggle, AI cards, states
- [ ] Integration: nearby, destination, route, along-route, price submit, EV, AI
- [ ] ≥70% domain-layer coverage
- [ ] Functions tests + Firestore Rules tests

### 3.3 CI/CD
- [ ] `.github/workflows/ci.yml`: deps, analyze, test, coverage, APK build
- [ ] No automatic production deploys

### 3.4 Accessibility & Localization
- [ ] Semantics, text scaling, contrast, focus
- [ ] English + Bengali; extensible l10n

### 3.5 Monitoring
- [ ] Crashlytics, Analytics, Performance (privacy/consent respected)

### 3.6 Release
- [ ] Icon, splash, screenshots, store listing
- [ ] Privacy policy, Data Safety form
- [ ] Release build config + signing
- [ ] README with architecture diagram, GIFs, badges
- [ ] Play Store internal/closed test; iOS prep after

---

## Cross-phase — Security, Reliability & Cost Management
- [ ] Firestore Security Rules + automated rules tests
- [ ] App Check
- [ ] Cloud Functions authn/authz + input validation + rate limiting
- [ ] Spam / fake-report protection, abuse prevention
- [ ] User data deletion
- [ ] Secure key management + API quota monitoring
- [ ] Crash recovery / error handling
- [ ] Privacy-conscious analytics
- [ ] Backend cost monitoring
- [ ] Everything emulator-tested before any deploy request
