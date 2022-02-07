import 'package:alconometer/providers/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const kWeeklyAllowance = 'weekly-allowance';
  static const kUnitsOfMeasure = 'units-of-measure';
  static const kDateFormat = 'date-format';
  static const kTimeFormat = 'time-format';
  static const kFirstDayOfWeek = 'first-day-of-week';
  static const kDarkMode = 'dark-mode';
  static const kUser = 'user';

  Future<void> invalidate() async {
    await sharedPreferences.setBool(kUser, false);
  }

  Future<void> setWeeklyAllowance(double allowance) async {
    await sharedPreferences.setDouble(kWeeklyAllowance, allowance);
  }

  Future<void> setUnitsOfMeasure(unitsOfMeasure) async {
    await sharedPreferences.setString(kUnitsOfMeasure, unitsOfMeasure);
  }

  Future<void> setDateFormat(dateFormat) async {
    await sharedPreferences.setString(kDateFormat, dateFormat);
  }

  Future<void> setTimeFormat(timeFormat) async {
    await sharedPreferences.setString(kTimeFormat, timeFormat);
  }

  Future<void> setFirstDayOfWeek(firstDayOfWeek) async {
    await sharedPreferences.setString(kFirstDayOfWeek, firstDayOfWeek);
  }

  Future<void> setDarkMode(bool darkMode) async {
    await sharedPreferences.setBool(kDarkMode, darkMode);
  }

  double getWeeklyAllowance() {
    return sharedPreferences.getDouble(kWeeklyAllowance) ?? 0;
  }

  String getUnitsOfMeasure() {
    return sharedPreferences.getString(kUnitsOfMeasure) ?? AppSettingsConstants.unitsOfMeasure[0];
  }

  String getDateFormat() {
    return sharedPreferences.getString(kDateFormat) ?? AppSettingsConstants.dateFormats[0];
  }

  String getTimeFormat() {
    return sharedPreferences.getString(kTimeFormat) ?? AppSettingsConstants.timeFormats[0];
  }

  String getFirstDayOfWeek() {
    return sharedPreferences.getString(kFirstDayOfWeek) ?? AppSettingsConstants.firstDayOfWeek[0];
  }

  bool getDarkMode() {
    return sharedPreferences.getBool(kDarkMode) ?? false;
  }

  Future<void> cacheUser() async {
    await sharedPreferences.setBool(kUser, true);
  }

  bool isUserLoggedIn() {
    return sharedPreferences.getBool(kUser) ?? false;
  }
}
