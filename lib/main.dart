import 'package:alconometer/features/auth/auth_screen.dart';
import 'package:alconometer/features/home/home_screen.dart';
import 'package:alconometer/features/loading/loading_screen.dart';
import 'package:alconometer/features/settings/settings_screen.dart';
import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/routing/app_router.dart';
import 'package:alconometer/theme/alconometer_theme.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppSettingsManager _appSettingsManager;

  @override
  void initState() {
    super.initState();
    _appSettingsManager = AppSettingsManager();
    _appSettingsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, child) {
        final appSettingsManager = ref.watch(appSettingsManagerProvider);
        ThemeData theme;
        if (appSettingsManager.darkMode) {
          theme = AlconometerTheme.dark();
        } else {
          theme = AlconometerTheme.light();
        }

        return MaterialApp(
          title: 'alcon-o-meter',
          theme: theme,
          home: AuthWidget(
            signedInBuilder: (_) => const LoadingScreen(),
            nonSignedInBuilder: (_) => const AuthScreen(),
          ),
          onGenerateRoute: (settings) => AppRouter.onGenerateRoute(context, settings),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
          ],
        );
      },
    );
  }
}

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key? key,
    required this.signedInBuilder,
    required this.nonSignedInBuilder,
  }) : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) {
        debugPrint('Auth 1');
        return _data(context, user);
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: Text('oops'),
      ),
    );
  }

  Widget _data(BuildContext context, User? user) {
    if (user != null) {
      return signedInBuilder(context);
    }
    return nonSignedInBuilder(context);
  }
}
