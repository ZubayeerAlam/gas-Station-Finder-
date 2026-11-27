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
- [x] Map + list views — list view added in 5.D.1 (see Phase 5)
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
- [x] Route alternatives — done in 5.D.2 (see Phase 5)
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
- [-] Compare time, distance, cost, detours, total trip cost — per-station detour km + min, total cost; route alternatives now show ≈ litres/kWh and ≈ cost at the user's last fill-up price for the selected route (no price guessed without a fill-up) — unit + widget-tested
- [x] User strategy selection (segmented button) + fill-level slider
- [x] Honest "heuristic" labelling (Best value documented; approximate detours flagged)

### 1.5 Crowdsourced Live Fuel Prices
- [-] Firebase Auth — anonymous sign-in on first community use (verified on iOS simulator against the Auth emulator); Google sign-in not done
- [x] Firestore model: top-level `priceReports` (append-only) → `stations/{id}/prices/{fuel}` aggregates (function-written)
- [-] Submit report (fuel type, price, currency; server timestamp) + live server verdict (accepted / outlier / duplicate / rate-limited) — widget-tested; on-device blocked because stations come from Places (key 403)
- [x] Flag reports: "This price looks wrong" per station + fuel (one private flag per user, undo); 3 distinct users since the last report → price shown as **disputed** and dropped from ranking until a new report replaces it — rules + unit + emulator-tested, widget-tested, **not deployed**
- [x] Reporter reputation — Laplace trust (accepted+1)/(accepted+rejected+2); corroborated (±3 %, ≥ 2 reports) raises, outliers lower
- [x] Cloud Function (TS) aggregation: TTL 72 h, majority currency (no conversion), leave-one-out outlier test (> 15 %), weighted median (trust × recency half-life 12 h), confidence
- [x] Stale price expiry (72 h TTL, `expiresAt` on aggregate)
- [x] Spam / duplicate protection — rules (own uid, server time, value ranges, field whitelist) + function rate limits (10/h, 1 per station+fuel per 10 min)
- [x] Emulator-tested (rules tests + real triggers in Functions emulator, `demo-fuelwise`, nothing deployed)

### 1.6 Price History & Analytics
- [-] 7-day / 30-day trends (fl_chart: consensus close line + daily min–max band, single currency) — widget-tested, not seen on device (needs Places stations)
- [-] Station and fuel-type comparisons — nearby list "Cheapest" sort compares stations for the active vehicle's fuel (Google price, else fresh community consensus; one currency only; no-price stations last; lookups only when chosen) — unit + widget-tested, **not seen live** (needs the new Google key); per-station all-fuel prices are in the details sheet; cross-fuel comparison for dual-fuel vehicles done (Garage → Compare fuel costs, see 1.9)
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
- [-] Route-based charger discovery — via Places along route (1.D) and, for EVs, Open Charge Map along the route: up to 8 radius searches that cover a 5 km corridor, exact corridor filter, ordered by distance along the route, partial-failure notice — fixture-tested (unit + widget, Bengali 200 %); **no live OCM call yet (no `OCM_API_KEY`)**
- [x] Marker clustering (google_maps_flutter `ClusterManager`, fuel + EV)
- [-] Custom markers with price/kW — kW pill markers (fast / slow / not operational colours) done; fuel price markers need prices (1.5)
- [x] Client-side filters: min power (Any/22/50/150 kW), connector types present nearby, operational only

### 1.9 My Garage
- [x] Multiple vehicles (name, fuel/energy type, tank/battery, consumption in 7 units, preferred fuel, EV charging efficiency) — drift (SQLite) persistence, active vehicle, edit/delete + undo
- [-] Range, trip cost, required fuel/energy, reachable stations — full-tank range shown in Garage; trip cost/reachability wired into along-route UI later (1.2)
- [x] Dual-fuel vehicles (e.g. petrol converted to CNG): optional second fuel + km per L/m³ on the form (drift v6, upgrade keeps existing vehicles); Garage → "Compare fuel costs": cost per 100 km on each fuel from prices the user types (never guessed), cheaper fuel, saving per 100 km and per month from odometer history — unit, migration and widget-tested (incl. Bengali 200 %); prices are not remembered between openings
- [x] Make/model picker: "Start from a common model" on the add-vehicle form — 20 common Bangladesh cars, motorbikes and EVs, searchable, fills name / fuel / tank or battery / consumption as editable *typical* values with a "not official figures" note — unit + widget-tested (incl. Bengali 200 %)

