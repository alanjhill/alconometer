import 'package:alconometer/models/diary_entry.dart';
import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/models/drink.dart';
import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/services/database_service.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const kDrinks = 'drinks';
const kDrinksArchive = 'drinksArchive';
const kDiaryEntries = 'diaryEntries';

class Database {
  Database({required this.uid});

  final String uid;

  final _service = DatabaseService.instance;

  Stream<Drink> drinkStream(String id) => _service.itemStream<Drink>(
        uid: uid,
        name: 'drinks',
        itemId: id,
        builder: (Object? key, Object? dataMap) {
          return Drink.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
      );

  /// Get all drinks for a uid
  Stream<List<Drink>> drinksStream() => _service.dataStream<Drink>(
        name: kDrinks,
        uid: uid,
        orderByField: 'name',
        builder: (Object? key, Object? dataMap) {
          return Drink.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
      );

  /// Get all archived drinks for a uid
  Stream<List<Drink>> drinksArchiveStream() => _service.dataStream<Drink>(
        name: kDrinks,
        uid: uid,
        orderByField: 'name',
        builder: (Object? key, Object? dataMap) {
          return Drink.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
      );

  Stream<List<Drink>> drinksAndDrinksArchiveStream() {
    Stream<List<Drink>> combined = Rx.combineLatest2(drinksStream(), drinksArchiveStream(), (
      List<Drink> drinks,
      List<Drink> drinksArchived,
    ) {
      List<Drink> allDrinks = [...drinks, ...drinksArchived];

      return allDrinks;
    });
    return combined;
  }

  /// Get all drinks for a uid
  Stream<List<Drink>> drinksByTypeStream(DrinkType drinkType) => _service.dataStream<Drink>(
      name: kDrinks,
      uid: uid,
      orderByField: 'type',
      builder: (Object? key, Object? dataMap) {
        return Drink.fromMap(key as String, dataMap as Map<String, dynamic>);
      },
      queryBuilder: (Query query) {
        return query.equalTo(drinkType.toString());
      });

  Future<void> addDrink(Drink drink) => _service.addData(uid: uid, name: kDrinks, data: drink.toMap());

  Future<void> updateDrink(String id, Drink drink) => _service.updateData(
        name: kDrinks,
        uid: uid,
        itemId: id,
        data: drink.toMap(),
      );

  Future<void> archiveDrink(String id) => _service.move(name: kDrinks, rename: kDrinksArchive, uid: uid, itemId: id);

  Future<void> duplicateDrink(Drink drink) {
    final duplicateDrink = drink.copyWith(id: null);
    return _service.addData(uid: uid, name: kDrinks, data: duplicateDrink.toMap());
  }

  Future<void> deleteDrink(String id) => _service.deleteData(
        name: kDrinks,
        uid: uid,
        itemId: id,
      );

  /// Get all drinks for a uid
  Stream<List<DiaryEntry>> diaryEntriesStream() => _service.dataStream<DiaryEntry>(
        name: kDiaryEntries,
        uid: uid,
        orderByField: 'dateTimeStart',
        builder: (Object? key, Object? dataMap) {
          return DiaryEntry.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
      );

  Stream<List<DiaryEntry>> diaryEntriesByDrinkIdStream(String drinkId) => _service.dataStream<DiaryEntry>(
        name: kDiaryEntries,
        uid: uid,
        orderByField: 'drinkId',
        builder: (Object? key, Object? dataMap) {
          return DiaryEntry.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
        queryBuilder: (Query query) {
          return query.equalTo(drinkId);
        },
      );

  Stream<List<DiaryEntry>> diaryEntriesByDateTimeStream(DateTime dateTime) => _service.dataStream<DiaryEntry>(
        name: kDiaryEntries,
        uid: uid,
        orderByField: 'dateTimeStart',
        builder: (Object? key, Object? dataMap) {
          return DiaryEntry.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
        queryBuilder: (Query query) {
          final dateTimeStart = DateTime(dateTime.year, dateTime.month, dateTime.day).toUtc();
          final dateTimeEnd = dateTimeStart.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
          return query.startAt(dateTimeStart.millisecondsSinceEpoch).endAt(dateTimeEnd.millisecondsSinceEpoch);
          //return query.equalTo(dateTimeStart.millisecondsSinceEpoch);
        },
      );

  Stream<List<DiaryEntry>> diaryEntriesByWeekDateTimeStream(DateTime weekStartDateTime) => _service.dataStream<DiaryEntry>(
        uid: uid,
        name: kDiaryEntries,
        orderByField: 'dateTimeStart',
        builder: (Object? key, Object? dataMap) {
          return DiaryEntry.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
        queryBuilder: (Query query) {
          final dateTimeStart = DateTime(weekStartDateTime.year, weekStartDateTime.month, weekStartDateTime.day).toUtc();
          final dateTimeEnd = dateTimeStart.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));
          return query.startAt(dateTimeStart.millisecondsSinceEpoch).endAt(dateTimeEnd.millisecondsSinceEpoch);
        },
      );

  Stream<List<DiaryEntry>> diaryEntriesByCumulativeWeekDateTimeStream(DateTime weekStartDateTime, DateTime dateTime) => _service.dataStream<DiaryEntry>(
        uid: uid,
        name: kDiaryEntries,
        orderByField: 'dateTimeStart',
        builder: (Object? key, Object? dataMap) {
          return DiaryEntry.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
        queryBuilder: (Query query) {
          final dateTimeStart = DateTime(weekStartDateTime.year, weekStartDateTime.month, weekStartDateTime.day).toUtc();
          final dateTimeEnd = dateTimeStart.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));
          return query.startAt(dateTimeStart.millisecondsSinceEpoch).endAt(dateTimeEnd.millisecondsSinceEpoch);
        },
      );

  Stream<List<DiaryEntryAndDrink>> diaryEntryAndDrinkByDateTimeStream(DateTime dateTime) {
    Stream<List<DiaryEntryAndDrink>> combined = Rx.combineLatest2(diaryEntriesByDateTimeStream(dateTime), drinksStream(), (
      List<DiaryEntry> diaryEntries,
      List<Drink> drinks,
    ) {
      List<DiaryEntryAndDrink> diaryEntryAndDrinkList = [];

      for (var diaryEntry in diaryEntries) {
        Drink? drink = drinks.firstWhere((d) => d.id == diaryEntry.drinkId);
        debugPrint('drink: $drink');
        DiaryEntryAndDrink? diaryEntryAndDrink;

        if (drink != null) {
          diaryEntryAndDrink = DiaryEntryAndDrink(diaryEntry: diaryEntry, drink: drink, units: calculateUnits(drink.abv, diaryEntry.volume));

          diaryEntryAndDrinkList.add(diaryEntryAndDrink);
        }
      }

      return diaryEntryAndDrinkList.toList();
    });

    return combined;
  }

  Stream<List<DiaryEntryAndDrink>> diaryEntryAndDrinkByWeekStream(DateTime weekStartDateTime) {
    Stream<List<DiaryEntryAndDrink>> combined = Rx.combineLatest2(diaryEntriesByWeekDateTimeStream(weekStartDateTime), drinksStream(), (
      List<DiaryEntry> diaryEntries,
      List<Drink> drinks,
    ) {
      List<DiaryEntryAndDrink> diaryEntryAndDrinkList = [];

      for (var diaryEntry in diaryEntries) {
        Drink? drink = drinks.firstWhere((d) => d.id == diaryEntry.drinkId);
        //debugPrint('drink: $drink');
        DiaryEntryAndDrink? diaryEntryAndDrink;

        if (drink != null) {
          diaryEntryAndDrink = DiaryEntryAndDrink(diaryEntry: diaryEntry, drink: drink, units: calculateUnits(drink.abv, diaryEntry.volume));

          diaryEntryAndDrinkList.add(diaryEntryAndDrink);
        }
      }

      return diaryEntryAndDrinkList.toList();
    });

    return combined;
  }

  Stream<List<DiaryEntryAndDrink>> diaryEntryAndDrinkByCumulativeWeekStream(DateTime weekStartDateTime, DateTime dateTime) {
    Stream<List<DiaryEntryAndDrink>> combined = Rx.combineLatest2(diaryEntriesByWeekDateTimeStream(weekStartDateTime), drinksStream(), (
      List<DiaryEntry> diaryEntries,
      List<Drink> drinks,
    ) {
      List<DiaryEntryAndDrink> diaryEntryAndDrinkList = [];

      for (var diaryEntry in diaryEntries) {
        Drink? drink = drinks.firstWhere((d) => d.id == diaryEntry.drinkId);
        //debugPrint('drink: $drink');
        DiaryEntryAndDrink? diaryEntryAndDrink;

        if (drink != null) {
          diaryEntryAndDrink = DiaryEntryAndDrink(diaryEntry: diaryEntry, drink: drink, units: calculateUnits(drink.abv, diaryEntry.volume));

          diaryEntryAndDrinkList.add(diaryEntryAndDrink);
        }
      }

      return diaryEntryAndDrinkList.toList();
    });

    return combined;
  }

  Future<void> addDiaryEntry(DiaryEntry diaryEntry) => _service.addData(uid: uid, name: kDiaryEntries, data: diaryEntry.toMap());

  Future<void> updateDiaryEntry(String id, DiaryEntry diaryEntry) => _service.updateData(
        name: kDiaryEntries,
        uid: uid,
        itemId: id,
        data: diaryEntry.toMap(),
      );

  Future<void> deleteDiaryEntry(String id) => _service.deleteData(
        name: kDiaryEntries,
        uid: uid,
        itemId: id,
      );

  Future<void> duplicateDiaryEntry(DiaryEntry diaryEntry) {
    final duplicateDiaryEntry = diaryEntry.copyWith(id: null);
    return _service.addData(uid: uid, name: kDiaryEntries, data: duplicateDiaryEntry.toMap());
  }

  Stream<List<DiaryEntry>> diaryEntriesForDrink(String drinkId) => _service.dataStream(
        name: kDiaryEntries,
        uid: uid,
        orderByField: 'drinkId',
        builder: (Object? key, Object? dataMap) {
          return DiaryEntry.fromMap(key as String, dataMap as Map<String, dynamic>);
        },
        queryBuilder: (Query query) {
          return query.equalTo(drinkId);
        },
      );
}
