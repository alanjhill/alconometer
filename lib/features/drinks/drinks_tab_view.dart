import 'package:alconometer/features/drinks/drinks_list.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class DrinksTabViewAsync extends StatelessWidget {
  const DrinksTabViewAsync({Key? key, required this.drinkType, required this.drinks}) : super(key: key);
  final DrinkType drinkType;
  final AsyncValue<List<Drink>> drinks;

  @override
  Widget build(BuildContext context) {
    //final filteredDrinks = drinks.where((drink) => drink.type == drinkType).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              DrinksListAsync(drinks: drinks),
            ]),
          ),
        ),
      ],
    );
  }
}
