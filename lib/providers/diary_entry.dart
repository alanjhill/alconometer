import 'package:alconometer/providers/drink.dart';
import 'package:flutter/foundation.dart';

@immutable
class DiaryEntry {
  final String? id;
  final DateTime? dateTime;
  final String? drinkId;
  final double? volume;
  final double? units;

  const DiaryEntry({
    required this.id,
    required this.dateTime,
    required this.drinkId,
    required this.volume,
    this.units,
  });

  static DiaryEntry fromMap(String key, Map<String, dynamic> diaryEntry) {
    return DiaryEntry(
      id: key,
      drinkId: diaryEntry['drinkId'],
      dateTime: diaryEntry['name'],
      volume: diaryEntry['volume'],
    );
  }

  DiaryEntry copyWith({
    String? id,
    DateTime? dateTime,
    String? drinkId,
    double? volume,
    double? units,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      drinkId: drinkId ?? this.drinkId,
      volume: volume ?? this.volume,
      units: units ?? this.units,
    );
  }
}
