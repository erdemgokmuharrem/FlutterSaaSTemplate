Repo rules — Flutter SaaS Starter

Branching & PRs

Same as React project: main protected, develop integration, feature branches feat/*.

Commits

Conventional commits, frequent small commits.

Code style

Dart analysis_options.yaml with strong rules, flutter format and dart fix.

Null-safety enforced.

Secrets

Do not commit GoogleService-Info.plist or google-services.json. Provide FIREBASE_SETUP.md with steps.

RevenueCat API keys not committed. .env or secure config.

Testing

Widget tests for auth flows and todo CRUD.

Integration tests optional if CI supports emulators.

CI

GitHub Actions: run flutter analyze, flutter test, and flutter build apk (optional smoke build).

Firestore rules

Provide minimal rules allowing user-scoped access; comment that production rules must be stricter.

Docs

README must include platform-specific steps (Android, iOS), RevenueCat, Firebase setup, and how to toggle Provider vs Riverpod.