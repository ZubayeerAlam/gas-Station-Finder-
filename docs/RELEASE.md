# Release checklist

Nothing in this file has been executed. Every step needs your accounts, keys or approval, and some cost money (for example the Apple Developer Program at US$99 per year, or the Google Play one-time fee of US$25).

## 1. Keys and backend (blocked until done)
- [ ] Create a new Google Maps key, restricted to `com.fuelwise.app` (Android package + SHA-1, and the iOS bundle ID) and to Maps SDK for Android/iOS + Places API (New). Put it in `config/prod.json` (gitignored).
- [ ] Create a Firebase project and run `flutterfire configure` (needs billing only for Cloud Functions on the Blaze plan).
- [ ] Deploy the Firestore rules and the functions (`firebase deploy`) **only after** reviewing costs. Set the `ANTHROPIC_API_KEY` secret.
- [ ] Turn on App Check (Play Integrity / App Attest).

## 2. Android signing
1. Create an upload key (keep the file and passwords **outside** the repo, and back them up):
   ```bash
   keytool -genkey -v -keystore ~/fuelwise-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create `android/key.properties` (already gitignored):
   ```properties
   storeFile=/Users/<you>/fuelwise-upload.jks
   storePassword=<password>
   keyAlias=upload
   keyPassword=<password>
   ```
3. Build: `flutter build appbundle --release --dart-define-from-file=config/prod.json`.

   Without `key.properties` the release build is signed with the debug key. That works for local testing, but Google Play rejects it.
4. Add the upload key's SHA-1 (`keytool -list -v -keystore ~/fuelwise-upload.jks`) to the Google Maps key restriction.

## 3. iOS signing
- [ ] In Xcode → Runner → Signing & Capabilities, choose your team; the bundle ID is `com.fuelwise.app`.
- [ ] `flutter build ipa --release --dart-define-from-file=config/prod.json`, then upload with Transporter or Xcode.

## 4. Store listing
- [ ] Privacy policy: finish [`docs/privacy-policy.md`](privacy-policy.md) and host it at a public URL.
- [ ] Data safety form (Play) and App Privacy labels (App Store): use the table in the privacy policy.
- [ ] Screenshots (phone, and tablet if supported) in English and Bengali, a feature graphic, and a short and full description.
- [ ] Content rating questionnaire.

## Already in the repo
- App icon: `flutter_launcher_icons` (`assets/icon/`).
- Launch screen: `flutter_native_splash` (brand green `#0B8A6F`), generated for Android (including the Android 12+ splash API), iOS and web.
- Release signing wiring in `android/app/build.gradle.kts` (reads `android/key.properties`).
- English and Bengali UI, declared in iOS `CFBundleLocalizations`.
- CI builds a debug APK on every push. It never deploys or signs releases.
