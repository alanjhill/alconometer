import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabManagerProvider = Provider<TabManagerNotifier>((ref) => TabManagerNotifier());

class TabManagerNotifier extends StateNotifier<int> {
  TabManagerNotifier([state]) : super(state ?? 0);

  void goToTab(index) {
    state = index;
  }

  void goToDiary() {
    state = 0;
  }

  void goToDrinks() {
    state = 1;
  }

  void goToData() {
    state = 2;
  }

  void goToSettings() {
    state = 3;
  }
}
