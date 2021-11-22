import 'package:alconometer/features/data/data_screen.dart';
import 'package:alconometer/features/diary/diary_screen.dart';
import 'package:alconometer/features/drinks/drinks_screen.dart';
import 'package:alconometer/features/home/home_menu.dart';
import 'package:alconometer/features/settings/settings_screen.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/widgets/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum bottomTab { diary, drinks, data, settings }

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController bottomSheetAnimationController;
  final _pages = [
    const DiaryScreen(),
    const DrinksScreen(),
    const DataScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    debugPrint('>>> HomeScreen >>>');
    super.initState();
    _initController();
  }

  void _initController() {
    bottomSheetAnimationController = BottomSheet.createAnimationController(this);
    bottomSheetAnimationController.duration = const Duration(milliseconds: 500);
    bottomSheetAnimationController.reverseDuration = const Duration(milliseconds: 250);
  }

  @override
  void dispose() {
    bottomSheetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, __) {
      final appState = ref.watch(appStateProvider);
      return Scaffold(
        body: SafeArea(
          //bottom: false,
          child: IndexedStack(index: appState.selectedBottomTab, children: _pages),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 0,
          shape: AutomaticNotchedShape(
            const RoundedRectangleBorder(),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(width: 1.0, style: BorderStyle.solid),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'DIARY',
                icon: Icon(Icons.calendar_view_month_outlined),
              ),
              BottomNavigationBarItem(
                label: 'DRINKS',
                icon: Icon(
                  Icons.sports_bar_outlined,
                ),
              ),
              BottomNavigationBarItem(
                label: 'DATA',
                icon: Icon(
                  Icons.bar_chart_outlined,
                ),
              ),
              BottomNavigationBarItem(
                label: 'SETTINGS',
                icon: Icon(
                  Icons.settings,
                ),
              ),
            ],
            currentIndex: appState.selectedBottomTab!,
            onTap: ref.read(appStateProvider.notifier).goToBottomTab,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: const Icon(Icons.add, size: 36.0),
          onPressed: () async {
            _addButtonPressed(index: appState.selectedBottomTab!);
          },
          mini: true,
          isExtended: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(
              width: 3.0,
              color: Colors.transparent,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }

  Widget _getChild({required int index}) {
    return const ModalBottomSheet(child: HomeMenu());
  }

  Future<void> _addButtonPressed({required int index}) {
    return showModalBottomSheet(
      transitionAnimationController: bottomSheetAnimationController,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return _getChild(index: index);
      },
    ).whenComplete(() {
      _initController();
    });
  }
}
