import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const kWeeklyAllowance = 'weekly-allowance';
  static const kUnitsOfMeasure = 'units-of-measure';
  static const kDateFormat = 'date-format';
  static const kDarkMode = 'dark-mode';
  static const kUser = 'user';

  Future<void> invalidate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kUser, false);
  }

  Future<void> setWeeklyAllowance(int allowance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kWeeklyAllowance, allowance);
  }

  Future<void> setUnitsOfMeasure(unitsOfMeasure) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kUnitsOfMeasure, unitsOfMeasure);
  }

  Future<void> setDateFormat(dateFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kDateFormat, dateFormat);
  }

  Future<void> setDarkMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kDarkMode, darkMode);
  }

  Future<int> getWeeklyAllowance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(kWeeklyAllowance) ?? 0;
  }

  Future<String> getUnitsOfMeasure() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kUnitsOfMeasure) ?? AppSettings.unitsOfMeasure[0];
  }

  Future<String> getDateFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kDateFormat) ?? AppSettings.dateFormats[0];
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kDarkMode) ?? false;
  }

  Future<void> cacheUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kUser, true);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kUser) ?? false;
  }

/*  Future<void> toggleDarkMode() async {
    _darkMode = !darkMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', darkMode);
    notifyListeners();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    Future.wait<void>([
      (() async => _weeklyAllowance = prefs.getInt('weekly-allowance')!)(),
      (() async => _dateFormat = prefs.getString('date-format')!)(),
      (() async => _unitsOfMeasure = prefs.getString('units-of-measure')!)(),
      (() async => _darkMode = prefs.getBool('dark-mode')!)(),
    ]);
  }*/
}
