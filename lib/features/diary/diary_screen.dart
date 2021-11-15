import 'package:alconometer/features/diary/day_view.dart';
import 'package:alconometer/features/diary/diary_tab_manager.dart';
import 'package:alconometer/features/diary/week_view.dart';
import 'package:alconometer/features/home/home_screen.dart';
import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/routing/app_router.dart';
import 'package:alconometer/widgets/app_drawer.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:alconometer/widgets/custom_tab_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiaryScreen extends StatefulWidget {
  static const routeName = '/diary';

  const DiaryScreen({Key? key}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> with SingleTickerProviderStateMixin {
  static final _diaryScreenKey = GlobalKey<_DiaryScreenState>();
  late TabController _tabController;
  final List<Tab> _tabs = <Tab>[
    const Tab(
      icon: Icon(Icons.calendar_view_day_outlined),
      text: 'DAY',
    ),
    const Tab(
      icon: Icon(Icons.calendar_view_week_outlined),
      text: 'WEEK',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController.addListener(_setTab);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = Provider.of<AppStateManager>(context, listen: false).selectedDiaryTab;
    return DefaultTabController(
      key: const Key('diaryDefaultTabKey'),
      initialIndex: selectedTab,
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: _getDateSelector(),
          actions: <Widget>[
            // TODO: Remove when no longer needed
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () async {
                Navigator.of(context).pushNamed(HomeScreen.routeName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await Provider.of<AppSettingsManager>(context, listen: false).toggleDarkMode();
              },
            ),
          ],
          bottom: CustomTabBar(
              color: Theme.of(context).canvasColor,
              tabBar: TabBar(
                controller: _tabController,
                padding: const EdgeInsets.all(0.0),
                onTap: _diaryViewTypeHandler,
                tabs: _tabs,
              )),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            DayView(),
            WeekView(),
          ],
        ),
      ),
    );
  }

  void _setTab() {
    Future.delayed(Duration.zero, () {
      final index = _tabController.index;
      Provider.of<AppStateManager>(context, listen: false).setDiaryType(DiaryType.values[index]);
      _diaryViewTypeHandler(index);
      //_tabController.animateTo(index);
    });
  }

  void _diaryViewTypeHandler(int index) {
    if (index == 0) {
      Provider.of<AppStateManager>(context, listen: false).setDiaryType(DiaryType.day);
    } else {
      Provider.of<AppStateManager>(context, listen: false).setDiaryType(DiaryType.week);
    }
  }

  Widget _getDateSelector() {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_left),
            iconSize: 36.0,
            onPressed: _arrowLeft,
          ),
          Consumer<AppStateManager>(builder: (ctx, dateSelectorProvider, child) {
            return InkWell(
              child: buildDatePicker(context),
              //DateFormat.yMd().format(dateSelectorProvider.selectedDate).toString(),
            );
          }),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            iconSize: 36.0,
            onPressed: _arrowRight,
          ),
        ],
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    final appStateManager = Provider.of<AppStateManager>(context, listen: false);
    // 1
    return InkWell(
      child: Consumer<AppSettingsManager>(
        builder: (context, appSettingsManager, child) {
          if (appStateManager.diaryType == DiaryType.day) {
            return Text(DateFormat(appSettingsManager.dateFormat).format(appStateManager.selectedDate));
          } else {
            // TODO: Relocate to provider
            final weekStartDate = appStateManager.selectedDate;
            final weekEndDate = weekStartDate.add(const Duration(days: 6));
            final weekStartDateFormatted = DateFormat(appSettingsManager.dateFormat).format(weekStartDate);
            final weekEndDateFormatted = DateFormat(appSettingsManager.dateFormat).format(weekEndDate);
            return Row(children: <Widget>[AutoSizeText('$weekStartDateFormatted - $weekEndDateFormatted', maxLines: 1)]);
          }
        },
      ),
      onTap: () async {
        final currentDate = DateTime.now();
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: appStateManager.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(currentDate.year + 5),
          selectableDayPredicate: (appStateManager.diaryType == DiaryType.week) ? _selectableDays : null,
          locale: const Locale('en', 'GB'),
        );
        if (selectedDate != null) {
          appStateManager.setSelectedDate(selectedDate);
        }
      },
    );
  }

  bool _selectableDays(DateTime dateTime) {
    if (dateTime.weekday == 1) {
      return true;
    }
    return false;
  }

  // TODO: Relocate to provider
  void _arrowLeft() {
    final appState = Provider.of<AppStateManager>(context, listen: false);
    final dateTime = appState.selectedDate;
    final diaryViewType = appState.diaryType;
    if (diaryViewType == DiaryType.day) {
      appState.setSelectedDate(dateTime.subtract(const Duration(days: 1)));
    } else {
      appState.setSelectedDate(dateTime.subtract(const Duration(days: 7)));
    }
  }

  // TODO: Relocate to provider
  void _arrowRight() {
    final appState = Provider.of<AppStateManager>(context, listen: false);
    final dateTime = appState.selectedDate;
    final diaryViewType = appState.diaryType;
    if (diaryViewType == DiaryType.day) {
      appState.setSelectedDate(dateTime.add(const Duration(days: 1)));
    } else {
      appState.setSelectedDate(dateTime.add(const Duration(days: 6)));
    }
  }
}
