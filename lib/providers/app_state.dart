import 'package:alconometer/providers/app_cache.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DiaryType { day, week }

class BottomTab {
  static const int diary = 0;
  static const int drinks = 1;
  static const int data = 2;
  static const int settings = 3;
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) => AppStateNotifier());

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier()
      : super(AppState(
          loggedIn: false,
          displayedDate: DateTime.now(),
          selectedDate: DateTime.now(),
          drinkType: DrinkType.beer,
          diaryType: DiaryType.day,
          selectedBottomTab: BottomTab.diary,
        ));

  void setLoggedIn(bool loggedIn) {
    final newState = state.copyWith(loggedIn: loggedIn);
    state = newState;
  }

  void goToBottomTab(index) {
    final newState = state.copyWith(selectedBottomTab: index);
    state = newState;
  }

  void setDisplayedDate(DateTime displayedDate) {
    final newState = state.copyWith(displayedDate: displayedDate);
    state = newState;
  }

  void setSelectedDate(DateTime selectedDate) {
    final newState = state.copyWith(selectedDate: selectedDate);
    state = newState;
  }

  void setDiaryType(DiaryType diaryType) {
    final weekday = state.displayedDate!.weekday;

    if (diaryType == DiaryType.week) {
      final displayedDate = DateTime(state.displayedDate!.year, state.displayedDate!.month, state.displayedDate!.day).subtract(Duration(days: weekday - 1));
      final newState = state.copyWith(diaryType: diaryType, displayedDate: displayedDate);
      state = newState;
    } else {
      final newState = state.copyWith(diaryType: diaryType);
      state = newState;
    }
  }

  void setDrinkType(DrinkType drinkType) {
    final newState = state.copyWith(drinkType: drinkType);
    state = newState;
  }
}

class AppState {
  final _appCache = AppCache();

  final bool? loggedIn;
  final DateTime? displayedDate;
  final DateTime? selectedDate;
  final DiaryType? diaryType;
  final DrinkType? drinkType;
  final int? selectedBottomTab;

  AppState({
    this.loggedIn,
    this.displayedDate,
    this.selectedDate,
    this.diaryType,
    this.drinkType,
    this.selectedBottomTab,
  });

  AppState copyWith({
    bool? loggedIn,
    DateTime? displayedDate,
    DateTime? selectedDate,
    DiaryType? diaryType,
    DrinkType? drinkType,
    int? selectedBottomTab,
  }) =>
      AppState(
        loggedIn: loggedIn ?? this.loggedIn,
        displayedDate: displayedDate ?? this.displayedDate,
        selectedDate: selectedDate ?? this.selectedDate,
        drinkType: drinkType ?? this.drinkType,
        diaryType: diaryType ?? this.diaryType,
        selectedBottomTab: selectedBottomTab ?? this.selectedBottomTab,
      );
}
/*  void initializeApp(BuildContext context) async {
    _loggedIn = await _appCache.isUserLoggedIn();
  }*/
