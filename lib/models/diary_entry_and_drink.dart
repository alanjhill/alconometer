import 'package:alconometer/models/diary_entry.dart';
import 'package:alconometer/models/drink.dart';

class DiaryEntryAndDrink {
  final DiaryEntry diaryEntry;
  final Drink drink;
  final double units;

  DiaryEntryAndDrink({required this.diaryEntry, required this.drink, required this.units});
}
