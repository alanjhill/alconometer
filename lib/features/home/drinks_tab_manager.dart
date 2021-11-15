import 'package:alconometer/providers/drink.dart';
import 'package:flutter/material.dart';

class DrinksTabManager extends ChangeNotifier {
  int selectedTab = 0;

  void goToTab(DrinkType type) {
    switch (type) {
      case DrinkType.beer:
        selectedTab = 0;
        break;
      case DrinkType.wine:
        selectedTab = 1;
        break;
      case DrinkType.spirit:
        selectedTab = 2;
        break;
    }
    notifyListeners();
  }

  void goToBeer() {
    selectedTab = 0;
    notifyListeners();
  }

  void goToWine() {
    selectedTab = 1;
    notifyListeners();
  }

  void goToSpirit() {
    selectedTab = 2;
    notifyListeners();
  }
}
