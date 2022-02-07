import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  static const routeName = '/data';

  const DataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Data'),
      ),
      body: Center(
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
