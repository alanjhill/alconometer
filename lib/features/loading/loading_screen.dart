import 'package:alconometer/features/home/home_screen.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/services/api_service.dart';
import 'package:alconometer/widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      super.didChangeDependencies();
      final drinksNotifier = ref.watch(drinksProvider.notifier);
      drinksNotifier.fetchDrinks().then(
        (drinks) {
          final diaryEntries = ref.watch(diaryEntriesProvider.notifier);
          diaryEntries.fetchDiaryEntries(drinks).then(
            (_) {
              setState(() {
                _isLoading = false;
                _isInit = false;
              });

/*              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );*/
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded(),
    );
  }

  Widget loaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Just here for dev/testing...will just display a loading spinner when loading initial data
          Text(
            'ALCONOMETER',
            style: TextStyle(fontSize: 36.0),
          ),
          SizedBox(height: 36.0),
          Text('LOADING...'),
          SizedBox(height: 36.0),
          _isLoading ? CircularProgressIndicator() : Container(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: Text('GO'),
          ),
        ],
      ),
    );
  }
}

class LoadingWrapper extends ConsumerWidget {
  const LoadingWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinksNotifier = ref.watch(drinksProvider.notifier);
    drinksNotifier.fetchDrinks().then((drinks) {
      final diaryEntries = ref.watch(diaryEntriesProvider.notifier);
      return diaryEntries.fetchDiaryEntries(drinks).then((_) {
        return HomeScreen();
      });
    });
    return CircularProgressIndicator();
  }
}