### 1.10 Fill-up & Trip History
- [x] Record fill-ups / charging sessions (date, amount, cost, currency, odometer, full/partial, station) — drift, delete + undo
- [x] Trip history → built as user-saved trips in 5.D.3 (a full log would store Google place data; see Phase 5)
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
- [x] Trust scoring, expiry, moderation — reporter trust + 72 h TTL (Phase 2) and community moderation via disputed prices (above); no human moderator queue (by design: no personal data to review)

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
- [-] Cloud Function (TS) `assistantChat`, provider-neutral loop. **Gemini API (free tier) is the default provider** since 5.B (`gemini_model.ts`, model `gemini-3.8-flash` via the `GEMINI_MODEL` param); Claude kept as an optional adapter. Key only in Secret Manager / `functions/.secret.local`. Tested with fakes + the emulator's labelled offline demo; **no live Gemini call yet (no `GEMINI_API_KEY`), not deployed**
- [x] Verify exact Haiku model ID before use — `claude-haiku-5-5`, checked against the installed SDK 1.14 model list
- [x] Tools (names adapted, same intent): `plan_route_stops` (= search stations along route, runs the app's own planner + `TripCostEngine` on the device), `get_community_prices` (= get prices, server, Firestore), `get_vehicle` (device garage), `show_station_cards` (display only)
- [x] Structured responses → tappable station cards (reuses the trip screen's `StationResultCard`: price + source, detour, total cost, savings, reliability, open status, "Show on map" opens the trip)
- [x] Auth (anonymous OK), input validation, per-user rate limits (20/h, 100/day), tool allow-list, token cap (4096/call, 6 calls/request, 20 turns/session), 60 s model timeout + typed failure mapping, refusal / max_tokens handling
- [-] Acceptance: AI results match the ranking algorithm — guaranteed structurally and tested (every figure comes from the app's engine; cards show only ids from the app's own plan) · live Claude wording not verified (no key)
- [x] Acceptance: credentials never in client — key is a function secret; the app only sends text + tool results

### Awaiting an Anthropic API key (no paid service authorised)
- [ ] Put `ANTHROPIC_API_KEY` in `functions/.secret.local` (gitignored) and run one live emulator conversation
- [ ] Check the AI's answers against the trip screen's ranking on a real route (needs the new Google key too)

## Phase 3 — Production Quality, Offline & Release (Week 6+)

### 3.1 Offline-first
- [x] Evaluate Isar vs Hive → chose **drift** (SQLite; actively maintained, typed queries, migrations, testable in-memory) — see BUILD.md 1.B
- [-] Cache stations, prices, vehicles, trip history — vehicles + fill-up history are local (drift); station **place IDs + coordinates** cached ≤ 30 days (all Google's Places policy allows — no names/addresses/prices stored); community data uses Firestore's built-in offline cache (not separately verified offline)
- [-] Last-updated + offline indicators; resync; stale ≠ verified — map shows "Offline · N saved station positions (age)" with Retry; prices are never shown from cache. Not verified on a device in airplane mode (needs a working Google key to fill the cache first)

### 3.2 Testing
- [x] Unit: cost, scoring, detour, trust, aggregation, range, repositories
- [x] Widget: details sheet, cards, route selection, Fuel/EV toggle, AI cards, states
- [-] Integration: price submit, alerts and AI callable run end-to-end against the emulators; nearby / destination / along-route / EV need live keys (fakes only so far); no `integration_test` device suite yet
- [x] ≥70% domain-layer coverage — **97.3 %** (431/443 lines, 16 domain files; generated code excluded; `tool/domain_coverage.py`, enforced in CI)
- [x] Functions tests + Firestore Rules tests (unit 19, rules 7, assistant 7, integration 5)

### 3.3 CI/CD
- [x] `.github/workflows/ci.yml`: deps, generated-code check, analyze, test, coverage gate, debug APK artifact; functions job with emulator tests
- [x] No automatic production deploys (CI has no deploy step and no secrets)

### 3.4 Accessibility & Localization
- [-] Semantics, text scaling, contrast, focus — automated guideline tests (tap targets, labelled targets, text contrast) at 200 % text on Garage, Assistant (EN + BN), History, fill-up form, vehicle form, Alerts (BN); found + fixed dropdown overflow at large text. Map/route/EV sheets (need live data) and keyboard focus order not audited yet
- [x] English + Bengali; extensible l10n — `flutter gen-l10n` (327 keys each, parity test-enforced) + language menu persisted in drift; every screen, error messages (via `FailureCode`), fuel/connector labels, ranking badges and explanations, relative times and month names. Units (km, L, kWh) and digits stay Latin by choice. Bengali wording drafted by Claude — native review pending

### 3.5 Monitoring
- [ ] Crashlytics, Analytics, Performance (privacy/consent respected)

### 3.6 Release
- [-] Icon, splash, screenshots, store listing — icon (flutter_launcher_icons) + native splash (flutter_native_splash, Android 12+/iOS/web) done; screenshots + listing need a working Google key and store accounts
- [-] Privacy policy, Data Safety form — draft `docs/privacy-policy.md` based on what the code actually sends; contact, retention and hosting are yours to fill; store forms not filled
- [-] Release build config + signing — Gradle reads gitignored `android/key.properties` (falls back to debug key); steps in `docs/RELEASE.md`; no keystore created, no release build signed
- [-] README with architecture diagram, GIFs, badges — README rewritten (features + honest status, Mermaid architecture, setup, tests, privacy, CI badge); screenshots/GIFs wait for a working Google key
- [ ] Play Store internal/closed test; iOS prep after

---

## Phase 4 — Vehicle Care Reminders (user-chosen, 2026‑11‑25)
Problem: expired BRTA documents (tax token, fitness, insurance, route permit) mean fines; an overdue CNG cylinder retest is a safety risk; oil/tyre service by km is easy to forget. Works offline, no keys, no paid services.
- [x] 4.A Domain: `CareReminder`, status by date / km / both (whichever first), km/day estimate, mark-done roll-forward, presets (CNG retest only for CNG, no oil change for EVs), notice times; `HistoryAnalytics.odometerStats`
- [x] 4.A Data: drift `care_reminders` (schema v4 + migration, upgrade-tested), `DriftCareRepository`, `FailureCode.careSaveFailed`
- [x] 4.B Care screen (grouped by urgency), add/edit form, mark-done sheet, Garage menu + badge, EN/BN
- [x] 4.C Local notifications (before + on the day, 09:00), permission on first save, Android/iOS setup
- [x] Simulator walkthrough (iOS: Bengali flow, permission prompt, scheduled count logged)
- [x] CI green for 4.C: run 45651331824 (`0763927`), including the Android debug APK build
- [ ] Not verifiable here: a notification actually firing at 09:00 on a device, Android reboot rescheduling, any Android run beyond the CI debug build

---

## Phase 5 — Ownership & everyday use (2026‑11‑27)
- [x] 5.A Privacy & data screen (Garage → shield icon): delete everything on this device; delete my community data and anonymous account (`deleteMyData` callable, emulator-tested, **not deployed**)
- [x] 5.B Assistant on the Gemini API free tier: adapter, configurable model, 429 → "free daily limit" (no paid fallback); unit + emulator-tested, **no live call yet (no key), not deployed**
- [x] 5.C Export fill-up history as CSV (History → share icon; system share sheet, Save to Files / Drive / email) — unit + widget-tested, iOS Simulator-checked
- [x] 5.D.1 Nearby list view (map ↔ list toggle in the status banner; stations nearest first; chargers nearest / fastest, out-of-service last) — unit + widget-tested; **live list not seen yet** (old Google key rejected, no OCM key)
- [x] 5.D.2 Route alternatives: up to 3 OSRM routes, fastest first; grey tappable alternatives on the map + chips ("+4 min · 12 km") in the route card — unit + widget-tested, live OSRM contract checked; map flow not seen live (needs a station → new Google key)
- [x] 5.D.3 Saved trips (renamed from "Trip history"): save a planned trip under your own label; one tap on the destination screen plans it again; delete + Undo; drift schema v5 (upgrade-tested). Places-terms-safe: no Google names/addresses stored, coordinates kept ≤ 30 days then re-looked-up by place ID — unit, repository, migration + widget-tested; **live Places re-lookup not seen yet** (no new Google key)

### Pending physical-device verification (deferred by the user, Moto G96 / Android 16)
Development continues without these; each stays unchecked until it is run on the phone.
- [ ] Care notification permission prompt, delivery at 09:00, and rescheduling after reboot
- [ ] Location permission + nearby stations on real GPS
- [ ] Maps / Places with the new restricted Google key (key not provided yet), including the nearby list view with real stations and route alternatives drawn on the real map
- [ ] Bengali layout and 200% text on the real screen
- [ ] CSV export share sheet on Android (only checked on the iOS Simulator)
- [ ] Saved trips on the phone: save, re-plan, re-lookup of a trip older than 30 days with the new Google key
- [ ] Privacy screen: delete device data, delete online data against a deployed backend (needs deploy approval)

---

## Cross-phase — Security, Reliability & Cost Management
- [x] Firestore Security Rules + automated rules tests (6 groups)
- [ ] App Check
- [x] Cloud Functions input validation + rate limiting (triggers only; no callable endpoints)
- [-] Spam / fake-report protection, abuse prevention — rules + function rate limits, outlier rejection and reporter reputation exist (Phase 2); App Check (above) is the missing piece
- [x] User data deletion: in-app, local + community (emulator-tested; callable not deployed)
- [ ] Secure key management + API quota monitoring
- [x] Crash recovery / error handling: global handlers (framework, uncaught async, failing providers) keep the app running and keep the last 20 errors in memory only (no crash service, nothing sent); release builds show a localized "this part could not be shown" card instead of a grey box; unknown paths get a localized "Page not found" with a way back — unit + widget-tested; release-mode fallback not seen on a device
- [ ] Privacy-conscious analytics
- [ ] Backend cost monitoring
- [ ] Everything emulator-tested before any deploy request
