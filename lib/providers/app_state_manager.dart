import 'package:alconometer/providers/app_cache.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DiaryType { day, week }

class BottomTab {
  static const int diary = 0;
  static const int drinks = 1;
  static const int data = 2;
  static const int settings = 3;
}

class AppStateManager extends ChangeNotifier {
  bool _loggedIn = false;

  DateTime _selectedDate = DateTime.now();
  DiaryType _diaryType = DiaryType.day;
  DrinkType _drinkType = DrinkType.beer;
  int _selectedBottomTab = BottomTab.diary;
  final _appCache = AppCache();

  bool get isLoggedIn => _loggedIn;
  DateTime get selectedDate => _selectedDate;
  DiaryType get diaryType => _diaryType;
  DrinkType get drinkType => _drinkType;
  int get selectedBottomTab => _selectedBottomTab;
  int get selectedDiaryTab {
    return DiaryType.values.indexOf(_diaryType);
  }

  void initializeApp(BuildContext context) async {
    _loggedIn = await _appCache.isUserLoggedIn();
  }

  void goToBottomTab(index) {
    _selectedBottomTab = index;
    notifyListeners();
  }

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  void setDiaryType(DiaryType diaryType) {
    final weekday = selectedDate.weekday;
    debugPrint('weekday: $weekday');
    _selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day).subtract(Duration(days: weekday - 1));
    debugPrint('setDiaryViewType: $diaryType, dateTime: ${_selectedDate.toIso8601String()}');
    _diaryType = diaryType;
    notifyListeners();
  }

  void setDrinkType(DrinkType drinkType) {
    _drinkType = drinkType;
    notifyListeners();
  }
}
