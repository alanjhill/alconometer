import 'package:alconometer/providers/drink.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;
}
