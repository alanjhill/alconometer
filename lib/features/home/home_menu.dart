import 'package:alconometer/features/diary/edit_diary_entry.dart';
import 'package:alconometer/features/drinks/edit_drink.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16.0,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'ADD DRINK TO DIARY',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(FontAwesomeIcons.beer),
                      SizedBox(height: 8.0),
                      Text('Beer'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _createDiaryEntry(context, drinkType: DrinkType.beer);
                  },
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(FontAwesomeIcons.wineGlassAlt),
                      SizedBox(height: 8.0),
                      Text(
                        'Wine',
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _createDiaryEntry(context, drinkType: DrinkType.wine);
                  },
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(FontAwesomeIcons.glassWhiskey),
                      SizedBox(height: 8.0),
                      Text(
                        'Spirit',
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _createDiaryEntry(context, drinkType: DrinkType.spirit);
                  },
                ),
              ]),
              const SizedBox(height: 16.0),
              const Text(
                'CREATE NEW DRINK',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(FontAwesomeIcons.beer),
                      SizedBox(height: 8.0),
                      Text('Beer'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _createDrink(context, drinkType: DrinkType.beer);
                  },
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        FontAwesomeIcons.wineGlassAlt,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Wine',
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _createDrink(context, drinkType: DrinkType.wine);
                  },
                ),
                ElevatedButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(
                        FontAwesomeIcons.glassWhiskey,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Spirit',
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _createDrink(context, drinkType: DrinkType.spirit);
                  },
                ),
              ]),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Icon(Icons.keyboard_arrow_down_outlined),
                style: ElevatedButton.styleFrom(
                  //visualDensity: VisualDensity.compact,
                  //fixedSize: const Size(32, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }

  void _createDrink(BuildContext ctx, {required DrinkType drinkType}) {
    Navigator.of(context).pushNamed(
      EditDrink.routeName,
      arguments: EditDrinkArguments(
        drinkType: drinkType,
      ),
    );
  }

  void _createDiaryEntry(BuildContext ctx, {required DrinkType drinkType}) {
    Navigator.of(context).pushNamed(
      EditDiaryEntry.routeName,
      arguments: EditDiaryEntryArguments(
        drinkType: drinkType,
      ),
    );
  }
}
