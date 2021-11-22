import 'package:alconometer/providers/drink.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drinksStateProvider = StateNotifierProvider<DrinksStateNotifier, DrinksState>((ref) {
  return DrinksStateNotifier();
});

class DrinksStateNotifier extends StateNotifier<DrinksState> {
  DrinksStateNotifier()
      : super(
          DrinksState(
            selectedTab: 0,
          ),
        );

  void goToTab(DrinkType type) {
    switch (type) {
      case DrinkType.beer:
        final newState = state.copyWith(selectedTab: 0);
        state = newState;
        break;
      case DrinkType.wine:
        final newState = state.copyWith(selectedTab: 1);
        state = newState;
        break;
      case DrinkType.spirit:
        final newState = state.copyWith(selectedTab: 2);
        state = newState;
        break;
    }
  }

  void goToBeer() {
    final newState = state.copyWith(selectedTab: 0);
    state = newState;
  }

  void goToWine() {
    final newState = state.copyWith(selectedTab: 1);
    state = newState;
  }

  void goToSpirit() {
    final newState = state.copyWith(selectedTab: 2);
    state = newState;
  }
}

class DrinksState {
  DrinksState({this.selectedTab});

  final int? selectedTab;

  DrinksState copyWith({
    int? selectedTab,
  }) =>
      DrinksState(
        selectedTab: selectedTab ?? this.selectedTab,
      );
}
