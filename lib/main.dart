import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_saas_starter/core/theme/app_theme.dart';
import 'package:flutter_saas_starter/core/router/app_router.dart';
import 'package:flutter_saas_starter/core/utils/logger.dart';
import 'package:flutter_saas_starter/shared/providers/theme_provider.dart';
import 'package:flutter_saas_starter/shared/providers/locale_provider.dart';
import 'package:flutter_saas_starter/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_saas_starter/features/subscription/presentation/providers/subscription_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    Logger.info('Firebase initialized successfully');
    
    // Initialize Hive
    await Hive.initFlutter();
    Logger.info('Hive initialized successfully');
    
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize app', error: e, stackTrace: stackTrace);
    rethrow;
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeSubscriptions();
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

