import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_saas_starter/core/theme/app_theme.dart';
import 'package:flutter_saas_starter/core/router/app_router.dart';
import 'package:flutter_saas_starter/core/utils/logger.dart';
import 'package:flutter_saas_starter/core/config/firebase_options.dart';
import 'package:flutter_saas_starter/shared/providers/theme_provider.dart';
import 'package:flutter_saas_starter/shared/providers/locale_provider.dart';
import 'package:flutter_saas_starter/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_saas_starter/features/subscription/presentation/providers/subscription_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseInitialized = false;
  
  try {
    // Initialize Firebase with demo options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Logger.info('Firebase initialized successfully');
    firebaseInitialized = true;
  } catch (e, stackTrace) {
    Logger.warning('Firebase initialization failed - running in DEMO MODE', error: e);
    Logger.warning('To use full features, please configure Firebase (see FIREBASE_SETUP.md)');
  }
  
  try {
    // Initialize Hive
    await Hive.initFlutter();
    Logger.info('Hive initialized successfully');
  } catch (e, stackTrace) {
    Logger.error('Hive initialization failed', error: e, stackTrace: stackTrace);
  }
  
  runApp(
    ProviderScope(
      child: MyApp(isFirebaseEnabled: firebaseInitialized),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final bool isFirebaseEnabled;
  
  const MyApp({
    super.key,
    this.isFirebaseEnabled = false,
  });

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    if (widget.isFirebaseEnabled) {
      _initializeSubscriptions();
    } else {
      Logger.info('Running in DEMO MODE - Firebase features disabled');
    }
  }

  Future<void> _initializeSubscriptions() async {
    // Listen to auth state changes and initialize RevenueCat
    ref.listen(authStateProvider, (previous, next) async {
      if (next.hasValue && next.value != null) {
        try {
          await ref
              .read(subscriptionControllerProvider)
              .initialize(next.value!.id);
          Logger.info('RevenueCat initialized for user: ${next.value!.id}');
        } catch (e) {
          Logger.error('Failed to initialize RevenueCat', error: e);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Flutter SaaS Starter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

