# Build Instructions

This document provides detailed instructions for building the Flutter SaaS Starter app for iOS and Android.

## Prerequisites

Before building, ensure you have:

- ✅ Flutter SDK installed (3.0.0+)
- ✅ Xcode installed (14.0+) - for iOS
- ✅ Android Studio or Android SDK - for Android
- ✅ CocoaPods installed - for iOS
- ✅ Valid Apple Developer account - for iOS distribution
- ✅ Google Play Console account - for Android distribution

## Initial Setup

### 1. Install Dependencies

```bash
cd /path/to/flutter_saas_starter
flutter pub get
```

### 2. Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configure Firebase

Follow [FIREBASE_SETUP.md](FIREBASE_SETUP.md) to:
- Add `google-services.json` to `android/app/`
- Add `GoogleService-Info.plist` to `ios/Runner/`

### 4. Configure RevenueCat

Follow [REVENUECAT_SETUP.md](REVENUECAT_SETUP.md) and update `lib/core/config/config.dart`

## Android Build

### Debug Build (APK)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build (APK)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Signing Configuration (Release)

1. Create a keystore:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path to upload-keystore.jks>
```

3. Update `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Android Build Troubleshooting

**Issue**: `JAVA_HOME is not set`
```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
```

**Issue**: Gradle build fails
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Issue**: Missing google-services.json
- Download from Firebase Console
- Place in `android/app/google-services.json`

## iOS Build

### Debug Build

```bash
flutter build ios --debug
```

Then open in Xcode:
```bash
open ios/Runner.xcworkspace
```

Run from Xcode (Cmd+R)

### Release Build

```bash
flutter build ios --release
```

### Archive for App Store

1. Open in Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Select "Any iOS Device" as target

3. Product > Archive

4. Upload to App Store Connect

### Code Signing Setup

1. **Automatic Signing** (Recommended for development):
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner target
   - Signing & Capabilities tab
   - Check "Automatically manage signing"
   - Select your Team

2. **Manual Signing** (For CI/CD):
   - Create certificates in Apple Developer portal
   - Download provisioning profiles
   - Configure in Xcode

### iOS Build Troubleshooting

**Issue**: Pod install fails
```bash
cd ios
pod deintegrate
pod install
cd ..
```

**Issue**: CocoaPods not found
```bash
sudo gem install cocoapods
```

**Issue**: Signing error
- Ensure Team is selected in Xcode
- Check Bundle Identifier matches Apple Developer portal
- Regenerate provisioning profiles

**Issue**: GoogleService-Info.plist not found
- Download from Firebase Console
- Drag into Xcode (ensure "Copy items if needed" is checked)

## Platform-Specific Configurations

### Android Minimum Requirements

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- `compileSdkVersion`: 34

### iOS Minimum Requirements

- `iOS Deployment Target`: 13.0
- Xcode: 14.0+
- Swift: 5.0+

## Feature-Specific Setup

### Google Sign-In

**Android:**
- Add SHA-1 to Firebase Console
- Download updated `google-services.json`

**iOS:**
- Add URL scheme to `Info.plist`
- Value: Reversed client ID from `GoogleService-Info.plist`

### Apple Sign-In (iOS only)

1. Enable capability in Xcode:
   - Runner target > Signing & Capabilities
   - "+ Capability" > Sign in with Apple

2. Configure in Apple Developer:
   - App IDs > Select your app
   - Enable "Sign in with Apple"

3. Configure in Firebase Console:
   - Authentication > Sign-in method
   - Enable Apple provider

### RevenueCat

1. Configure products in stores
2. Set up offerings in RevenueCat dashboard
3. Update API keys in `config.dart`

## Build Optimization

### Reduce App Size

```bash
# Android with app bundle
flutter build appbundle --release

# Android with split APKs
flutter build apk --release --split-per-abi
```

### Obfuscation (Release builds)

```bash
flutter build apk --release --obfuscate --split-debug-info=./debug-info
flutter build ios --release --obfuscate --split-debug-info=./debug-info
```

## Testing Builds

### Install APK on Device

```bash
flutter install
# or
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Install on iOS Device

1. Build in Xcode
2. Connect device
3. Product > Run
4. Or use TestFlight for distribution testing

## Distribution

### Android - Google Play

1. Build AAB:
```bash
flutter build appbundle --release
```

2. Upload to Play Console:
   - Create release in Play Console
   - Upload `app-release.aab`
   - Complete store listing
   - Submit for review

### iOS - App Store

1. Archive in Xcode
2. Upload to App Store Connect
3. Complete App Store listing
4. Submit for review

## Continuous Integration

The project includes GitHub Actions workflow (`.github/workflows/ci.yml`) that:

- Runs tests
- Analyzes code
- Builds APK (Android)
- Builds iOS (macOS runners only)

To run locally:
```bash
flutter analyze
flutter test
flutter build apk
flutter build ios
```

## Version Management

Update version in `pubspec.yaml`:

```yaml
version: 1.0.0+1
#        │    │
#        │    └─ Build number
#        └────── Version name
```

Then rebuild:
```bash
flutter clean
flutter pub get
flutter build [apk|ios]
```

## Build Checklist

Before releasing:

- [ ] All tests passing
- [ ] No analyzer warnings
- [ ] Firebase configured correctly
- [ ] RevenueCat configured
- [ ] Signing configured
- [ ] Version number updated
- [ ] Release notes prepared
- [ ] Privacy policy updated
- [ ] Terms of service updated
- [ ] Screenshots prepared
- [ ] Store listing complete
- [ ] Test on multiple devices
- [ ] Verify in-app purchases work
- [ ] Verify authentication works
- [ ] Check deep links (if applicable)

## Common Issues

### Both Platforms

**Issue**: Dependencies not found
```bash
flutter clean
rm -rf .dart_tool
flutter pub get
```

**Issue**: Code generation fails
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Android Specific

**Issue**: Duplicate class errors
- Check for conflicting dependencies
- Add exclusions in `build.gradle`

**Issue**: MultiDex errors
- Already enabled in `build.gradle`
- If still occurring, increase heap size

### iOS Specific

**Issue**: "Unable to boot simulator"
```bash
xcrun simctl erase all
```

**Issue**: Code signing requires a development team
- Add Team in Xcode settings
- Or use automatic signing

## Performance Tips

- Use `--release` for production builds
- Enable obfuscation for security
- Use app bundles on Android
- Test on low-end devices
- Profile with Flutter DevTools

## Resources

- [Flutter Build Documentation](https://docs.flutter.dev/deployment)
- [Android App Bundle](https://developer.android.com/guide/app-bundle)
- [iOS Distribution Guide](https://developer.apple.com/distribute/)
- [Firebase Setup](FIREBASE_SETUP.md)
- [RevenueCat Setup](REVENUECAT_SETUP.md)

