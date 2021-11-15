import 'package:alconometer/providers/app_state_manager.dart';
import 'package:flutter/material.dart';

class DiaryTabManager extends ChangeNotifier {
  int selectedTab = 0;

  void goToTab(DiaryType type) {
    switch (type) {
      case DiaryType.day:
        selectedTab = 0;
        break;
      case DiaryType.week:
        selectedTab = 1;
        break;
    }
    notifyListeners();
  }

  void goToDay() {
    selectedTab = 0;
    notifyListeners();
  }

  void goToWeek() {
    selectedTab = 1;
    notifyListeners();
  }
}
