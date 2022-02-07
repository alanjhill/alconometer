import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends ConsumerWidget {
  static const routeName = '/settings';

  SettingsScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              WeeklyAllowanceSetting(),
              Divider(height: 8.0, thickness: 1.0),
              UnitsOfMeasureSetting(),
              Divider(height: 8.0, thickness: 1.0),
              DateFormatSetting(),
              Divider(height: 8.0, thickness: 1.0),
              TimeFormatSetting(),
              Divider(height: 8.0, thickness: 1.0),
              FirstDayOfWeekSetting(),
              Divider(height: 8.0, thickness: 1.0),
              DarkMode(),
              Divider(height: 8.0, thickness: 1.0),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklyAllowanceSetting extends ConsumerWidget {
  const WeeklyAllowanceSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: Text('Weekly units')),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextFormField(
                  textAlign: TextAlign.end,
                  textAlignVertical: TextAlignVertical.bottom,
                  initialValue: ref.read(appSettingsProvider).weeklyAllowance.toString(),
                  decoration: const InputDecoration(
                    //hintText: 'Weekly units',
                    //labelText: 'Weekly units',
                    //alignLabelWithHint: true,
                    //floatingLabelStyle: TextStyle(color: Colors.black),
                    //labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    debugPrint('allowance: $value');
                    if (value != null && value.isNotEmpty) {
                      ref.read(appSettingsProvider.notifier).setWeeklyAllowance(double.parse(value));
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UnitsOfMeasureSetting extends ConsumerWidget {
  const UnitsOfMeasureSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(child: Text('Units of measure')),
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignedDropdown: true,
            child: DropdownButton<String>(
              alignment: Alignment.centerRight,
              underline: Container(),
              hint: const Text('Units of measure'),
              isExpanded: false,
              value: ref.watch(appSettingsProvider).unitsOfMeasure,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              onChanged: (value) async {
                debugPrint('unitsOfMeasure: $value');
                if (value != null) {
                  await ref.read(appSettingsProvider.notifier).setUnitsOfMeasure(value);
                }
              },
              items: AppSettingsConstants.unitsOfMeasure.map((String unitsOfMeasure) {
                return DropdownMenuItem<String>(
                    value: unitsOfMeasure,
                    alignment: Alignment.center,
                    child: Text(
                      unitsOfMeasure,
                      style: const TextStyle(fontSize: 18.0),
                    ));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class DateFormatSetting extends ConsumerWidget {
  const DateFormatSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: Text('Date Format')),
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignedDropdown: true,
            child: DropdownButton<String>(
              alignment: Alignment.centerRight,
              hint: const Text('Date format'),
              underline: Container(),
              isExpanded: false,
              value: ref.watch(appSettingsProvider).dateFormat,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              onChanged: (value) async {
                debugPrint('allowance: $value');
                if (value != null) {
                  await ref.read(appSettingsProvider.notifier).setDateFormat(value);
                }
              },
              items: AppSettingsConstants.dateFormats.map((String dateFormat) {
                return DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: dateFormat,
                    child: Text(
                      DateFormat(dateFormat).format(DateTime.now()),
                      style: const TextStyle(fontSize: 18.0),
                    ));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class TimeFormatSetting extends ConsumerWidget {
  const TimeFormatSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: Text('Time Format')),
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignedDropdown: true,
            child: DropdownButton<String>(
              alignment: Alignment.centerRight,
              hint: const Text('Time format'),
              underline: Container(),
              isExpanded: false,
              value: ref.watch(appSettingsProvider).timeFormat,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              onChanged: (value) async {
                if (value != null) {
                  await ref.read(appSettingsProvider.notifier).setTimeFormat(value);
                }
              },
              items: AppSettingsConstants.timeFormats.map((String timeFormat) {
                return DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: timeFormat,
                    child: Text(
                      DateFormat(timeFormat).format(DateTime.now()),
                      style: const TextStyle(fontSize: 18.0),
                    ));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class FirstDayOfWeekSetting extends ConsumerWidget {
  const FirstDayOfWeekSetting({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(child: Text('First day of week')),
          ButtonTheme(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignedDropdown: true,
            child: DropdownButton<String>(
              alignment: Alignment.centerRight,
              underline: Container(),
              //hint: const Text('First day of week'),
              isExpanded: false,
              value: ref.watch(appSettingsProvider).firstDayOfWeek,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              onChanged: (value) async {
                debugPrint('firstDayOfWeek: $value');
                if (value != null) {
                  await ref.read(appSettingsProvider.notifier).setFirstDayOfWeek(value);
                  final diaryType = ref.read(appStateProvider).diaryType;
                  ref.read(appStateProvider.notifier).setDiaryType(diaryType!, value);
                }
              },
              items: AppSettingsConstants.firstDayOfWeek.map((String firstDayOfWeek) {
                return DropdownMenuItem<String>(
                    value: firstDayOfWeek,
                    alignment: Alignment.center,
                    child: Text(
                      firstDayOfWeek,
                      style: const TextStyle(fontSize: 18.0),
                    ));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class DarkMode extends ConsumerWidget {
  const DarkMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(appSettingsProvider).darkMode!;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Text('Dark Mode'),
          ),
          //Expanded(child: Icon(Icons.wb_sunny, color: darkMode ? Colors.white : Colors.white)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ButtonTheme(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Switch(
                  value: darkMode,
                  onChanged: (value) async {
                    debugPrint('darkMode: $value');
                    await ref.watch(appSettingsProvider.notifier).setDarkMode(value);
                  },
                )),
          ),
          //Expanded(child: Icon(Icons.mode_night, color: darkMode ? Colors.white : Colors.white)),
        ],
      ),
    );
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: const Text('LOGOUT'),
            onPressed: () async {
              await ref.read(authenticationServiceProvider).signOut();
              await Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
