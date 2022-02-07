import 'package:alconometer/features/auth/auth_screen.dart';
import 'package:alconometer/features/home/home_screen.dart';
import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/providers/shared_preferences_service.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/routing/app_router.dart';
import 'package:alconometer/theme/alconometer_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(sharedPreferences),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final AppSettings _appSettings;

  @override
  void initState() {
    super.initState();
    ref.read(appSettingsProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, child) {
        ThemeData theme;
        if (ref.watch(appSettingsProvider).darkMode!) {
          theme = AlconometerTheme.dark();
        } else {
          theme = AlconometerTheme.light();
        }

        return MaterialApp(
          title: 'alcon-o-meter',
          theme: theme,
          debugShowCheckedModeBanner: false,
          home: AuthWidget(
            signedInBuilder: (_) => const HomeScreen(),
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
        return _data(context, user);
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: Text('Sorry, we\'ve messed up!'),
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
