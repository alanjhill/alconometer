import 'package:alconometer/features/drinks/drink_item.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:flutter/cupertino.dart';

class DrinksList extends StatelessWidget {
  final List<Drink> drinks;

  const DrinksList({Key? key, required this.drinks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: drinks.length,
        itemBuilder: (content, index) => DrinkItem(drink: drinks[index], index: index),
      )
    ]);
  }
}
