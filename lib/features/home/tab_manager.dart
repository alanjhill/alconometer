import 'package:flutter/material.dart';

class TabManager extends ChangeNotifier {
  int selectedTab = 0;

  void goToTab(index) {
    selectedTab = index;
    notifyListeners();
  }

  void goToDiary() {
    selectedTab = 0;
    notifyListeners();
  }

  void goToDrinks() {
    selectedTab = 1;
    notifyListeners();
  }

  void goToData() {
    selectedTab = 2;
    notifyListeners();
  }

  void goToSettings() {
    selectedTab = 3;
    notifyListeners();
  }
}
