import 'package:alconometer/features/diary/diary_list.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/diary_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayView extends StatelessWidget {
  //DayView({Key? key, required this.diaryEntries}) : super(key: key);
  //List<DiaryEntry> diaryEntries;

  @override
  Widget build(BuildContext context) {
    final dateSelectorProvider = Provider.of<AppStateManager>(context);
    final diaryEntriesData = Provider.of<DiaryEntries>(context);
    final diaryEntries = diaryEntriesData.findByDate(dateSelectorProvider.selectedDate);

    return Scaffold(
      body: DiaryList(diaryEntries: diaryEntries),
    );
  }
}
