import 'dart:convert';

import 'package:alconometer/models/http_exception.dart';
import 'package:alconometer/providers/diary_entry.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week_of_year/week_of_year.dart';

class DiaryEntries with ChangeNotifier {
  DiaryEntries(this._authToken, this._userId, this._items);
  final String? _authToken;
  final String? _userId;
  List<DiaryEntry>? _items = [];

  DiaryEntries.emptyValues([this._items = const [], this._authToken, this._userId]);

  List<DiaryEntry> get items {
    return [..._items!];
  }

  DiaryEntry findById(String id) {
    return _items!.firstWhere((diaryEntry) => diaryEntry.id == id);
  }

  List<DiaryEntry> findByDate(DateTime dateTime) {
    final diaryEntries = _items!.where((diaryEntry) => diaryEntry.dateTime!.day == dateTime.day).toList();
    debugPrint('diaryEntries: $diaryEntries');
    return diaryEntries;
  }

  List<DiaryEntry> findByWeek(int weekOfYear) {
    final diaryEntries = _items!.where((diaryEntry) => diaryEntry.dateTime!.weekOfYear == weekOfYear).toList();
    debugPrint('diaryEntries: $diaryEntries');
    return diaryEntries;
  }

  Future<void> fetchDiaryEntries(List<Drink> drinks) async {
    var queryParameters = {'auth': _authToken};
    queryParameters.addAll({
      'orderBy': '"dateTime"',
    });

    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$_userId.json', queryParameters);

    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }

      final List<DiaryEntry> loadedDiaryEntries = [];
      extractedData.forEach((diaryEntryId, diaryEntryData) {
        final drinkId = diaryEntryData['drinkId'];
        final drink = drinks.firstWhere((drink) => drink.id == drinkId);
        final volume = diaryEntryData['volume'];
        final units = calculateUnits(drink.abv!, volume);
        loadedDiaryEntries.add(DiaryEntry(
          id: diaryEntryId,
          drink: drink,
          dateTime: DateTime.parse(diaryEntryData['dateTime']),
          volume: volume,
          units: units,
        ));
      });
      _items = loadedDiaryEntries;
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> addDiaryEntry(DiaryEntry diaryEntry) async {
    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$_userId.json', {'auth': _authToken});

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'dateTime': diaryEntry.dateTime!.toIso8601String(),
            'drinkId': diaryEntry.drink!.id,
            'volume': diaryEntry.volume,
          },
        ),
      );

      final jsonResponse = json.decode(response.body);
      final name = jsonResponse['name'];

      final newDiaryEntry = DiaryEntry(
        id: name,
        dateTime: diaryEntry.dateTime,
        drink: diaryEntry.drink,
        volume: diaryEntry.volume,
        units: calculateUnits(diaryEntry.drink!.abv!, diaryEntry.volume!),
      );

      _items!.insert(0, newDiaryEntry);

      // Now we can notify the listeners
      notifyListeners();
    } catch (error) {
      debugPrint('!!! $error');
      rethrow;
    }
  }

  Future<void> updateDiaryEntry(String diaryEntryId, DiaryEntry diaryEntry) async {
    final existingDiaryEntryIndex = _items!.indexWhere((diaryEntry) => diaryEntry.id == diaryEntryId);
    if (existingDiaryEntryIndex >= 0) {
      final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$_userId/$diaryEntryId.json', {'auth': _authToken});

      try {
        final response = await http.patch(
          url,
          body: json.encode(
            {
              'dateTime': diaryEntry.dateTime!.toIso8601String(),
              'drinkId': diaryEntry.drink!.id,
              'volume': diaryEntry.volume,
            },
          ),
        );

        if (response.statusCode >= 400) {
          debugPrint('!!! Could not update diary entry');
          throw HttpException('Could not update diary entry.');
        }

        _items![existingDiaryEntryIndex] = diaryEntry;
        notifyListeners();
      } catch (error) {
        debugPrint(error.toString());
        rethrow;
      }
    }
  }

  void refreshDiaryEntries(Drink drink) {
    _items!.where((DiaryEntry diaryEntry) => diaryEntry.drink!.id == drink.id).forEach((diaryEntry) {
      final diaryEntryIndex = _items!.indexWhere((item) => item.id == diaryEntry.id);
      _items![diaryEntryIndex] = diaryEntry.copyWith(
        drink: drink,
        units: calculateUnits(drink.abv!, diaryEntry.volume!),
      );
    });
  }

  Future<void> deleteDiaryEntry(String diaryEntryId) async {
    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/diaryEntries/$_userId/$diaryEntryId.json', {'auth': _authToken});
    int? existingDiaryEntryIndex = _items!.indexWhere((diaryEntry) => diaryEntry.id == diaryEntryId);
    var existingDiaryEntry = _items![existingDiaryEntryIndex];
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items!.insert(existingDiaryEntryIndex, existingDiaryEntry);
      notifyListeners();
      throw HttpException('Could not delete diary entry.');
    } else {
      _items!.removeAt(existingDiaryEntryIndex);
      existingDiaryEntryIndex = null;
      notifyListeners();
    }
  }

  Future<void> duplicateDiaryEntry(DiaryEntry diaryEntry) async {
    final duplicatedDiaryEntry = diaryEntry.copyWith(id: null);
    try {
      await addDiaryEntry(duplicatedDiaryEntry);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
