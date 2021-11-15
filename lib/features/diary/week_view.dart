import 'package:alconometer/features/diary/diary_list.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_of_year/week_of_year.dart';

class WeekView extends StatelessWidget {
  //WeekView({Key? key, required this.diaryEntries}) : super(key: key);
  //List<DiaryEntry> diaryEntries;

  @override
  Widget build(BuildContext context) {
    final dateSelectorProvider = Provider.of<AppStateManager>(context);
    final diaryEntriesData = Provider.of<DiaryEntries>(context);
    final diaryEntries = diaryEntriesData.findByWeek(dateSelectorProvider.selectedDate.weekOfYear);
    return DiaryList(diaryEntries: diaryEntries);
  }
}
