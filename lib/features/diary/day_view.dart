import 'package:alconometer/features/diary/diary_list.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DayView extends ConsumerWidget {
  //DayView({Key? key, required this.diaryEntries}) : super(key: key);
  //List<DiaryEntry> diaryEntries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final diaryEntriesNotifier = ref.read(diaryEntriesProvider.notifier);
    final diaryEntriesList = diaryEntriesNotifier.findByDate(appState.displayedDate!);
    return DiaryList(diaryEntries: diaryEntriesList);
  }
}
