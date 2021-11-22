import 'package:alconometer/constants.dart';
import 'package:alconometer/features/drinks/edit_drink.dart';
import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrinkItem extends ConsumerWidget {
  const DrinkItem({Key? key, required this.drink, required this.index}) : super(key: key);
  final Drink drink;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(appSettingsManagerProvider).darkMode;
    return Container(
      padding: const EdgeInsets.all(0),
      child: ListTile(
          dense: true,
          tileColor: getRowColor(index, darkMode),
          visualDensity: VisualDensity.compact,
          //leading: getDrinkTypeIcon(drink.type),
          title: Text(
            drink.name,
          ),
          //subtitle: Text('${getDrinkTypeText(drink.type)} - ${drink.abv}%'),
          subtitle: Text('${drink.abv}%'),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add drink',
            onPressed: () {
              debugPrint('>>> onPressed');
            },
            splashRadius: 28.0,
          ),
          onTap: () async {
            _editDrink(context, id: drink.id!);
          }),
    );
  }

  void _editDrink(BuildContext context, {required String id}) {
    Navigator.of(context).pushNamed(
      EditDrink.routeName,
      arguments: EditDrinkArguments(
        drinkType: drink.type,
        id: id,
      ),
    );
  }
}
