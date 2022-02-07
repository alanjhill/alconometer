import 'package:alconometer/features/diary/diary_list.dart';
import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diaryEntriesByDateTimeStreamProvider = StreamProvider.autoDispose.family<List<DiaryEntryAndDrink>, DateTime>(
  (ref, dateTime) {
    final database = ref.watch(databaseProvider);
    return database.diaryEntryAndDrinkByDateTimeStream(dateTime);
  },
);

class DayView extends ConsumerWidget {
  const DayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final AsyncValue<List<DiaryEntryAndDrink>> diaryEntryAndDrinkListAsyncValue = ref.watch(
      diaryEntriesByDateTimeStreamProvider(appState.displayedDate!),
    );
    return DiaryEntryAndDrinkList(
      diaryEntryAndDrinkData: diaryEntryAndDrinkListAsyncValue,
    );
  }
}
