import 'dart:async';

import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseService {
  DatabaseService._();
  static final instance = DatabaseService._();
  final FirebaseApp app = Firebase.app('[DEFAULT]');
  DatabaseReference get database {
    return FirebaseDatabase(app: app).reference();
  }

  Stream<List<T>> dataStream<T>({
    required String uid,
    required String name,
    required T Function(String key, Map<String, dynamic> jsonData) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    handleData(Event event, EventSink<List<T>> sink) {
      final map = Map<String, dynamic>.from(event.snapshot.value);
      final List<T> list = map.entries.map<T>((element) {
        return builder(element.key, Map<String, dynamic>.from(element.value));
      }).toList();
      sink.add(list);
      return list;
    }

    final transformer = StreamTransformer<Event, List<T>>.fromHandlers(handleData: handleData);
    final query = database.child(name).child(uid).orderByKey();
    return query.onValue.transform(transformer);
  }
}
