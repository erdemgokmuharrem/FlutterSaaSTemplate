# 🏗️ Platform-Specific Build Guide

Her platform için detaylı build talimatları ve sorun giderme.

---

## 📱 iOS Build

### Gereksinimler
- macOS (Catalina 10.15+)
- Xcode 14.0+
- CocoaPods
- Apple Developer Account ($99/yıl)

### İlk Kurulum

```bash
# 1. Dependencies
cd ios
pod install
cd ..

# 2. Xcode'da aç
open ios/Runner.xcworkspace

# 3. Signing & Capabilities
# - Team seç
# - Bundle Identifier ayarla: com.yourcompany.yourapp
# - Sign in with Apple capability ekle (opsiyonel)
```

### Development Build

```bash
# Simulator'da çalıştır
flutter run -d ios

# Fiziksel cihazda çalıştır
flutter run -d "iPhone"
```

### Production Build

```bash
# 1. Version güncelle
# pubspec.yaml: version: 1.0.0+1

# 2. Build
flutter build ios --release

# 3. Xcode'da Archive
# - Product > Archive
# - Distribute App > App Store Connect
# - Upload
```

### App Store Checklist

- [ ] Bundle ID benzersiz
- [ ] Version/Build number doğru
- [ ] App icons ekli (1024x1024)
- [ ] Screenshots hazır
- [ ] Privacy policy URL
- [ ] App description hazır
- [ ] Keywords optimize
- [ ] Test Notes hazır

### İOS Sorun Giderme

**Sorun**: "No Provisioning Profile"
```bash
# Çözüm: Xcode'da Team seçin ve otomatik signing kullanın
```

**Sorun**: CocoaPods hata
```bash
cd ios
pod deintegrate
pod install --repo-update
```

**Sorun**: Apple Sign-In çalışmıyor
```bash
# 1. Capability eklendi mi kontrol et
# 2. Bundle ID doğru mu kontrol et
# 3. Firebase'de Apple provider aktif mi kontrol et
```

---

## 🤖 Android Build

### Gereksinimler
- Android Studio / Android SDK
- Java JDK 17
- Google Play Developer Account ($25 bir kere)

### İlk Kurulum

```bash
# 1. Android SDK kontrol
flutter doctor

# 2. Gradle sync
cd android
./gradlew clean
cd ..
```

### Signing Key Oluşturma

```bash
# 1. Key oluştur
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# 2. key.properties oluştur
# android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-upload-keystore.jks>

# 3. build.gradle güncelle (zaten dahil)
```

### Development Build

```bash
# Emulator'da çalıştır
flutter run -d android

# Fiziksel cihazda çalıştır
flutter run -d "device-name"
```

### Production Build

```bash
# APK (Test için)
flutter build apk --release

# App Bundle (Play Store için önerilen)
flutter build appbundle --release

# Split APKs (Boyut optimizasyonu)
flutter build apk --split-per-abi --release
```

### Play Store Checklist

- [ ] Package name benzersiz
- [ ] Version code arttırıldı
- [ ] Signed APK/AAB
- [ ] Feature graphic (1024x500)
- [ ] Screenshots (en az 2)
- [ ] App icon
- [ ] Short description (80 karakter)
- [ ] Full description
- [ ] Privacy policy URL
- [ ] Content rating tamamlandı

### Android Sorun Giderme

**Sorun**: "INSTALL_FAILED_INSUFFICIENT_STORAGE"
```bash
# Çözüm: Emulator/device'da yer açın
```

**Sorun**: Gradle build fail
```bash
cd android
./gradlew clean
./gradlew build --refresh-dependencies
```

**Sorun**: Google Sign-In çalışmıyor
```bash
# 1. SHA-1 ekleyin Firebase Console'a
keytool -list -v -keystore ~/.android/debug.keystore

# 2. google-services.json güncel mi kontrol et
```

---

## 🌐 Web Build

### Gereksinimler
- Chrome browser
- Web hosting (Firebase Hosting, Netlify, Vercel, vb.)

### Development

```bash
# Chrome'da çalıştır
flutter run -d chrome

# Port belirle
flutter run -d chrome --web-port=8080
```

### Production Build

```bash
# Build
flutter build web --release

# CanvasKit renderer (daha iyi performans)
flutter build web --release --web-renderer canvaskit

# HTML renderer (daha küçük boyut)
flutter build web --release --web-renderer html
```

### Deploy Seçenekleri

#### Firebase Hosting

```bash
# 1. Firebase CLI kur
npm install -g firebase-tools

# 2. Login
firebase login

# 3. Init
firebase init hosting

# 4. Deploy
firebase deploy --only hosting
```

#### Netlify

```bash
# 1. build/web/ klasörünü drag & drop
# veya

# 2. CLI ile
npm install -g netlify-cli
netlify deploy --prod --dir=build/web
```

#### Vercel

