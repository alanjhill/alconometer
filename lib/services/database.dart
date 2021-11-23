import 'package:alconometer/providers/diary_entry.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class Database {
  Database({required this.uid});
  final String uid;

  final _service = DatabaseService.instance;

  /// Get all drinks for a uid
  Stream<List<Drink>> drinksStream() => _service.dataStream<Drink>(
        uid: uid,
        name: 'drinks',
        builder: (Object? key, Object? dataMap) {
          return Drink.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
      );

  Stream<List<DiaryEntry>> diaryEntriesStream() => _service.dataStream<DiaryEntry>(
        uid: uid,
        name: 'diary_entries',
        builder: (Object? key, Object? dataMap) {
          return DiaryEntry.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
      );
}
