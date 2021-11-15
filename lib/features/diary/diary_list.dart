import 'package:alconometer/features/diary/diary_summary.dart';
import 'package:alconometer/features/diary/diary_item.dart';
import 'package:alconometer/providers/diary_entry.dart';
import 'package:flutter/material.dart';

class DiaryList extends StatelessWidget {
  const DiaryList({Key? key, required this.diaryEntries}) : super(key: key);
  final List<DiaryEntry> diaryEntries;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DiarySummary(diaryEntries: diaryEntries),
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              Column(children: <Widget>[
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: diaryEntries.length,
                  itemBuilder: (content, index) => DiaryItem(
                    diaryEntry: diaryEntries[index],
                    index: index,
                  ),
                )
              ]),
            ]),
          ),
        ),
      ],
    );
  }
}
