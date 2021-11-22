import 'dart:convert';

import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final drinksProvider = StateNotifierProvider<DrinksProvider, List<Drink>>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.asData?.value != null) {
    final user = auth.asData!.value;
    return DrinksProvider(user);
  }
  //return DrinksProvider('', '');
  throw UnimplementedError();
});

/*final drinksProvider = Provider<DrinksProvider>(
  (ref) {
    final auth = ref.watch(authStateChangesProvider);
    final firebaseAuth = ref.read(firebaseAuthProvider);

    final user = auth.asData!.value;
    if (user?.uid != null) {
      String userId = user!.uid;
      String? idToken;
      firebaseAuth.currentUser!.getIdToken().then((value) {
        idToken = value;
      });
      debugPrint('idToken: $idToken');
      return DrinksProvider(userId, idToken!);
    }
    throw UnimplementedError();
  },
);*/

final getDrinks = FutureProvider.autoDispose<List<Drink>>((ref) async {
  final drinks = ref.watch(drinksProvider.notifier);
  return drinks.fetchDrinks();
});

class DrinksProvider extends StateNotifier<List<Drink>> {
  DrinksProvider(this.user, [state]) : super(state ?? []);

  User? user;

  bool _loaded = false;
  bool _loading = false;

  bool get loaded => _loaded;
  bool get loading => _loading;

  Drink findById(String id) {
    return state.firstWhere((drink) => drink.id == id);
  }

  List<Drink> get items => state;

  Future<List<Drink>> fetchDrinks() async {
    debugPrint('>>> fetchDrinks >>>');
    final userId = user!.uid;
    final authToken = await user!.getIdToken();

    _loaded = false;
    _loading = true;

    var queryParameters = {'auth': authToken};

    queryParameters.addAll({
      'orderBy': '"name"',
    });

    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/drinks/$userId.json', queryParameters);

    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if (extractedData == null) {
        return [];
      }

      final loadedDrinks = <Drink>[];
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
      state = loadedDrinks;
      _loaded = true;
      _loading = false;
      debugPrint('drinks: $state');
      return loadedDrinks;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> addDrink(Drink drink) async {
    final userId = user!.uid;
    final authToken = await user!.getIdToken();
    final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/drinks/$userId.json', {'auth': authToken});

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
      state = [newDrink, ...state];
    } catch (error) {
      debugPrint('$error');
      rethrow;
    }
  }

  Future<void> updateDrink(String drinkId, Drink drink) async {
    final userId = user!.uid;
    final authToken = await user!.getIdToken();
    final drinkIndex = state.indexWhere((drink) => drink.id == drinkId);
    if (drinkIndex >= 0) {
      final url = Uri.https('alconometer-default-rtdb.firebaseio.com', '/drinks/$userId/$drinkId.json', {'auth': authToken});

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

        state[drinkIndex] = drink;
      } catch (error) {
        debugPrint(error.toString());
        rethrow;
      }
    }
  }

  Future<void> deleteDrink(String drinkId) async {
    List<Drink> tempList = [...state];
    int? existingDrinkIndex = tempList.indexWhere((drink) => drink.id == drinkId);
    if (existingDrinkIndex >= 0) {
      tempList.removeAt(existingDrinkIndex);
    }
    state = tempList;
  }
}
