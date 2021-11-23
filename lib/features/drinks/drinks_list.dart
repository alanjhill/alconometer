import 'package:alconometer/features/drinks/drink_item.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/widgets/empty_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class DrinksListAsync extends StatelessWidget {
  final AsyncValue<List<Drink>> drinks;

  const DrinksListAsync({Key? key, required this.drinks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return drinks.when(
      data: (items) => items.isNotEmpty ? _buildList(items) : const EmptyContent(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now: $error, $stackTrace',
      ),
    );
  }
}

Widget _buildList(List<Drink> drinks) {
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
