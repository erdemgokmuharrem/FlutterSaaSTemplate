// Copy from config.example.dart and fill in your actual values
// This file is gitignored by default

class AppConfig {
  // RevenueCat API Keys
  static const String revenueCatApiKeyIos = 'YOUR_REVENUECAT_IOS_API_KEY';
  static const String revenueCatApiKeyAndroid = 'YOUR_REVENUECAT_ANDROID_API_KEY';
  
  // RevenueCat Entitlement ID
  static const String premiumEntitlementId = 'premium';
  
  // App Configuration
  static const String appName = 'Flutter SaaS Starter';
  static const bool enableAppleSignIn = true;
  static const bool enableGoogleSignIn = true;
  
  // Feature Flags
  static const bool enablePushNotifications = false;
  static const bool enableAnalytics = false;
  
  // API endpoints (if needed for custom backend)
  static const String apiBaseUrl = 'https://your-api.com';
}

