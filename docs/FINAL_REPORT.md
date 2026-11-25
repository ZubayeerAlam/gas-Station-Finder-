# FuelWise: final development report

*2026-11-25 · covers Phases 0–3 of the Master Development Plan · item-level status lives in [PLAN.md](../PLAN.md) and the evidence for each item in [BUILD.md](../BUILD.md)*

## 1. Summary
FuelWise is built as far as it can go without your keys, a Firebase project and store accounts. Most code is covered by unit, widget and emulator tests. **None of the external data sources has been seen working live:**
- The Google key returns 403.
- No Open Charge Map key has been set.
- No Anthropic key has been set.
- No Firebase project exists.

The app is **not production-ready**. Section 9 explains why and what it would take.

## 2. Completed phases
| Phase | What was built | How it was verified |
|---|---|---|
| **0 Foundation** | Clean Architecture (feature folders: domain / data / presentation), Riverpod, go_router, dio with retry and redacted logging, typed `AppFailure`/`Result`, Places API (New) client, OSRM routing, app renamed to `com.fuelwise.app`, icon, Material 3 theme | Unit and widget tests; iOS Simulator (UI, permissions, error states) |
| **1 Core features** | True trip-cost ranking engine (Cheapest / Least detour / Best value), My Garage (drift), fill-up and charging history with charts, stations along a route with real detours, EV mode (Open Charge Map, filters, kW markers, clustering), crowdsourced prices (trust scoring, outlier rejection, history, reliability votes, price alerts) | Unit and widget tests; Firebase emulator tests for prices; Simulator for garage and history |
| **2 AI trip assistant** | `assistantChat` Cloud Function running a Claude tool-use loop. The Anthropic key exists only on the server. Every figure the assistant shows comes from the app's own ranking engine. Results appear as tappable station cards, with a per-user quota and stored sessions. | Unit tests, emulator tests and Simulator end to end, using a clearly labelled **offline demo model**, not Claude |
| **3 Production readiness** | Offline cache of station positions (limited to what Google's Places policy allows), GitHub Actions CI with a coverage gate, full English + Bengali UI including error messages, accessibility tests at 200% text, native splash screen, release-signing setup, draft privacy policy, release checklist, README | 188 tests; CI green on GitHub; Simulator check in Bengali |

**Not done** (open items are listed in [PLAN.md](../PLAN.md)):
- Monitoring (Crashlytics, Analytics) and push notifications: these need a Firebase project.
- App Check.
- Data deletion inside the app.
- Make/model picker.
- Trip history.
- Exportable reports.
- Moderation tools.
- An `integration_test` suite that runs on a device.

## 3. Features waiting for a working Google Maps key
- Map tiles (Maps SDK) and live **nearby stations** (Places `searchNearby`). The live call currently returns **403**.
- **Station details**: hours, rating and Google fuel prices. So far these are tested only with recorded sample responses.
- **Destination search** and **stations along a route**.
- **Offline cache**: it can only fill once live results exist, so it has not been tested on a device.
- **Community prices on real stations** and the **AI assistant on real routes** (its tools use Places).
- **Store screenshots and README GIFs**.

**Also needed:** a free Open Charge Map key (`OCM_API_KEY`) for EV mode.

## 4. Features waiting for a Firebase project, deploy or billing
Nothing has been deployed, and no paid service has been enabled.
- **Community prices, votes and alerts:** they currently run only on the local Firebase emulator. Going live requires:
  - a Firebase project
  - `flutterfire configure` and `FIREBASE_MODE=project`
  - Anonymous Auth turned on
  - deploying the Firestore rules, indexes and functions
- **AI assistant:** the same steps, plus the **Blaze plan** (Cloud Functions require billing) and the `ANTHROPIC_API_KEY` secret.
- **Push notifications for price alerts:** FCM plus an APNs key (an Apple Developer account).
- **App Check, Crashlytics, Analytics, Performance Monitoring.**

## 5. Commits (all pushed to `origin/main`; `main...origin/main` is in sync)
| Commit | Content |
|---|---|
| `d7a9dfb`, `a91860c` | Phase 0: architecture, Places/OSRM, rename, icon |
| `7854eab` | Ranking engine |
| `f4ca6d4` | Garage |
| `105431a` | History |
| `073be94` | Along-route |
| `0167c85` | EV mode |
| `9066fcf`, `1040059` | Community prices: backend, then app |
| `4893e05` | AI trip assistant |
| `9ba7cfb`, `406cf3b` | Phase 3.A: offline cache, CI, localization foundation, accessibility tests, README |
| `5df7501`, `23c3f7f` | Phase 3.B: full Bengali, translated errors, splash, signing setup, privacy and release docs |

No force-pushes, no history rewrites and no secrets were committed. Each push was checked for `AIza…` and `sk-ant…` patterns, and `git log -S AIza` over this repo's full history finds nothing.

## 6. Analyze, tests and coverage (latest run, commit `5df7501`)
- `flutter analyze`: **no issues**.
- `flutter test`: **188 passed, 0 failed**.
- Domain-layer line coverage: **97.1%** (430 of 443 lines in 16 files; generated code excluded). CI enforces a minimum of 70%.
- Cloud Functions (`npm test`): **38 passed** (unit 19, Firestore rules 7, assistant 7, callable integration 5), on the emulator with a `demo-` project.
- iOS Simulator (iPhone 17e) checks across the batches:
  - permissions and error states
  - garage, history and charts
  - the price flow against the emulator
  - the assistant against the emulator with the demo model
  - Bengali on every screen that can be reached without live data
- **Not run:** any Android device or emulator session (CI only builds the debug APK) and any physical-device test.

## 7. CI status
`.github/workflows/ci.yml` runs on every push and pull request.
- **Flutter job:**
  1. Check that generated code is up to date.
  2. Analyze.
  3. Run tests with coverage.
  4. Apply the coverage gate.
  5. Build a debug APK and upload it as an artifact.
- **Functions job:** all tests on the Firebase emulators.
- **No deploy steps and no secrets.**

Results:
- The last three code runs passed:
  - [45639465141](https://github.com/ZubayeerAlam/gas-Station-Finder-/actions/runs/45639465141) (`9ba7cfb`)
  - [45644565363](https://github.com/ZubayeerAlam/gas-Station-Finder-/actions/runs/45644565363) (`5df7501`)
  - the run for `406cf3b`
- The run for docs commit `23c3f7f` was still in progress when this was written. This report's own commit triggers one more run.
- Commits before `9ba7cfb` predate CI.

## 8. Known bugs and limitations
- **Security:** before Phase 0 the Google key was hardcoded, and it is still in commit `d481cb0` of the **older parent repository** `~/FluterDev/Project`.
  - That commit is not on any remote branch, and the GitHub repo that remote points to (`All-Flutter-Project`) does not exist or cannot be reached.
  - It is not in this repo's history.
  - The key was in plain text in local source for a while, and it may have been shared or pushed somewhere I can't see, so treat it as exposed and rotate it.
- **No live data verified:** Places, Maps tiles, OCM, Claude, and Firestore in production.
- **Offline mode** keeps only station positions (Google's policy forbids storing names and prices). Station details always need a connection.
- **OSRM** uses the public demo server, which has no uptime guarantee and is not meant for production traffic. When routing fails, the app falls back to straight-line detours and says so.
- **Community data** has no moderation, no data deletion and no App Check yet. Abuse protection is limited to the security rules, rate limits and outlier rejection.
- **Bengali** text was written by Claude and still needs a native speaker's review. Units and digits stay in Latin script.
- **Accessibility:** screens that need live data have not been audited (map results, route ranking, charger sheet), and neither has keyboard focus order.
- **Release signing** has never been run with a real keystore. Without `android/key.properties`, release builds are signed with the debug key.
- The privacy policy is a draft: contact email, retention periods and hosting are still placeholders.
- The `PLAN.md` Phase 0 and 1 acceptance lines (for example "Tests pass 46/46") reflect the state at that time and were not rewritten, per the rule against deleting history.

## 9. Production-readiness assessment
| Area | State |
|---|---|
| Code structure, state management, error handling | **Ready**: layered, typed failures, consistent loading/empty/error states |
| Core logic (ranking, consumption, trust scoring) | **Ready**: 97% domain coverage, deterministic, never invents a price |
| Live integrations (Maps, Places, OCM, Claude) | **Not verified**: blocked on keys |
| Backend (Firestore rules, functions) | **Emulator-verified only**: not deployed, App Check missing, cost limits not set |
| Security and privacy | **Partly**: no secrets anywhere in this repo's history; the old key should still be rotated; data deletion and App Check missing |
| Localization and accessibility | **Mostly**: EN + BN complete; automated accessibility checks on most screens |
| Release (signing, store listing, privacy policy) | **Prepared, not done** |
| Monitoring | **Missing**: needs a Firebase project |

**Verdict:** ready for **internal testing** once the keys are added and live data is checked. It is **not ready for a public store release**. The minimum before an open beta:
1. Rotate the key and verify live data.
2. Deploy the backend with App Check, budget alerts and quotas.
3. Add crash reporting.
4. Add user data deletion.
5. Finish the privacy policy.
6. Run a closed test on real Android and iOS devices.

## 10. Your next steps (in order)
1. **Rotate the exposed Google key.**
   - Create a new key restricted to `com.fuelwise.app` and to Maps SDK for Android/iOS plus Places API (New).
   - Put it in `config/dev.json` and `ios/Flutter/Secrets.xcconfig`.
   - Run the app and confirm stations load.
2. Get a free **Open Charge Map** key, add it as `OCM_API_KEY`, and check EV mode.
3. Optional: put `ANTHROPIC_API_KEY` in `functions/.secret.local` and have one live assistant conversation on the emulator. Compare its answer with the trip screen's ranking.
4. Review the **Bengali wording** (`lib/l10n/app_bn.arb`).
5. Decide whether to create a **Firebase project**. Read the costs first: Cloud Functions require the Blaze plan. Then follow [RELEASE.md](RELEASE.md) section 1. Deploying is your decision; nothing will be deployed without your explicit OK.
6. Create the **upload keystore** and finish the **privacy policy**, then follow [RELEASE.md](RELEASE.md) for a Google Play internal test.
