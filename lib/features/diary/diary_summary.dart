import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiarySummary extends ConsumerWidget {
  const DiarySummary({Key? key, required this.diaryEntries}) : super(key: key);
  final List<DiaryEntryAndDrink> diaryEntries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);
    final appState = ref.watch(appStateProvider);
    final textColor = getTextColor(appState.diaryType!, appSettings.weeklyAllowance!, _getTotalUnits(diaryEntries: diaryEntries));
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _SliverPersistentHeaderDelegate(
        Theme.of(context).canvasColor,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _getTotalUnits(diaryEntries: diaryEntries).toStringAsFixed(2),
              style: TextStyle(fontSize: 24, color: textColor),
            ),
            Text(
              'UNITS',
              style: TextStyle(fontSize: 24, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  double _getTotalUnits({required List<DiaryEntryAndDrink> diaryEntries}) {
    var total = 0.0;
    for (var diaryEntryAndDrink in diaryEntries) {
      total += diaryEntryAndDrink.units;
    }
    return total;
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Color _backgroundColor;
  final Widget _title;
  _SliverPersistentHeaderDelegate(this._backgroundColor, this._title);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 48,
      color: _backgroundColor,
      child: _title,
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
