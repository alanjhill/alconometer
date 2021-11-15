import 'package:alconometer/providers/app_cache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const unitsOfMeasure = [
    'ML',
    'FL-OZ-US',
    'FL-OZ-UK',
  ];

  static const dateFormats = [
    'yyyy-MM-dd',
    'dd/MM/yyyy',
    'dd/MMM/yyyy',
    'MM/dd/yyyy',
  ];
}

class AppSettingsManager extends ChangeNotifier {
  var _weeklyAllowance = 0;
  var _unitsOfMeasure = AppSettings.unitsOfMeasure[0];
  var _dateFormat = AppSettings.dateFormats[0];
  var _darkMode = false;
  final _appCache = AppCache();

  init() async {
    _weeklyAllowance = await _appCache.getWeeklyAllowance();
    _dateFormat = await _appCache.getDateFormat();
    _unitsOfMeasure = await _appCache.getUnitsOfMeasure();
    _darkMode = await _appCache.getDarkMode();
  }

  int get weeklyAllowance => _weeklyAllowance;
  String get unitsOfMeasure => _unitsOfMeasure;
  String get dateFormat => _dateFormat;
  bool get darkMode => _darkMode;

  Future<void> setWeeklyAllowance(int allowance) async {
    _weeklyAllowance = allowance;
    await _appCache.setWeeklyAllowance(allowance);
    notifyListeners();
  }

  Future<void> setUnitsOfMeasure(unitsOfMeasure) async {
    _unitsOfMeasure = unitsOfMeasure;
    await _appCache.setUnitsOfMeasure(unitsOfMeasure);
    notifyListeners();
  }

  Future<void> setDateFormat(dateFormat) async {
    _dateFormat = dateFormat;
    _appCache.setDateFormat(dateFormat);
    notifyListeners();
  }

  Future<void> setDarkMode(bool darkMode) async {
    _darkMode = darkMode;
    await _appCache.setDarkMode(darkMode);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _darkMode = !darkMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', darkMode);
    notifyListeners();
  }
}
