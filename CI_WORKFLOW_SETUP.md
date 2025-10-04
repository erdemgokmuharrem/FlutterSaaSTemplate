# GitHub Actions CI/CD Workflow Kurulumu

GitHub Actions workflow dosyası OAuth scope kısıtlaması nedeniyle otomatik olarak push edilemedi.

## Manuel Kurulum Adımları

### Yöntem 1: GitHub Web UI Üzerinden

1. GitHub repository'nize gidin: https://github.com/erdemgokmuharrem/FlutterSaaSTemplate
2. **Actions** sekmesine tıklayın
3. **"set up a workflow yourself"** veya **"New workflow"** butonuna tıklayın
4. Workflow dosyasını oluşturun:

**Dosya adı**: `.github/workflows/ci.yml`

**İçerik**:
```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  analyze:
    name: Analyze and Test
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .
      
      - name: Analyze code
        run: flutter analyze
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          fail_ci_if_error: false
  
  build-android:
    name: Build Android APK
    runs-on: ubuntu-latest
    needs: analyze
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
  
  build-ios:
    name: Build iOS (macOS only)
    runs-on: macos-latest
    needs: analyze
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      - name: Build iOS (no codesign)
        run: flutter build ios --release --no-codesign
```

5. **"Commit changes"** butonuna tıklayın

### Yöntem 2: Git ile SSH Kullanarak

Eğer SSH key'iniz GitHub'a ekliyse:

```bash
# Remote'u SSH'e değiştir
git remote set-url origin git@github.com:erdemgokmuharrem/FlutterSaaSTemplate.git

# Workflow dosyasını commit et ve push et
git add .github/workflows/ci.yml
git commit -m "ci: add GitHub Actions workflow"
git push origin main
```

### Yöntem 3: Personal Access Token ile (workflow scope ile)

1. GitHub Settings > Developer settings > Personal access tokens
2. Yeni token oluştur
3. **workflow** scope'unu seç
4. Token'ı kopyala
5. Git credential'larını güncelle:

```bash
# Token'ı kullanarak push et
git push https://YOUR_TOKEN@github.com/erdemgokmuharrem/FlutterSaaSTemplate.git main
```

## Dosya Konumu

Workflow dosyası lokal olarak mevcut:
- Konum: `.github/workflows/ci.yml`
- Durum: Staged (commit için hazır)

Yukarıdaki yöntemlerden birini kullanarak workflow'u repository'nize ekleyebilirsiniz.

## Doğrulama

Workflow eklendikten sonra:
1. GitHub repository'nizde **Actions** sekmesine gidin
2. Workflow'un listelendiğini kontrol edin
3. Yeni commit'lerde otomatik olarak çalışacaktır

## Not

Workflow dosyası olmadan proje tamamen fonksiyonel. CI/CD sadece otomatik test ve build için. İsterseniz daha sonra da ekleyebilirsiniz.

