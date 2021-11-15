import 'package:alconometer/features/home/home_screen.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AppStateManager>(context, listen: false).initializeApp(context);
      Provider.of<Drinks>(context, listen: false).fetchDrinks().then(
        (value) {
          final drinks = Provider.of<Drinks>(context, listen: false).items;
          Provider.of<DiaryEntries>(context, listen: false).fetchDiaryEntries(drinks).then(
            (_) {
              setState(() {
                _isLoading = false;
                _isInit = false;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Just here for dev/testing...will just display a loading spinner when loading initial data
            Text(
              'ALCONOMETER',
              style: TextStyle(fontSize: 36.0),
            ),
            SizedBox(height: 36.0),
            Text('LOADING...'),
            SizedBox(height: 36.0),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
