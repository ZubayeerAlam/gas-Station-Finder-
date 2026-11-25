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

### Awaiting a Firebase project (no deploy / billing authorised)
- [ ] `FIREBASE_MODE=project` with real client options; enable Anonymous auth
- [ ] Deploy rules, indexes and functions (user's explicit OK only)
- [ ] FCM + APNs for alert push

### Awaiting new Google Maps API key
- [ ] Live Places nearby/details verification (iOS + Android)
- [ ] Map tiles render (Maps SDK)
- [ ] Real-response coverage notes for fuel prices / EV data

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
- [x] Destination selection — Places Autocomplete (New) with debounce + session tokens *(mocked; live call reaches Google → 403 until key)*
- [x] OSRM route + GeoJSON geometry *(live-verified)*
- [x] Route pieces instead of point sampling — route split into ≤ 4 pieces, each simplified (Douglas–Peucker) and encoded
- [x] Corridor search — Places Text Search `searchAlongRouteParameters` per piece + 5 km corridor filter (point-to-polyline projection) *(mocked)*
- [x] Deduplicate stations (by place id across pieces)
- [x] Detour via one OSRM `/table` request: to + from − direct *(live-verified)*; straight-line fallback flagged as approximate
- [x] Map + ranked list display (route polyline, top-3 markers, draggable sheet)
- [ ] Route alternatives
- [-] Request batching + caching + failure handling — table batching, details cache (10 min), partial-failure tolerance done; persistent cache in Phase 3

### 1.3 True Trip Cost Ranking
- [x] Fuel formula: fuel cost + detour fuel cost (unit-safe) — `TripCostEngine`, unit-tested
- [x] EV formula: kWh/km, charge energy, price/kWh, detour energy (+ charging efficiency)
- [x] Handle unknown price / consumption (never invent prices)
- [x] Ranking explanations — expandable "why" per station (purchase, detour energy, total, savings, price source, caveats)
- [x] "Save $X vs nearest" from real calculated values (domain)
- [x] Unit tests verifying the math (22 tests, hand-computed)

### 1.4 Smart Route Optimization
- [x] Cheapest / Least detour / Best value strategies (re-ranked locally, no new requests)
- [-] Compare time, distance, cost, detours, total trip cost — per-station detour km + min, total cost; trip-level comparison of route alternatives pending
- [x] User strategy selection (segmented button) + fill-level slider
- [x] Honest "heuristic" labelling (Best value documented; approximate detours flagged)

### 1.5 Crowdsourced Live Fuel Prices
- [-] Firebase Auth — anonymous sign-in on first community use (verified on iOS simulator against the Auth emulator); Google sign-in not done
- [x] Firestore model: top-level `priceReports` (append-only) → `stations/{id}/prices/{fuel}` aggregates (function-written)
- [-] Submit report (fuel type, price, currency; server timestamp) + live server verdict (accepted / outlier / duplicate / rate-limited) — widget-tested; on-device blocked because stations come from Places (key 403)
- [ ] Upvote / flag reports (replaced for now by outlier rejection + open/closed/out-of-fuel votes)
- [x] Reporter reputation — Laplace trust (accepted+1)/(accepted+rejected+2); corroborated (±3 %, ≥ 2 reports) raises, outliers lower
- [x] Cloud Function (TS) aggregation: TTL 72 h, majority currency (no conversion), leave-one-out outlier test (> 15 %), weighted median (trust × recency half-life 12 h), confidence
- [x] Stale price expiry (72 h TTL, `expiresAt` on aggregate)
- [x] Spam / duplicate protection — rules (own uid, server time, value ranges, field whitelist) + function rate limits (10/h, 1 per station+fuel per 10 min)
- [x] Emulator-tested (rules tests + real triggers in Functions emulator, `demo-fuelwise`, nothing deployed)

### 1.6 Price History & Analytics
- [-] 7-day / 30-day trends (fl_chart: consensus close line + daily min–max band, single currency) — widget-tested, not seen on device (needs Places stations)
- [ ] Station and fuel-type comparisons
- [-] Verified vs unverified distinction — community prices labelled with report count, age, "outdated" after TTL; Google prices labelled Google

### 1.7 Station Reliability Score
- [x] Score = mean of known components: price freshness exp(−age/72 h) + open/closed vote agreement (30-day votes); unknown stays null
- [-] UI indicator (bar + % + plain-language band, vote counts, "not an official check") — widget-tested; on-device needs Places stations
- [x] Fed into ranking: `StationOffer.reliability` (Best value uses it) via `CombinedQuoteLookup`

### 1.8 EV Mode
- [x] Fuel/EV toggle (defaults to active vehicle type; only the active mode's API is queried)
- [x] Open Charge Map integration *(fixture-tested; needs free `OCM_API_KEY` — API returns 403 without one)*
- [x] Places `evChargeOptions` data (details sheet, Phase 0) + EV along-route search uses `electric_vehicle_charging_station`
- [x] Connectors, kW, AC/DC, quantity, operational status, last verified/status-update dates (community data labelled)
- [-] Charging cost estimate — OCM free-text cost shown verbatim, never parsed; community `EV_KWH` prices now feed EV along-route ranking (unit-tested); OCM chargers have OCM ids, so community reports for them are not wired yet
- [-] Route-based charger discovery — via Places along route (1.D); OCM along-route not implemented
- [x] Marker clustering (google_maps_flutter `ClusterManager`, fuel + EV)
- [-] Custom markers with price/kW — kW pill markers (fast / slow / not operational colours) done; fuel price markers need prices (1.5)
- [x] Client-side filters: min power (Any/22/50/150 kW), connector types present nearby, operational only

### 1.9 My Garage
- [x] Multiple vehicles (name, fuel/energy type, tank/battery, consumption in 7 units, preferred fuel, EV charging efficiency) — drift (SQLite) persistence, active vehicle, edit/delete + undo
- [-] Range, trip cost, required fuel/energy, reachable stations — full-tank range shown in Garage; trip cost/reachability wired into along-route UI later (1.2)
- [ ] Make/model picker (free-text name only for now)

### 1.10 Fill-up & Trip History
- [x] Record fill-ups / charging sessions (date, amount, cost, currency, odometer, full/partial, station) — drift, delete + undo
- [ ] Trip history (needs along-route trips, 1.2)
- [x] Monthly summaries (per currency, never converted), full-to-full consumption trend, cost per km, per-vehicle charts (fl_chart)
- [ ] Daily summaries / exportable reports

### 1.11 Price Alerts
- [x] Threshold alerts by fuel type, currency, radius around current location (station-specific supported by backend, no UI yet) — created on iOS simulator, matched server-side
- [x] Enable/disable + delete alerts (iOS simulator → Firestore emulator verified)
- [ ] FCM token registration + push delivery (needs a real Firebase project + APNs key)
- [x] Cloud Function + FCM (event-driven on consensus change, no polling schedule), 12 h cooldown per rule+station via transaction; emulator logs instead of FCM
- [x] Locally tested — app-created rule matched a report in the Functions emulator, cooldown claim written (no push: no FCM token)

### 1.12 Community Station Verification
- [-] Open/closed + out-of-fuel votes (one private vote per user, 30-day window) — widget-tested; closures / EV connector status / facilities not done
- [ ] Trust scoring, expiry, moderation

### Phase 1 Acceptance
- [ ] Nearby + destination route search work
- [x] Along-route discovery + tested detours (detours live-verified via OSRM; Places search mocked)
- [ ] Cost ranking mathematically verified
- [-] Price reports submit/retrieve; aggregation verified in Emulator Suite (backend + client mapping; client submit widget-tested only)
- [ ] EV discovery works with supported data
- [x] Garage + expenses work (widget/unit-tested; on-device: DB + tabs render on iOS simulator)
- [x] Alerts tested locally (iOS simulator + Firebase Emulator Suite)
- [ ] No fabricated live-data claims

---

## Phase 2 — AI Trip Assistant (Week 5)
- [x] Natural-language text chat UI (`/assistant`, sparkle button on the Map) — simulator-tested; voice not started (optional)
- [-] Cloud Function (TS) `assistantChat` calling the Claude API via `@anthropic-ai/sdk`, key only in Secret Manager / `functions/.secret.local` — implemented and tested with a scripted fake model + the emulator's labelled offline demo; **no live Claude call yet (no `ANTHROPIC_API_KEY`), not deployed**
- [x] Verify exact Haiku model ID before use — `claude-haiku-5-5`, checked against the installed SDK 1.14 model list
- [x] Tools (names adapted, same intent): `plan_route_stops` (= search stations along route, runs the app's own planner + `TripCostEngine` on the device), `get_community_prices` (= get prices, server, Firestore), `get_vehicle` (device garage), `show_station_cards` (display only)
- [x] Structured responses → tappable station cards (reuses the trip screen's `StationResultCard`: price + source, detour, total cost, savings, reliability, open status, "Show on map" opens the trip)
- [x] Auth (anonymous OK), input validation, per-user rate limits (20/h, 100/day), tool allow-list, token cap (4096/call, 6 calls/request, 20 turns/session), 60 s model timeout + typed failure mapping, refusal / max_tokens handling
- [-] Acceptance: AI results match the ranking algorithm — guaranteed structurally and tested (every figure comes from the app's engine; cards show only ids from the app's own plan) · live Claude wording not verified (no key)
- [x] Acceptance: credentials never in client — key is a function secret; the app only sends text + tool results

### Awaiting an Anthropic API key (no paid service authorised)
- [ ] Put `ANTHROPIC_API_KEY` in `functions/.secret.local` (gitignored) and run one live emulator conversation
- [ ] Check Claude's answers against the trip screen's ranking on a real route (needs the new Google key too)

## Phase 3 — Production Quality, Offline & Release (Week 6+)

### 3.1 Offline-first
- [x] Evaluate Isar vs Hive → chose **drift** (SQLite; actively maintained, typed queries, migrations, testable in-memory) — see BUILD.md 1.B
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
- [x] Firestore Security Rules + automated rules tests (6 groups)
- [ ] App Check
- [x] Cloud Functions input validation + rate limiting (triggers only; no callable endpoints)
- [ ] Spam / fake-report protection, abuse prevention
- [ ] User data deletion
- [ ] Secure key management + API quota monitoring
- [ ] Crash recovery / error handling
- [ ] Privacy-conscious analytics
- [ ] Backend cost monitoring
- [ ] Everything emulator-tested before any deploy request
