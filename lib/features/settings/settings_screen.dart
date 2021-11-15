import 'package:alconometer/constants.dart';
import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  SettingsScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              WeeklyAllowanceSetting(),
              SizedBox(height: 16.0),
              UnitsOfMeasureSetting(),
              SizedBox(height: 16.0),
              DateFormatSetting(),
              SizedBox(),
              DarkMode(),
            ]),
          ),
        ),
      ),
    );
  }
}

class WeeklyAllowanceSetting extends StatefulWidget {
  const WeeklyAllowanceSetting({Key? key}) : super(key: key);

  @override
  _WeeklyAllowanceSettingState createState() => _WeeklyAllowanceSettingState();
}

class _WeeklyAllowanceSettingState extends State<WeeklyAllowanceSetting> {
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
              initialValue: Provider.of<AppSettingsManager>(context, listen: false).weeklyAllowance.toString(),
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
                  Provider.of<AppSettingsManager>(context, listen: false).setWeeklyAllowance(int.parse(value));
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class UnitsOfMeasureSetting extends StatefulWidget {
  const UnitsOfMeasureSetting({Key? key}) : super(key: key);

  @override
  _UnitsOfMeasureSettingState createState() => _UnitsOfMeasureSettingState();
}

class _UnitsOfMeasureSettingState extends State<UnitsOfMeasureSetting> {
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
                value: Provider.of<AppSettingsManager>(context, listen: false).unitsOfMeasure,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (value) async {
                  debugPrint('unitsOfMeasure: $value');
                  if (value != null) {
                    await Provider.of<AppSettingsManager>(context, listen: false).setUnitsOfMeasure(value);
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

class DateFormatSetting extends StatefulWidget {
  const DateFormatSetting({Key? key}) : super(key: key);

  @override
  _DateFormatSettingState createState() => _DateFormatSettingState();
}

class _DateFormatSettingState extends State<DateFormatSetting> {
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
                hint: Text('Date format'),
                isExpanded: false,
                value: Provider.of<AppSettingsManager>(context, listen: false).dateFormat,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (value) async {
                  debugPrint('allowance: $value');
                  if (value != null) {
                    await Provider.of<AppSettingsManager>(context, listen: false).setDateFormat(value);
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

class DarkMode extends StatelessWidget {
  const DarkMode({Key? key}) : super(key: key);

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
              child: Consumer<AppSettingsManager>(builder: (context, appSettingsManager, child) {
                return Switch(
                  value: appSettingsManager.darkMode,
                  onChanged: (value) async {
                    debugPrint('allowance: $value');
                    if (value != null) {
                      await appSettingsManager.setDarkMode(value);
                    }
                  },
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}
