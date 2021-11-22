import 'package:alconometer/features/diary/diary_list.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week_of_year/week_of_year.dart';

class WeekView extends ConsumerWidget {
  //WeekView({Key? key, required this.diaryEntries}) : super(key: key);
  //List<DiaryEntry> diaryEntries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final diaryEntriesNotifier = ref.read(diaryEntriesProvider.notifier);
    final diaryEntriesList = diaryEntriesNotifier.findByWeek(appState.displayedDate!.weekOfYear);
    return DiaryList(diaryEntries: diaryEntriesList);
  }
}
