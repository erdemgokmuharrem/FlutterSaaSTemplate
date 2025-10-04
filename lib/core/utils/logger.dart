import 'dart:developer' as developer;

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class Logger {
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }
  
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }
  
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }
  
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }
  
  static void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final buffer = StringBuffer();
    buffer.write('[${level.name.toUpperCase()}] $message');
    
    if (error != null) {
      buffer.write('\nError: $error');
    }
    
    if (stackTrace != null) {
      buffer.write('\nStackTrace: $stackTrace');
    }
    
    developer.log(
      buffer.toString(),
      name: 'FlutterSaasStarter',
      level: _getLevelValue(level),
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  static int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}

