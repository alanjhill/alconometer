import 'package:alconometer/features/diary/diary_list.dart';
import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diaryEntriesByWeekOfYearStreamProvider = StreamProvider.autoDispose.family<List<DiaryEntryAndDrink>, DateTime>(
  (ref, dateTime) {
    final database = ref.watch(databaseProvider);
    return database.diaryEntryAndDrinkByWeekStream(dateTime);
  },
);

class WeekView extends ConsumerWidget {
  const WeekView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final AsyncValue<List<DiaryEntryAndDrink>> diaryEntryAndDrinkListAsyncValue = ref.watch(diaryEntriesByWeekOfYearStreamProvider(appState.displayedDate!));
    return DiaryEntryAndDrinkList(diaryEntryAndDrinkData: diaryEntryAndDrinkListAsyncValue);
  }
}
