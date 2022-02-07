import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

Color getTextColor(DiaryType diaryType, double weeklyAllowance, double units) {
  final allowance = diaryType == DiaryType.week ? weeklyAllowance : (weeklyAllowance / 1);
  if (units <= allowance * 0.9) {
    return Colors.green;
  } else if (units >= allowance && units <= allowance * 1.1) {
    return Colors.amber;
  } else {
    return Colors.red;
  }
}

DateTime getDateTimeNow() {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day);
  return dateTime;
}
