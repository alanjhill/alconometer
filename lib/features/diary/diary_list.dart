import 'package:alconometer/features/diary/diary_item.dart';
import 'package:alconometer/features/diary/diary_summary.dart';
import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DiaryEntryAndDrinkList extends ConsumerWidget {
  const DiaryEntryAndDrinkList({Key? key, required this.diaryEntryAndDrinkData}) : super(key: key);
  final AsyncValue<List<DiaryEntryAndDrink>> diaryEntryAndDrinkData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return diaryEntryAndDrinkData.when(
      data: (items) => items.isNotEmpty ? _buildList(ref, items) : const EmptyContent(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now: $error, $stackTrace',
      ),
    );
  }

  Widget _buildList(WidgetRef ref, List<DiaryEntryAndDrink> diaryEntryAndDrinkData) {
    //final appState = ref.watch(appStateProvider);
    diaryEntryAndDrinkData.sort((a, b) => a.diaryEntry.dateTime!.compareTo(b.diaryEntry.dateTime!));
    int previousDay = -1;
    bool displayDay = false;
    return SlidableAutoCloseBehavior(
      child: CustomScrollView(
        slivers: <Widget>[
          DiarySummary(diaryEntries: diaryEntryAndDrinkData),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                //return Text('ALAN', key: ValueKey('$index'));
                final dt = diaryEntryAndDrinkData[index].diaryEntry.dateTime!.toLocal();
                final day = dt.weekday;
                if (day != previousDay) {
                  displayDay = true;
                } else {
                  displayDay = false;
                }
                previousDay = day;
                return DiaryItem(
                  diaryEntryAndDrink: diaryEntryAndDrinkData[index],
                  index: index,
                  displayDay: displayDay,
                );
              },
              childCount: diaryEntryAndDrinkData.length,
            ),
          ),
        ],
      ),
    );
  }
}
