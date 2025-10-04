Project name: Flutter SaaS Starter — Flutter 3 SaaS Boilerplate (iOS + Android)
Goal: Flutter 3 proje setup; Firebase (Auth + Firestore) entegre, state management (Riverpod by default, Provider optional), Auth flows, RevenueCat subscription flow (free + premium), demo CRUD (Todo), bottom nav dashboard, deployment docs, README.

Target user: Flutter geliştiricisi/entegratör; template’i alıp kendi API/logic’ini bağlar.

Stack & Paketler (suggested):

Flutter 3.x, Dart stable

State: Riverpod (Riverpod v2) — Provider optional module folder

Firebase: firebase_core, firebase_auth, cloud_firestore, firebase_messaging (optional)

Auth UI: email/password, Google Sign-In (google_sign_in), Apple Sign-In (sign_in_with_apple) — Apple optional but included

Revenue: Purchases (RevenueCat) via purchases_flutter

Local storage: Hive/SharedPreferences for session/cache

Routing: go_router or auto_route

Forms & validation: flutter_form_builder or formz

CI: GitHub Actions (fastlane optional for iOS)

Demo: Todo CRUD stored in Firestore

Deployment: Android (apk/aab) instructions; iOS build instructions + Apple config hints.

Features & Acceptance Criteria:

Firebase Auth: email/password registration & login, Google login, Apple login (if platform supports), forgot password flow.

Firestore: demo todos collection with user-scoped documents; full CRUD with offline support.

Subscription: RevenueCat integrated; show free vs premium features; gating premium dashboard features.

Dashboard: BottomNav with 3 tabs (Home, Profile, Settings).

UI: Clean Material design + light/dark theme, localization (en + tr sample).

README: setup Firebase, configure Google/Apple sign-in, RevenueCat keys, run instructions, build steps.

.env example or config file for keys (do not commit keys).

iOS & Android build tested locally (instructions + checklists).

Deliverables:

Flutter project folder ready to open in Android Studio/VSCode.

README.md, FIREBASE_SETUP.md, REVENUECAT_SETUP.md, .env.example (or lib/config.example.dart).

Sample user accounts & test purchases notes.

CI workflow for tests / build checks.

Milestones / Checklist

Scaffold Flutter 3 project with Riverpod and go_router. ✔

Firebase integration (core + auth + firestore). ✔

Auth UI: login, register, google, apple (apple optional). ✔

Forgot password flow. ✔

Bottom nav dashboard + profile/settings. ✔

Todo CRUD with Firestore rules sample. ✔

RevenueCat integration & gating. ✔

README & Firebase setup guide. ✔

Android & iOS build instructions + sanity checks. ✔

Unit/widget tests (critical flows). ✔

Security / Notes

Firestore security rules sample included but must be reviewed for production.

Apple sign-in requires proper entitlements and Apple developer setup.