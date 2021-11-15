import 'package:alconometer/features/auth/auth_screen.dart';
import 'package:alconometer/features/diary/diary_screen.dart';
import 'package:alconometer/features/data/data_screen.dart';
import 'package:alconometer/features/drinks/drinks_screen.dart';
import 'package:alconometer/features/settings/settings_screen.dart';
import 'package:alconometer/features/home/drinks_tab_manager.dart';
import 'package:alconometer/features/home/home_screen.dart';
import 'package:alconometer/features/home/tab_manager.dart';
import 'package:alconometer/features/loading/loading_screen.dart';
import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/providers/auth.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:alconometer/routing/app_router.dart';
import 'package:alconometer/theme/alconometer_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
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
        ChangeNotifierProxyProvider<Auth, Drinks>(
          create: (context) => Drinks(Provider.of<Auth>(context, listen: false).token!, Provider.of<Auth>(context, listen: false).userId!, []),
          update: (_, Auth? auth, previousDrinks) {
            if (auth != null) {
              return Drinks(auth.token, auth.userId, previousDrinks!.items);
            } else {
              return Drinks.emptyValues();
            }
          },
        ),
        ChangeNotifierProxyProvider<Auth, DiaryEntries>(
          create: (context) => DiaryEntries(Provider.of<Auth>(context, listen: false).token!, Provider.of<Auth>(context, listen: false).userId!, []),
          update: (_, Auth? auth, previousDiaryEntries) {
            if (auth != null) {
              return DiaryEntries(auth.token, auth.userId, previousDiaryEntries!.items);
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
                home: authData.isAuth
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
        },
      ),
    );
  }
}
