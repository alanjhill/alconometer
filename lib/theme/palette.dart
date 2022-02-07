import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Map<int, Color> primaryColorMap = {
  50: const Color.fromRGBO(202, 141, 25, .1),
  100: const Color.fromRGBO(202, 141, 25, .2),
  200: const Color.fromRGBO(202, 141, 25, .3),
  300: const Color.fromRGBO(202, 141, 25, .4),
  400: const Color.fromRGBO(202, 141, 25, .5),
  500: const Color.fromRGBO(202, 141, 25, .6),
  600: const Color.fromRGBO(202, 141, 25, .7),
  700: const Color.fromRGBO(202, 141, 25, .9),
  800: const Color.fromRGBO(202, 141, 25, .9),
  900: const Color.fromRGBO(202, 141, 25, 1),
};

class Palette {
  static MaterialColor primaryMaterialColor = MaterialColor(0xffCA8D19, primaryColorMap);

  static const Color almostBlack = Color(0xFF040B13);
  static const Color lightGrey = Color(0xfffafafa);

  static const Color labelGrey = Color(0xff9a9a9a);

  static const Color primaryColor = Color(0xffCA8D19);

  static const kRowOddColorDarkMode = Colors.black;
  static const kRowEvenColorDarkMode = almostBlack;

  static const kRowOddColorLightMode = Colors.white;
  static const kRowEvenColorLightMode = Palette.lightGrey;
}
