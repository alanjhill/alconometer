import 'package:equatable/equatable.dart';
import 'package:week_of_year/week_of_year.dart';

class DiaryEntry extends Equatable {
  DiaryEntry({
    this.id,
    required this.dateTime,
    required this.drinkId,
    required this.volume,
  });
  String? id;
  final DateTime? dateTime;
  final String? drinkId;
  final double volume;

  @override
  List<Object> get props => [id!, dateTime!, drinkId!, volume];

  @override
  bool get stringify => true;

  static DiaryEntry fromMap(String key, Map<String, dynamic> diaryEntry) {
    return DiaryEntry(
      id: key,
      drinkId: diaryEntry['drinkId'],
      dateTime: DateTime.parse(diaryEntry['dateTime']),
      volume: diaryEntry['volume'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'dateTime': dateTime!.toUtc().toIso8601String(),
      'dateTimeStart': dateTime!.toUtc().millisecondsSinceEpoch,
      'drinkId': drinkId,
      'volume': volume,
    };
    return map;
  }

  DiaryEntry copyWith({String? id, DateTime? dateTime, String? drinkId, double? volume}) {
    return DiaryEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      drinkId: drinkId ?? this.drinkId,
      volume: volume ?? this.volume,
    );
  }
}
