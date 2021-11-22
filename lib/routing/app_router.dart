import 'package:alconometer/features/auth/auth_screen.dart';
import 'package:alconometer/features/diary/diary_screen.dart';
import 'package:alconometer/features/diary/edit_diary_entry.dart';
import 'package:alconometer/features/drinks/drinks_screen.dart';
import 'package:alconometer/features/drinks/edit_drink.dart';
import 'package:alconometer/features/home/home_screen.dart';
import 'package:alconometer/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(BuildContext context, RouteSettings settings /*, UserDao userDao*/) {
/*    if (!userDao.isLoggedIn()) {
      return MaterialPageRoute(builder: (_) => const AuthScreen());
    }*/
    final args = settings.arguments;
    debugPrint('args: $args');
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case DiaryScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DiaryScreen());
      case DrinksScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DrinksScreen());
      case SettingsScreen.routeName:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case EditDiaryEntry.routeName:
        return MaterialPageRoute(builder: (_) => EditDiaryEntry(args: args as EditDiaryEntryArguments));
      case EditDrink.routeName:
        return MaterialPageRoute(builder: (_) => EditDrink(args: args as EditDrinkArguments));
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
    }
  }
}
