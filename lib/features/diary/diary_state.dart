import 'package:alconometer/providers/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diaryStateProvider = StateNotifierProvider<DiaryStateNotifier, DiaryState>((ref) => DiaryStateNotifier());

class DiaryStateNotifier extends StateNotifier<DiaryState> {
  DiaryStateNotifier()
      : super(
          DiaryState(
            selectedTab: 0,
          ),
        );

  void goToTab(DiaryType type) {
    switch (type) {
      case DiaryType.day:
        final newState = state.copyWith(selectedTab: 0);
        state = newState;
        break;
      case DiaryType.week:
        final newState = state.copyWith(selectedTab: 1);
        state = newState;
        break;
    }
  }

  void goToDay() {
    final newState = state.copyWith(selectedTab: 0);
    state = newState;
  }

  void goToWeek() {
    final newState = state.copyWith(selectedTab: 1);
    state = newState;
  }
}

class DiaryState {
  final int? selectedTab;

  DiaryState({
    this.selectedTab,
  });

  DiaryState copyWith({
    int? selectedTab,
  }) =>
      DiaryState(
        selectedTab: selectedTab ?? this.selectedTab,
      );
}
