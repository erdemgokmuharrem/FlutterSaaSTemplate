# Flutter SaaS Starter

A complete Flutter 3 SaaS boilerplate with Firebase Auth, Firestore, RevenueCat subscriptions, and clean architecture.

## Features

- ✅ **Firebase Authentication**: Email/Password, Google Sign-In, Apple Sign-In
- ✅ **Firestore Integration**: Real-time database with offline support
- ✅ **RevenueCat**: Subscription management and in-app purchases
- ✅ **State Management**: Riverpod v2 (with optional Provider module)
- ✅ **Navigation**: go_router with type-safe routing
- ✅ **Localization**: English and Turkish support
- ✅ **Theme**: Light and dark mode with Material 3
- ✅ **Clean Architecture**: Feature-based folder structure
- ✅ **Testing**: Unit, widget, and integration tests
- ✅ **CI/CD**: GitHub Actions workflow

## Architecture

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/       # Constants
│   ├── router/          # Navigation
│   ├── theme/           # Theme configuration
│   └── utils/           # Utilities
├── features/
│   ├── auth/            # Authentication
│   ├── home/            # Home dashboard
│   ├── profile/         # User profile
│   ├── settings/        # App settings
│   ├── subscription/    # RevenueCat integration
│   └── todos/           # Todo CRUD demo
├── shared/
│   ├── providers/       # Shared providers
│   └── widgets/         # Reusable widgets
└── main.dart
```

## Prerequisites

- Flutter 3.0.0 or higher
- Dart 3.0.0 or higher
- Firebase project setup
- RevenueCat account
- Xcode 14+ (for iOS)
- Android Studio / VS Code

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd flutter_saas_starter
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Follow the detailed instructions in [FIREBASE_SETUP.md](FIREBASE_SETUP.md).

Quick steps:
1. Create a Firebase project
2. Add Android and iOS apps
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place them in respective directories (DO NOT COMMIT)

### 4. Configure RevenueCat

Follow the detailed instructions in [REVENUECAT_SETUP.md](REVENUECAT_SETUP.md).

Quick steps:
1. Create a RevenueCat account
2. Add your app
3. Configure products
4. Copy API keys to `lib/core/config/config.dart`

### 5. Update configuration

```bash
cp lib/core/config/config.example.dart lib/core/config/config.dart
```

Edit `lib/core/config/config.dart` and add your API keys.

### 6. Generate code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Run the app

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## Building for Production

### Android

```bash
# APK
flutter build apk --release

# AAB (for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
# Archive
flutter build ios --release

# Then open Xcode and archive
open ios/Runner.xcworkspace
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/features/auth/auth_test.dart
```

## Localization

To add a new language:

1. Create `lib/l10n/app_{locale}.arb` (e.g., `app_es.arb`)
2. Copy keys from `app_en.arb` and translate
3. Run `flutter gen-l10n`
4. Add locale to `supportedLocales` in `main.dart`

## State Management

This project uses **Riverpod v2** by default. 

To use Provider instead:
1. Check the `lib/features_provider/` directory (optional module)
2. Replace imports in your feature modules
3. Update providers as needed

## Firebase Security Rules

Sample Firestore rules are provided in `firestore.rules`. 

**IMPORTANT**: Review and customize for production use!

```bash
# Deploy rules
firebase deploy --only firestore:rules
```

## Apple Sign-In Setup

For Apple Sign-In to work:

1. Enable "Sign in with Apple" in Xcode capabilities
2. Add Apple as a provider in Firebase Console
3. Configure service ID and key in Apple Developer Console
4. Update `lib/core/config/config.dart` with `enableAppleSignIn: true`

## RevenueCat Setup

See [REVENUECAT_SETUP.md](REVENUECAT_SETUP.md) for detailed instructions.

Key steps:
1. Create products in App Store Connect / Play Console
2. Configure offerings in RevenueCat dashboard
3. Add entitlement ID (default: "premium")
4. Test with sandbox accounts

## Troubleshooting

### Firebase not initialized
- Ensure Firebase is configured correctly
- Check `google-services.json` and `GoogleService-Info.plist` are in place
- Run `flutter clean && flutter pub get`

### RevenueCat errors
- Verify API keys in `config.dart`
- Check products are configured in store
- Test with sandbox accounts

### Build errors
- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter pub run build_runner build --delete-conflicting-outputs`

## Contributing

1. Fork the repository
2. Create a feature branch (`feat/amazing-feature`)
3. Commit using Conventional Commits
4. Push and create a Pull Request

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
- Open an issue on GitHub
- Check existing documentation
- Review Firebase and RevenueCat docs

## Credits

Built with ❤️ using Flutter, Firebase, and RevenueCat.