```bash
# 1. Vercel CLI
npm install -g vercel
vercel --prod ./build/web
```

### Web Optimizasyonu

```dart
// index.html - Service Worker
<script>
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', function () {
      navigator.serviceWorker.register('/flutter_service_worker.js');
    });
  }
</script>

// PWA Support
// web/manifest.json güncelle
```

### Web Sorun Giderme

**Sorun**: CORS errors
```bash
# Çözüm: Backend'de CORS headers ayarla
# veya proxy kullan
```

**Sorun**: Slow loading
```bash
# Çözüm: CanvasKit renderer kullan
# ve assets'leri optimize et
```

---

## 💻 macOS Build

### Gereksinimler
- macOS 10.15+
- Xcode 14.0+
- Apple Developer Account (isteğe bağlı development için)

### İlk Kurulum

```bash
# 1. macOS desteği ekle (zaten dahil)
flutter create --platforms=macos .

# 2. Dependencies
cd macos
pod install
cd ..
```

### Development

```bash
# Çalıştır
flutter run -d macos
```

### Production Build

```bash
# Build
flutter build macos --release

# App path
# build/macos/Build/Products/Release/flutter_saas_starter.app
```

### App Store Dağıtımı

```bash
# 1. Xcode'da aç
open macos/Runner.xcworkspace

# 2. Signing ayarla
# 3. Archive
# 4. Distribute
```

### macOS Sorun Giderme

**Sorun**: Entitlements hataları
```bash
# Çözüm: macos/Runner/*.entitlements dosyalarını kontrol et
```

**Sorun**: Notarization gerekli
```bash
# Çözüm: Apple Developer ile notarize edin
xcrun altool --notarize-app --file app.zip
```

---

## 🪟 Windows Build (Opsiyonel)

### Gereksinimler
- Windows 10+
- Visual Studio 2022
- Windows SDK

### Kurulum

```bash
# 1. Windows desteği ekle
flutter create --platforms=windows .

# 2. Build
flutter build windows --release
```

### Dağıtım

```bash
# MSIX paket oluştur
flutter pub add msix
flutter pub run msix:create

# veya
# Inno Setup ile installer oluştur
```

---

## 🐧 Linux Build (Opsiyonel)

### Gereksinimler
- Ubuntu 20.04+ (veya benzeri)
- Clang
- GTK3

### Kurulum

```bash
# 1. Dependencies
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev

# 2. Linux desteği ekle
flutter create --platforms=linux .

# 3. Build
flutter build linux --release
```

---

## 🎯 Platform Karşılaştırması

| Özellik | iOS | Android | Web | macOS | Windows | Linux |
|---------|-----|---------|-----|-------|---------|-------|
| Firebase Auth | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Firestore | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| RevenueCat | ✅ | ✅ | ⚠️ Limited | ⚠️ Limited | ❌ | ❌ |
| Push Notifications | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Google Sign-In | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Apple Sign-In | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---

## 🔄 CI/CD Pipeline

### GitHub Actions

```yaml
# .github/workflows/build.yml
name: Build All Platforms

on: [push, pull_request]

jobs:
  ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release --no-codesign
  
  android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: '17'
      - uses: subosito/flutter-action@v2
      - run: flutter build apk --release
  
  web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build web --release
```

---

## 📦 Build Artifacts

### Artifact Locations

```
iOS:
  build/ios/iphoneos/Runner.app
  
Android:
  build/app/outputs/flutter-apk/app-release.apk
  build/app/outputs/bundle/release/app-release.aab

Web:
  build/web/

macOS:
  build/macos/Build/Products/Release/flutter_saas_starter.app

Windows:
  build/windows/runner/Release/

Linux:
  build/linux/x64/release/bundle/
```

---

## 🎓 Best Practices

### Build Optimization

```bash
# Obfuscation (güvenlik)
flutter build apk --obfuscate --split-debug-info=./debug-info

# Tree shaking (boyut)
flutter build web --tree-shake-icons

# Profile mode (performance testing)
flutter build ios --profile
```

### Version Management

```yaml
# pubspec.yaml
version: 1.2.3+45
#        │ │ │  └─ Build number
#        │ │ └──── Patch
#        │ └────── Minor
#        └──────── Major
```

### Testing Before Release

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/

# Performance test
flutter run --profile
```

---

## 🆘 Genel Sorun Giderme

### Flutter Doctor

```bash
flutter doctor -v
flutter doctor --android-licenses
```

### Cache Temizleme

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Dependency Conflicts

```bash
flutter pub outdated
flutter pub upgrade
```

---

## 📞 Platform-Specific Support

- **iOS**: https://developer.apple.com/support/
- **Android**: https://developer.android.com/support
- **Web**: https://flutter.dev/docs/deployment/web
- **Desktop**: https://flutter.dev/desktop

---

**Her platformda başarılar! 🚀**

