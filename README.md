# Flutter SaaS Starter

> 🚀 **Production-Ready** | 💰 **Monetization-Ready** | 📱 **Multi-Platform** | ⚡ **15 Minutes Setup**

A complete Flutter 3 SaaS boilerplate with Firebase Auth, Firestore, RevenueCat subscriptions, and clean architecture. **Ready for commercial use and distribution.**

[![Flutter](https://img.shields.io/badge/Flutter-3.35.5-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue)](#platform-support)

## 🌟 Why Choose This Starter?

- ⏱️ **Save 6-8 weeks** of development time
- 💰 **Save $15,000-$30,000** in development costs  
- 🚀 **Launch in days**, not months
- 📱 **6 platforms** from a single codebase
- 🔒 **Production-ready** code with best practices
- 📚 **Comprehensive documentation** included
- 🧪 **70%+ test coverage**
- 💳 **Monetization** built-in with RevenueCat

## 📱 Platform Support

| Platform | Status | Min Version | Build Ready |
|----------|--------|-------------|-------------|
| iOS | ✅ | 13.0+ | Yes |
| Android | ✅ | API 21+ | Yes |
| Web | ✅ | Modern browsers | Yes |
| macOS | ✅ | 10.15+ | Yes |
| Windows | ✅ | 10+ | Yes |
| Linux | ✅ | Ubuntu 20.04+ | Yes |

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

## 🚀 Launch Checklist

### Pre-Launch (Development)

**Setup & Configuration**
- [ ] Clone repository and install dependencies
- [ ] Create Firebase project
- [ ] Add `google-services.json` (Android)
- [ ] Add `GoogleService-Info.plist` (iOS)
- [ ] Configure RevenueCat account
- [ ] Add RevenueCat API keys to `config.dart`
- [ ] Update app branding (name, colors, logo)
- [ ] Configure product IDs in stores

**Development & Testing**
- [ ] Run `flutter pub get`
- [ ] Run code generation: `flutter pub run build_runner build`
- [ ] Test on iOS simulator/device
- [ ] Test on Android emulator/device
- [ ] Test authentication flows (Email, Google, Apple)
- [ ] Test todo CRUD operations
- [ ] Test subscription flow
- [ ] Test light/dark themes
- [ ] Test language switching (EN/TR)
- [ ] Run all unit tests: `flutter test`
- [ ] Verify Firebase security rules
- [ ] Test offline functionality

**Code Quality**
- [ ] Run `flutter analyze` (no errors)
- [ ] Run `dart format .`
- [ ] Fix all linter warnings
- [ ] Review and update TODO comments
- [ ] Check for hardcoded values
- [ ] Remove debug/console logs

### Pre-Production

**Security Review**
- [ ] Verify no API keys committed to Git
- [ ] Review Firebase security rules
- [ ] Enable App Check (Firebase)
- [ ] Test authentication edge cases
- [ ] Verify user data isolation
- [ ] Review network security config
- [ ] Enable code obfuscation for release builds

**Performance**
- [ ] Profile app performance
- [ ] Optimize images and assets
- [ ] Check app size (APK/IPA)
- [ ] Test on low-end devices
- [ ] Verify memory usage
- [ ] Test network error handling

**Compliance**
- [ ] Privacy policy created and hosted
- [ ] Terms of service created
- [ ] Update in-app privacy links
- [ ] GDPR compliance (if applicable)
- [ ] COPPA compliance (if targeting children)
- [ ] Store listing prepared

### iOS Launch

**App Store Connect**
- [ ] Apple Developer account active ($99/year)
- [ ] App ID created with correct Bundle ID
- [ ] Certificates and provisioning profiles ready
- [ ] "Sign in with Apple" capability enabled
- [ ] In-App Purchase products configured
- [ ] Screenshots prepared (all required sizes)
- [ ] App icon (1024x1024) ready
- [ ] App description and keywords optimized
- [ ] Privacy policy URL added
- [ ] Support URL added
- [ ] Age rating completed

**iOS Build**
- [ ] Version/build number updated in `pubspec.yaml`
- [ ] Run `flutter build ios --release`
- [ ] Archive in Xcode
- [ ] Upload to App Store Connect
- [ ] Submit for TestFlight
- [ ] Test with TestFlight users
- [ ] Submit for App Review

### Android Launch

**Google Play Console**
- [ ] Google Play Developer account active ($25 one-time)
- [ ] App created in Play Console
- [ ] Package name correct
- [ ] Signing key created and secured
- [ ] In-App Products configured
- [ ] Screenshots prepared (phone, tablet, 7-inch, 10-inch)
- [ ] Feature graphic (1024x500)
- [ ] App icon prepared
- [ ] Short description (80 chars)
- [ ] Full description optimized
- [ ] Privacy policy URL added
- [ ] Content rating completed
- [ ] Target audience selected

**Android Build**
- [ ] Version/build number updated
- [ ] Configure signing in `android/key.properties`
- [ ] Run `flutter build appbundle --release`
- [ ] Test signed APK on device
- [ ] Upload AAB to Play Console
- [ ] Create internal testing release
- [ ] Test with internal testers
- [ ] Promote to production

### Web Launch

**Build & Deploy**
- [ ] Run `flutter build web --release`
- [ ] Test locally: `flutter run -d chrome`
- [ ] Configure hosting (Firebase Hosting, Netlify, Vercel)
- [ ] Set up custom domain (optional)
- [ ] Configure SSL certificate
- [ ] Test on multiple browsers
- [ ] Test responsive design
- [ ] Verify PWA functionality
- [ ] Deploy to production

**Web Optimization**
- [ ] Enable service worker
- [ ] Configure caching strategy
- [ ] Optimize loading time
- [ ] Test SEO (meta tags, sitemap)
- [ ] Add analytics (Google Analytics)

### Post-Launch

**Monitoring**
- [ ] Enable Firebase Crashlytics
- [ ] Enable Firebase Analytics
- [ ] Set up performance monitoring
- [ ] Configure error alerts
- [ ] Monitor user feedback
- [ ] Track key metrics (DAU, retention, revenue)

**Marketing**
- [ ] Announce on social media
- [ ] Submit to product hunt
- [ ] Create demo video
- [ ] Write blog post
- [ ] Reach out to influencers
- [ ] Update portfolio/website

**Maintenance**
- [ ] Monitor crash reports daily
- [ ] Respond to user reviews
- [ ] Plan feature updates
- [ ] Security patches
- [ ] Performance improvements
- [ ] Bug fixes

### Platform-Specific Builds

**macOS**
- [ ] Run `flutter build macos --release`
- [ ] Notarize app (for distribution)
- [ ] Test on multiple macOS versions

**Windows**
- [ ] Run `flutter build windows --release`
- [ ] Create installer (MSIX or Inno Setup)
- [ ] Test on Windows 10/11

**Linux**
- [ ] Run `flutter build linux --release`
- [ ] Create package (.deb, .rpm, AppImage)
- [ ] Test on Ubuntu/Debian

---

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

## Documentation

- [PRODUCTION_READY.md](PRODUCTION_READY.md) - Commercial deployment guide
- [PLATFORM_BUILD_GUIDE.md](PLATFORM_BUILD_GUIDE.md) - Platform-specific builds
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Firebase configuration
- [REVENUECAT_SETUP.md](REVENUECAT_SETUP.md) - Monetization setup
- [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) - Build & deployment

## Credits

Built with ❤️ using Flutter, Firebase, and RevenueCat.

