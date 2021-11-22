import 'package:alconometer/features/diary/day_view.dart';
import 'package:alconometer/features/diary/diary_state.dart';
import 'package:alconometer/features/diary/week_view.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/widgets/app_drawer.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:alconometer/widgets/custom_tab_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  static const routeName = '/diary';

  const DiaryScreen({Key? key}) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> with SingleTickerProviderStateMixin {
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
    return Consumer(builder: (context, WidgetRef ref, __) {
      final darkMode = ref.watch(appSettingsManagerProvider).darkMode;
      final appState = ref.watch(appStateProvider);
      final diaryState = ref.watch(diaryStateProvider);

      final selectedTab = diaryState.selectedTab;
      return DefaultTabController(
        key: const Key('diaryDefaultTabKey'),
        initialIndex: selectedTab!,
        length: 2,
        child: Scaffold(
          appBar: CustomAppBar(
            title: _getDateSelector(),
            actions: <Widget>[
              IconButton(
                icon: Icon(darkMode ? Icons.wb_sunny : Icons.mode_night, color: darkMode ? Colors.white : Colors.white),
                onPressed: () async {
                  await ref.read(appSettingsManagerProvider).toggleDarkMode();
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
    });
  }

  void _setTab() {
    Future.delayed(Duration.zero, () {
      final index = _tabController.index;
      ref.read(appStateProvider.notifier).setDiaryType(DiaryType.values[index]);
      _diaryViewTypeHandler(index);
      //_tabController.animateTo(index);
    });
  }

  void _diaryViewTypeHandler(int index) {
    if (index == 0) {
      ref.read(appStateProvider.notifier).setDiaryType(DiaryType.day);
    } else {
      ref.read(appStateProvider.notifier).setDiaryType(DiaryType.week);
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
            onPressed: () => _arrowLeft(ref),
          ),
          InkWell(
            child: buildDatePicker(ref),
            //DateFormat.yMd().format(dateSelectorProvider.selectedDate).toString(),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            iconSize: 36.0,
            onPressed: () => _arrowRight(ref),
          ),
        ],
      ),
    );
  }

  bool _selectableDays(DateTime dateTime) {
    if (dateTime.weekday == 1) {
      return true;
    }
    return false;
  }

  Widget buildDatePicker(WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final appSettingsManager = ref.read(appSettingsManagerProvider);
    return InkWell(
      child: Builder(
        builder: (context) {
          if (appState.diaryType == DiaryType.day) {
            return Text(
              DateFormat(appSettingsManager.dateFormat).format(appState.displayedDate!),
            );
          } else {
            // TODO: Relocate to provider
            final weekStartDate = appState.displayedDate;
            final weekEndDate = weekStartDate!.add(const Duration(days: 6));
            final weekStartDateFormatted = DateFormat(appSettingsManager.dateFormat).format(weekStartDate);
            final weekEndDateFormatted = DateFormat(appSettingsManager.dateFormat).format(weekEndDate);
            return Row(children: <Widget>[AutoSizeText('$weekStartDateFormatted - $weekEndDateFormatted', maxLines: 1)]);
          }
        },
      ),
      onTap: () async {
        final currentDate = DateTime.now();
        final displayedDate = await showDatePicker(
          context: context,
          initialDate: appState.displayedDate!,
          firstDate: DateTime(2020),
          lastDate: DateTime(currentDate.year + 5),
          selectableDayPredicate: (appState.diaryType == DiaryType.week) ? _selectableDays : null,
          locale: const Locale('en', 'GB'),
        );
        if (displayedDate != null) {
          ref.read(appStateProvider.notifier).setDisplayedDate(displayedDate);
        }
      },
    );
  }

  // TODO: Relocate to provider
  void _arrowLeft(WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final dateTime = appState.displayedDate;
    final diaryViewType = appState.diaryType;
    if (diaryViewType == DiaryType.day) {
      ref.read(appStateProvider.notifier).setDisplayedDate(dateTime!.subtract(const Duration(days: 1)));
    } else {
      ref.read(appStateProvider.notifier).setDisplayedDate(dateTime!.subtract(const Duration(days: 7)));
    }
  }

  // TODO: Relocate to provider
  void _arrowRight(WidgetRef ref) {
    final appState = ref.read(appStateProvider);
    final dateTime = appState.displayedDate;
    final diaryViewType = appState.diaryType;
    if (diaryViewType == DiaryType.day) {
      ref.read(appStateProvider.notifier).setDisplayedDate(dateTime!.add(const Duration(days: 1)));
    } else {
      ref.read(appStateProvider.notifier).setDisplayedDate(dateTime!.add(const Duration(days: 7)));
    }
  }
}
