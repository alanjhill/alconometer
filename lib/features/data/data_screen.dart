import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataScreen extends StatelessWidget {
  static const routeName = '/data';

  const DataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Drinks'),
      ),
      body: const Text('DATA'),
    );
  }
}
