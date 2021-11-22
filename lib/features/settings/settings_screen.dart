import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/services/authentication_service.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              SizedBox(height: 16.0),
              UnitsOfMeasureSetting(),
              SizedBox(height: 16.0),
              DateFormatSetting(),
              SizedBox(),
              DarkMode(),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklyAllowanceSetting extends ConsumerStatefulWidget {
  const WeeklyAllowanceSetting({Key? key}) : super(key: key);

  @override
  _WeeklyAllowanceSettingState createState() => _WeeklyAllowanceSettingState();
}

class _WeeklyAllowanceSettingState extends ConsumerState<WeeklyAllowanceSetting> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: TextFormField(
              initialValue: ref.read(appSettingsManagerProvider).weeklyAllowance.toString(),
              decoration: const InputDecoration(labelText: 'Weekly units', labelStyle: TextStyle(color: Colors.grey)),
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
                  ref.read(appSettingsManagerProvider).setWeeklyAllowance(int.parse(value));
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class UnitsOfMeasureSetting extends ConsumerStatefulWidget {
  const UnitsOfMeasureSetting({Key? key}) : super(key: key);

  @override
  _UnitsOfMeasureSettingState createState() => _UnitsOfMeasureSettingState();
}

class _UnitsOfMeasureSettingState extends ConsumerState<UnitsOfMeasureSetting> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: ButtonTheme(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              //alignedDropdown: true,
              child: DropdownButton<String>(
                hint: Text('Units of measure'),
                isExpanded: false,
                value: ref.read(appSettingsManagerProvider).unitsOfMeasure,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (value) async {
                  debugPrint('unitsOfMeasure: $value');
                  if (value != null) {
                    await ref.read(appSettingsManagerProvider).setUnitsOfMeasure(value);
                  }
                },
                items: AppSettings.unitsOfMeasure.map((String dateFormat) {
                  return DropdownMenuItem<String>(
                      value: dateFormat,
                      child: Text(
                        dateFormat,
                        style: const TextStyle(fontSize: 24.0),
                      ));
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DateFormatSetting extends ConsumerStatefulWidget {
  const DateFormatSetting({Key? key}) : super(key: key);

  @override
  _DateFormatSettingState createState() => _DateFormatSettingState();
}

class _DateFormatSettingState extends ConsumerState<DateFormatSetting> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: ButtonTheme(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              //alignedDropdown: true,
              child: DropdownButton<String>(
                hint: Text('Date format'),
                isExpanded: false,
                value: ref.read(appSettingsManagerProvider).dateFormat,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (value) async {
                  debugPrint('allowance: $value');
                  if (value != null) {
                    await ref.read(appSettingsManagerProvider).setDateFormat(value);
                  }
                },
                items: AppSettings.dateFormats.map((String dateFormat) {
                  return DropdownMenuItem<String>(
                      value: dateFormat,
                      child: Text(
                        dateFormat,
                        style: const TextStyle(fontSize: 24.0),
                      ));
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DarkMode extends ConsumerWidget {
  const DarkMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: ButtonTheme(
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Switch(
                  value: ref.watch(appSettingsManagerProvider).darkMode,
                  onChanged: (value) async {
                    debugPrint('allowance: $value');
                    if (value != null) {
                      await ref.watch(appSettingsManagerProvider).setDarkMode(value);
                    }
                  },
                )),
          ),
        )
      ],
    );
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(ref.read(authenticationServiceProvider).isLoggedIn() ? 'Logged In' : 'Not Logged In'),
        ElevatedButton(
          child: const Text('LOGOUT'),
          onPressed: () async {
            await ref.read(authenticationServiceProvider).signOut();
            await Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ],
    );
  }
}
