# Firebase Setup Guide

This guide will walk you through setting up Firebase for the Flutter SaaS Starter project.

## Prerequisites

- A Google account
- Firebase CLI installed (optional but recommended)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: `flutter-saas-starter` (or your choice)
4. (Optional) Enable Google Analytics
5. Click "Create Project"

## Step 2: Add Android App

1. In Firebase Console, click the Android icon
2. Enter package name: `com.fluttersaas.flutter_saas_starter`
3. (Optional) Enter app nickname and SHA-1
4. Click "Register app"
5. Download `google-services.json`
6. Place it in `android/app/google-services.json`

### Getting SHA-1 for Google Sign-In (Android)

```bash
# Debug SHA-1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release SHA-1 (after creating release keystore)
keytool -list -v -keystore /path/to/release.keystore -alias your_alias
```

Add the SHA-1 to Firebase Console under Project Settings > Your Apps > SHA certificate fingerprints.

## Step 3: Add iOS App

1. In Firebase Console, click the iOS icon
2. Enter bundle ID: `com.fluttersaas.flutterSaasStarter`
3. (Optional) Enter app nickname
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Open `ios/Runner.xcworkspace` in Xcode
7. Drag `GoogleService-Info.plist` into the Runner folder
8. Ensure "Copy items if needed" is checked

## Step 4: Enable Authentication Methods

1. Go to Authentication > Sign-in method
2. Enable the following providers:

### Email/Password
- Click "Email/Password"
- Enable it
- Save

### Google Sign-In

**Android:**
- Click "Google"
- Enable it
- Add SHA-1 certificate fingerprint
- Save

**iOS:**
- Click "Google"
- Enable it
- Download updated `GoogleService-Info.plist`
- Replace the file in Xcode
- Add URL scheme to Xcode:
  - Open `ios/Runner.xcworkspace`
  - Select Runner > Info > URL Types
  - Add new URL scheme with reversed client ID from `GoogleService-Info.plist`
  - Example: `com.googleusercontent.apps.123456789-abc`

### Apple Sign-In (iOS only)

**Prerequisites:**
- Paid Apple Developer account
- App ID configured with "Sign in with Apple" capability

**Steps:**
1. In Firebase Console, click "Apple"
2. Enable it
3. You'll need:
   - Service ID
   - Team ID
   - Key ID
   - Private Key

**Xcode Setup:**
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Go to "Signing & Capabilities"
4. Click "+ Capability"
5. Add "Sign in with Apple"

**Apple Developer Console:**
1. Go to [Apple Developer](https://developer.apple.com/)
2. Certificates, Identifiers & Profiles
3. Identifiers > App IDs
4. Select your app ID
5. Enable "Sign in with Apple"
6. Save

## Step 5: Create Firestore Database

1. Go to Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select location closest to your users
5. Click "Enable"

### Set up Security Rules

Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow write: if isOwner(userId);
    }
    
    // Todos collection
    match /todos/{todoId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
  }
}
```

**IMPORTANT**: These are development rules. For production:
- Review and tighten security rules
- Add field validation
- Add rate limiting
- Consider using Firebase Security Rules Unit Tests

## Step 6: (Optional) Enable Cloud Messaging

For push notifications:

1. Go to Cloud Messaging
2. Note down the Server Key
3. Configure in your app

## Step 7: Configure Firebase in Your App

### Android

File: `android/build.gradle`
```gradle
// Already configured in the starter
classpath 'com.google.gms:google-services:4.4.0'
```

File: `android/app/build.gradle`
```gradle
// Already configured in the starter
apply plugin: 'com.google.gms.google-services'
```

### iOS

File: `ios/Podfile`
```ruby
# Add at the top
platform :ios, '13.0'
```

Run:
```bash
cd ios
pod install
```

## Step 8: Test Authentication

1. Run the app
2. Try to register with email/password
3. Check Firebase Console > Authentication > Users
4. Try Google Sign-In (if configured)
5. Try Apple Sign-In (if configured on iOS)

## Troubleshooting

### Android: google-services.json not found
- Ensure file is at `android/app/google-services.json`
- Run `flutter clean && flutter pub get`

### iOS: GoogleService-Info.plist not found
- Ensure file is added to Xcode project
- Check "Copy items if needed"
- Build and run again

### Google Sign-In not working on Android
- Ensure SHA-1 is added to Firebase Console
- Download new `google-services.json` after adding SHA-1
- Clean and rebuild

### Apple Sign-In not working
- Ensure capability is added in Xcode
- Ensure App ID has "Sign in with Apple" enabled
- Test on physical device (doesn't work on simulator)

## Deploy Security Rules

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize project
firebase init firestore

# Deploy rules
firebase deploy --only firestore:rules
```

## Best Practices

1. **Never commit** Firebase config files to git (already in .gitignore)
2. Use separate Firebase projects for dev/staging/prod
3. Enable App Check for production
4. Set up monitoring and alerts
5. Review security rules regularly
6. Use Firebase Local Emulator Suite for development

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Security Rules Guide](https://firebase.google.com/docs/rules)
- [Google Sign-In Setup](https://firebase.google.com/docs/auth/flutter/google-signin)
- [Apple Sign-In Setup](https://firebase.google.com/docs/auth/flutter/apple)

