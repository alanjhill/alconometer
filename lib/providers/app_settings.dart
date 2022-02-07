import 'package:alconometer/providers/shared_preferences_service.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class AppSettingsConstants {
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

  static const timeFormats = [
    'hh:mm a',
    'HH:mm',
  ];

  static const firstDayOfWeek = ['Sunday', 'Monday'];
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return AppSettingsNotifier(sharedPreferencesService);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier(this.sharedPreferencesService) : super(AppSettings());
  final SharedPreferencesService sharedPreferencesService;

  void init() {
    final newState = state.copyWith(
      weeklyAllowance: sharedPreferencesService.getWeeklyAllowance(),
      unitsOfMeasure: sharedPreferencesService.getUnitsOfMeasure(),
      dateFormat: sharedPreferencesService.getDateFormat(),
      timeFormat: sharedPreferencesService.getTimeFormat(),
      firstDayOfWeek: sharedPreferencesService.getFirstDayOfWeek(),
      darkMode: sharedPreferencesService.getDarkMode(),
    );
    state = newState;
  }

  Future<void> setWeeklyAllowance(double allowance) async {
    final newState = state.copyWith(weeklyAllowance: allowance);
    state = newState;
    await sharedPreferencesService.setWeeklyAllowance(allowance);
  }

  Future<void> setUnitsOfMeasure(unitsOfMeasure) async {
    final newState = state.copyWith(unitsOfMeasure: unitsOfMeasure);
    state = newState;
    await sharedPreferencesService.setUnitsOfMeasure(unitsOfMeasure);
  }

  Future<void> setDateFormat(dateFormat) async {
    final newState = state.copyWith(dateFormat: dateFormat);
    state = newState;
    await sharedPreferencesService.setDateFormat(dateFormat);
  }

  Future<void> setTimeFormat(timeFormat) async {
    final newState = state.copyWith(timeFormat: timeFormat);
    state = newState;
    await sharedPreferencesService.setTimeFormat(timeFormat);
  }

  Future<void> setFirstDayOfWeek(firstDayOfWeek) async {
    final newState = state.copyWith(firstDayOfWeek: firstDayOfWeek);
    state = newState;
    await sharedPreferencesService.setFirstDayOfWeek(firstDayOfWeek);
  }

  Future<void> setDarkMode(bool darkMode) async {
    final newState = state.copyWith(darkMode: darkMode);
    if (darkMode) {
      await FlutterStatusbarcolor.setStatusBarColor(Palette.almostBlack);
    } else {
      await FlutterStatusbarcolor.setStatusBarColor(Palette.primaryColor);
    }
    state = newState;
    await sharedPreferencesService.setDarkMode(darkMode);
  }

  Future<void> toggleDarkMode() async {
    final newState = state.copyWith(darkMode: !state.darkMode!);
    state = newState;
    if (state.darkMode!) {
      await FlutterStatusbarcolor.setStatusBarColor(Palette.almostBlack);
    } else {
      await FlutterStatusbarcolor.setStatusBarColor(Palette.primaryColor);
    }
    await sharedPreferencesService.setDarkMode(state.darkMode!);
  }
}

class AppSettings {
  double? weeklyAllowance;
  String? unitsOfMeasure;
  String? dateFormat;
  String? timeFormat;
  String? firstDayOfWeek;
  bool? darkMode;

  AppSettings({this.weeklyAllowance, this.unitsOfMeasure, this.dateFormat, this.timeFormat, this.firstDayOfWeek, this.darkMode = false});

  AppSettings copyWith({
    double? weeklyAllowance,
    String? unitsOfMeasure,
    String? dateFormat,
    String? timeFormat,
    String? firstDayOfWeek,
    bool? darkMode,
  }) =>
      AppSettings(
        weeklyAllowance: weeklyAllowance ?? this.weeklyAllowance,
        unitsOfMeasure: unitsOfMeasure ?? this.unitsOfMeasure,
        dateFormat: dateFormat ?? this.dateFormat,
        timeFormat: timeFormat ?? this.timeFormat,
        firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
        darkMode: darkMode ?? this.darkMode,
      );

  bool get time24Hour {
    return timeFormat == AppSettingsConstants.timeFormats[1];
  }
}
