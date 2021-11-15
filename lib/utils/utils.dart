import 'package:alconometer/constants.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String getDrinkTypeText(DrinkType type) {
  switch (type) {
    case DrinkType.beer:
      return 'Beer';
    case DrinkType.wine:
      return 'Wine';
    case DrinkType.spirit:
    default:
      return 'Spirit';
  }
}

Icon getDrinkTypeIcon(DrinkType drinkType, {double size = 24.0}) {
  switch (drinkType) {
    case DrinkType.beer:
      return Icon(FontAwesomeIcons.beer, size: size);
    case DrinkType.wine:
      return Icon(FontAwesomeIcons.wineGlassAlt, size: size);
    case DrinkType.spirit:
    default:
      return Icon(FontAwesomeIcons.glassWhiskey, size: size);
  }
}

///
/// abv = %age
/// volume = ml
///
/// Approximate units = abv * volume (ml) / 1000
double calculateUnits(double abv, double volume) {
  return double.parse((abv * volume / 1000.0).toStringAsFixed(2));
}

Color getRowColor(int index, bool darkMode) {
  if (darkMode) {
    return (index % 2 == 0) ? Palette.kRowEvenColorDarkMode : Palette.kRowOddColorDarkMode;
  } else {
    return (index % 2 == 0) ? Palette.kRowEvenColorLightMode : Palette.kRowOddColorLightMode;
  }
}
