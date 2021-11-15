import 'package:alconometer/constants.dart';
import 'package:alconometer/features/drinks/drink_item.dart';
import 'package:alconometer/features/drinks/drinks_list.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrinksTabView extends StatelessWidget {
  const DrinksTabView({Key? key, required this.drinkType, required this.drinks}) : super(key: key);
  final DrinkType drinkType;
  final List<Drink> drinks;

  @override
  Widget build(BuildContext context) {
    final filteredDrinks = drinks.where((drink) => drink.type == drinkType).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              DrinksList(drinks: filteredDrinks),
            ]),
          ),
        ),
      ],
    );
  }
}
