import 'package:alconometer/features/auth/auth_screen.dart';
import 'package:alconometer/features/auth/authentication_service.dart';
import 'package:alconometer/features/home/drinks_tab_manager.dart';
import 'package:alconometer/features/home/tab_manager.dart';
import 'package:alconometer/features/loading/loading_screen.dart';
import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/providers/auth.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:alconometer/routing/app_router.dart';
import 'package:alconometer/theme/alconometer_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

Future<void> initSettings() async {
/*  await Settings.init(
    cacheProvider: SharePreferenceCache(),
  );*/
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appStateManager = AppStateManager();
  late final AppSettingsManager _appSettingsManager;

  @override
  void initState() {
    super.initState();
    _appSettingsManager = AppSettingsManager();
    _appSettingsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(
            FirebaseAuth.instance,
          ),
        ),
        StreamProvider<User?>(initialData: null, create: (context) => context.read<AuthenticationService>().authStateChanges),

        ///
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider<AppStateManager>(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider<AppSettingsManager>(
          create: (context) => _appSettingsManager,
        ),
        ChangeNotifierProvider(
          create: (context) => TabManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => DrinksTabManager(),
        ),
        ChangeNotifierProxyProvider<User, Drinks>(
          create: (context) {
            Provider.of<User>(context, listen: false).getIdToken().then((idToken) {
              if (idToken != null) {
                return Drinks(idToken, Provider.of<User>(context, listen: false).uid, []);
              }
            });
            return Drinks.emptyValues();
          },
          update: (_, User? user, previousDrinks) {
            if (user != null) {
              user.getIdToken().then((idToken) {
                return Drinks(idToken, user.uid, previousDrinks!.items);
              });
              return Drinks.emptyValues();
            } else {
              return Drinks.emptyValues();
            }
          },
        ),
        ChangeNotifierProxyProvider<User, DiaryEntries>(
          create: (context) {
            Provider.of<User>(context, listen: false).getIdToken().then((idToken) {
              if (idToken != null) {
                return DiaryEntries(idToken, Provider.of<User>(context, listen: false).uid, []);
              }
            });
            return DiaryEntries.emptyValues();
          },
          update: (_, User? user, previousDiaryEntries) {
            if (user != null) {
              user.getIdToken().then((idToken) {
                if (idToken != null) {
                  return DiaryEntries(idToken, user.uid, previousDiaryEntries!.items);
                }
              });
              return DiaryEntries.emptyValues();
            } else {
              return DiaryEntries.emptyValues();
            }
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (_, authData, __) {
          return Consumer<AppSettingsManager>(
            builder: (context, appSettingsManager, child) {
              ThemeData theme;
              if (appSettingsManager.darkMode) {
                theme = AlconometerTheme.dark();
              } else {
                theme = AlconometerTheme.light();
              }

              return MaterialApp(
                title: 'Alconometer',
                theme: theme,
                home: AuthenticationWrapper(),
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
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return LoadingScreen();
    }
    return AuthScreen();
  }
}

/*authData.isAuth
                    ? const LoadingScreen()
                    : FutureBuilder(
                        future: authData.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) {
                          if (authResultSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return const AuthScreen();
                          }
                        },
                      ),*/
