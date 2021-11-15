import 'package:alconometer/providers/drink.dart';
import 'package:flutter/foundation.dart';

@immutable
class DiaryEntry {
  final String? id;
  final DateTime? dateTime;
  final Drink? drink;
  final double? volume;
  final double? units;

  const DiaryEntry({
    required this.id,
    required this.dateTime,
    required this.drink,
    required this.volume,
    required this.units,
  });

  DiaryEntry copyWith({
    String? id,
    DateTime? dateTime,
    Drink? drink,
    double? volume,
    double? units,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      drink: drink ?? this.drink,
      volume: volume ?? this.volume,
      units: units ?? this.units,
    );
  }
}

final dummyDiaryEntries = [
  DiaryEntry(id: '', dateTime: DateTime.now(), drink: beer, volume: 473.0, units: 2.5),
  DiaryEntry(id: '', dateTime: DateTime.now(), drink: beer, volume: 473.0, units: 2.5),
  DiaryEntry(id: '', dateTime: DateTime.now(), drink: beer, volume: 473.0, units: 2.5),
];
