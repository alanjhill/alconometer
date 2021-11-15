import 'package:alconometer/providers/diary_entry.dart';
import 'package:flutter/material.dart';

class DiarySummary extends StatelessWidget {
  const DiarySummary({Key? key, required this.diaryEntries}) : super(key: key);

  final List<DiaryEntry> diaryEntries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _getTotalUnits(diaryEntries: diaryEntries).toString(),
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 18),
          Text(
            'UNITS',
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getTotalUnits({required List<DiaryEntry> diaryEntries}) {
    var total = 0.0;
    for (var diaryEntry in diaryEntries) {
      total += diaryEntry.units!;
    }
    return total.toStringAsFixed(2);
  }
}
