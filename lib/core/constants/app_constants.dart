class AppConstants {
  // App
  static const String appName = 'Flutter SaaS Starter';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingComplete = 'onboarding_complete';
  
  // Collections
  static const String collectionUsers = 'users';
  static const String collectionTodos = 'todos';
  
  // Subscription
  static const int maxFreeTodos = 5;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  
  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);
}

