import 'package:alconometer/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlconometerTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.varelaRound(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Palette.almostBlack,
    ),
    bodyText2: GoogleFonts.varelaRound(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Palette.almostBlack,
    ),
    headline1: GoogleFonts.varelaRound(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Palette.almostBlack,
    ),
    headline2: GoogleFonts.varelaRound(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Palette.almostBlack,
    ),
    headline3: GoogleFonts.varelaRound(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Palette.almostBlack,
    ),
    headline6: GoogleFonts.varelaRound(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Palette.almostBlack,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.varelaRound(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.varelaRound(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    headline1: GoogleFonts.varelaRound(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.varelaRound(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.varelaRound(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.varelaRound(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      textTheme: lightTextTheme,
      canvasColor: Colors.white,
      backgroundColor: Palette.primaryColor,
      primaryColor: Palette.primaryColor,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Palette.lightGrey,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 2.0,
        foregroundColor: Colors.white,
        backgroundColor: Palette.primaryColor,
        shadowColor: Palette.primaryColor,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Palette.primaryColor,
        unselectedLabelColor: Palette.primaryColor.withAlpha(80),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: Palette.primaryColor, width: 2.0)),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        unselectedItemColor: Palette.primaryColor.withAlpha(80),
        selectedItemColor: Palette.primaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Palette.primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          padding: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          primary: Palette.primaryColor.withOpacity(0.9),
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Palette.primaryColor,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: Brightness.light,
        primary: Palette.primaryColor,
      ),
      timePickerTheme: TimePickerThemeData(
        entryModeIconColor: Palette.primaryColor,
        dialBackgroundColor: Colors.grey.shade200, //Palette.primaryMaterialColor.shade100,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      textTheme: darkTextTheme,
      canvasColor: Colors.black,
      primaryColor: Palette.primaryColor,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Palette.almostBlack,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 2.0,
        foregroundColor: Colors.white,
        backgroundColor: Palette.almostBlack,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Palette.primaryColor,
        unselectedLabelColor: Palette.primaryColor.withAlpha(80),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: Palette.primaryColor, width: 2.0)),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Palette.almostBlack,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Palette.almostBlack,
        selectedItemColor: Palette.primaryColor,
        unselectedItemColor: Palette.primaryColor.withAlpha(80),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Palette.primaryColor,
        foregroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          padding: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          primary: Palette.primaryColor.withAlpha(400),
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Palette.primaryColor,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Palette.primaryColor),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Palette.almostBlack,
        entryModeIconColor: Palette.primaryColor,
        dialBackgroundColor: Palette.primaryMaterialColor.shade500,
      ),
      //colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueGrey.shade600, brightness: Brightness.dark),
    );
  }
}
