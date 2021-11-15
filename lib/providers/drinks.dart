import 'dart:convert';

import 'package:alconometer/providers/drink.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Drinks with ChangeNotifier {
  Drinks(this._authToken, this._userId, this._items);
  final String? _authToken;
  final String? _userId;

  List<Drink>? _items = [];

  Drinks.emptyValues([this._items = const [], this._authToken, this._userId]);

  List<Drink> get items {
    return [..._items!];
  }

  Drink findById(String id) {
    return _items!.firstWhere((drink) => drink.id == id);
  }

  Future<void> fetchDrinks() async {
    var queryParameters = {'auth': _authToken};
    queryParameters.addAll({
      'orderBy': '"name"',
    });

    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/drinks/$_userId.json', queryParameters);

    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }

      final List<Drink> loadedDrinks = [];
      extractedData.forEach((drinkId, drinkData) {
        loadedDrinks.add(
          Drink(
            id: drinkId,
            name: drinkData['name'],
            type: DrinkType.values.firstWhere((type) => type.toString() == drinkData['type']),
            abv: drinkData['abv'],
          ),
        );
      });

      // Sort the drinks
      loadedDrinks.sort((Drink a, Drink b) => a.name.compareTo(b.name));

      _items = loadedDrinks;
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> addDrink(Drink drink) async {
    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/drinks/$_userId.json', {'auth': _authToken});

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': drink.name,
            'type': drink.type.toString(),
            'abv': drink.abv,
          },
        ),
      );

      final jsonResponse = json.decode(response.body);
      final name = jsonResponse['name'];

      final newDrink = Drink(
        id: name,
        name: drink.name,
        type: drink.type,
        abv: drink.abv,
      );
      _items!.insert(0, newDrink);

      // Now we can notify the listeners
      notifyListeners();
    } catch (error) {
      debugPrint('$error');
      rethrow;
    }
  }

  Future<void> updateDrink(String drinkId, Drink drink) async {
    final drinkIndex = _items!.indexWhere((drink) => drink.id == drinkId);
    if (drinkIndex >= 0) {
      final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/drinks/$_userId/$drinkId.json', {'auth': _authToken});

      try {
        final response = await http.patch(
          url,
          body: json.encode(
            {
              'name': drink.name,
              'type': drink.type.toString(),
              'abv': drink.abv,
            },
          ),
        );

        _items![drinkIndex] = drink;
        notifyListeners();
      } catch (error) {
        debugPrint(error.toString());
        rethrow;
      }
    }
  }

  Future<void> deleteDrink(String drinkId) async {
    int? existingDrinkIndex = _items!.indexWhere((drink) => drink.id == drinkId);
    //var existingDrink = _items[existingDrinkIndex];

    if (existingDrinkIndex >= 0) {
      _items!.removeAt(existingDrinkIndex);
      notifyListeners();
    }
  }
}
