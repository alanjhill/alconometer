import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  DatabaseService._();

  static final instance = DatabaseService._();
  final FirebaseApp app = Firebase.app('[DEFAULT]');

  DatabaseReference get database {
    return FirebaseDatabase(app: app).reference();
  }

  Stream<T> itemStream<T>({
    required String uid,
    required String name,
    required String itemId,
    required T Function(String key, Map<String, dynamic> jsonData) builder,
  }) {
    handleData(Event event, EventSink<T> sink) {
      final map = Map<String, dynamic>.from(event.snapshot.value);
      final item = builder(event.snapshot.key!, Map<String, dynamic>.from(map));
      sink.add(item);
      debugPrint('item: $item');
      return item;
    }

    final transformer = StreamTransformer<Event, T>.fromHandlers(handleData: handleData);
    final query = database.child(name).child(uid).child(itemId);
    return query.onValue.transform(transformer);
  }

  Stream<List<T>> dataStream<T>({
    required String name,
    required String uid,
    required String orderByField,
    required T Function(String key, Map<String, dynamic> jsonData) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    handleData(Event event, EventSink<List<T>> sink) {
      try {
        final map = event.snapshot.value != null ? Map<String, dynamic>.from(event.snapshot.value) : {};
        final List<T> list = map.entries.map<T>((element) {
          final thing = builder(element.key, Map<String, dynamic>.from(element.value));
          return thing;
        }).toList();
        sink.add(list);
        return list;
      } catch (error, stackTrace) {
        debugPrint(error.toString());
        rethrow;
      }
    }

    try {
      final transformer = StreamTransformer<Event, List<T>>.fromHandlers(handleData: handleData);
      Query query = database.child(name).child(uid).orderByChild(orderByField);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      return query.onValue.transform(transformer);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> move<T>({
    required String name,
    required String rename,
    required String uid,
    required String itemId,
  }) async {
    DatabaseReference oldRef = database.child(name).child(uid).child(itemId);
    DatabaseReference newRef = database.child(rename).child(uid).child(itemId);
    oldRef.once().then((val) {
      newRef.push().set(val.value).then((val) {
        oldRef.remove();
      }, onError: (error, stackTrace) {
        debugPrint('>>> 1, ${error.toString()}');
        debugPrint(stackTrace.toString());
      });
    }, onError: (error, stackTrace) {
      debugPrint('>>> 2, ${error.toString()}');
      debugPrint(stackTrace.toString());
    });
  }

  Future<void> addData<T>({
    required String name,
    required String uid,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    database.child(name).child(uid).push().set(data);
  }

  Future<void> updateData<T>({
    required String name,
    required String uid,
    required String itemId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      database.child(name).child(uid).child(itemId).set(data);
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> deleteData<T>({
    required String name,
    required String uid,
    required String itemId,
  }) async {
    database.child(name).child(uid).child(itemId).remove();
  }
}
