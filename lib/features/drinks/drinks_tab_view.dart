import 'package:alconometer/features/drinks/drinks_list.dart';
import 'package:alconometer/models/drink.dart';
import 'package:alconometer/models/drink_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrinksTabView extends StatelessWidget {
  const DrinksTabView({Key? key, required this.drinkType, required this.drinks}) : super(key: key);
  final DrinkType drinkType;
  final AsyncValue<List<Drink>> drinks;

  @override
  Widget build(BuildContext context) {
    //final filteredDrinks = drinks.where((drink) => drink.type == drinkType).toList();
    return DrinksList(drinkType: drinkType, drinks: drinks);
  }
}
