import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:flutter/material.dart';
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
          displayedDate: getDateTimeNow(),
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
    final utcDate = displayedDate.toUtc();
    final newState = state.copyWith(displayedDate: utcDate);
    state = newState;
  }

  DateTime get displayedDate {
    final localDate = displayedDate.toLocal();
    return localDate;
  }

  void prevDisplayedDate() {
    if (state.diaryType == DiaryType.day) {
      setDisplayedDate(DateTime(state.displayedDate!.year, state.displayedDate!.month, state.displayedDate!.day - 1));
    } else {
      setDisplayedDate(DateTime(state.displayedDate!.year, state.displayedDate!.month, state.displayedDate!.day - 7));
    }
  }

  void nextDisplayedDate() {
    if (state.diaryType == DiaryType.day) {
      setDisplayedDate(DateTime(state.displayedDate!.year, state.displayedDate!.month, state.displayedDate!.day + 1));
    } else {
      setDisplayedDate(DateTime(state.displayedDate!.year, state.displayedDate!.month, state.displayedDate!.day + 7));
    }
  }

  void setDiaryType(DiaryType diaryType, String firstDayOfWeek) {
    final weekday = state.displayedDate!.weekday;
    debugPrint('>>> setDiaryType: firstDayOfWeek: $firstDayOfWeek, weekday: $weekday');
    var now = DateTime.now().toLocal();
    if (diaryType == DiaryType.week) {
      var days = 0;
      final dayOfWeek = firstDayOfWeek == AppSettingsConstants.firstDayOfWeek[0] ? 7 : 1;
      if (weekday != dayOfWeek) {
        days = firstDayOfWeek == AppSettingsConstants.firstDayOfWeek[0] ? weekday : weekday - 1;
      }
      final displayedDate = DateTime.utc(
        state.displayedDate!.year,
        state.displayedDate!.month,
        state.displayedDate!.day,
        now.hour,
        now.minute,
        now.second,
        now.microsecond,
      ).subtract(Duration(days: days));
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
  final bool? loggedIn;
  final DateTime? displayedDate;
  final DiaryType? diaryType;
  final DrinkType? drinkType;
  final int? selectedBottomTab;

  AppState({
    this.loggedIn,
    this.displayedDate,
    this.diaryType,
    this.drinkType,
    this.selectedBottomTab,
  });

  AppState copyWith({
    bool? loggedIn,
    DateTime? displayedDate,
    DiaryType? diaryType,
    DrinkType? drinkType,
    int? selectedBottomTab,
  }) =>
      AppState(
        loggedIn: loggedIn ?? this.loggedIn,
        displayedDate: displayedDate ?? this.displayedDate,
        drinkType: drinkType ?? this.drinkType,
        diaryType: diaryType ?? this.diaryType,
        selectedBottomTab: selectedBottomTab ?? this.selectedBottomTab,
      );
}
