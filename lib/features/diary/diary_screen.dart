import 'package:alconometer/features/diary/day_view.dart';
import 'package:alconometer/features/diary/diary_state.dart';
import 'package:alconometer/features/diary/week_view.dart';
import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/theme/alconometer_theme.dart';
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
    //_tabController.addListener(_setTab);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, __) {
      final darkMode = ref.watch(appSettingsProvider).darkMode;
      final appState = ref.watch(appStateProvider);
      final appSettings = ref.watch(appSettingsProvider);
      final diaryState = ref.watch(diaryStateProvider);
      final selectedTab = diaryState.selectedTab;
      return DefaultTabController(
        key: const Key('diaryDefaultTabKey'),
        initialIndex: selectedTab!,
        length: 2,
        child: Scaffold(
          appBar: CustomAppBar(
            title: _getDateSelector(),
            bottom: CustomTabBar(
              color: Theme.of(context).canvasColor,
              tabBar: TabBar(
                controller: _tabController,
                padding: const EdgeInsets.all(0.0),
                onTap: (index) {
                  _diaryViewTypeHandler(index);
                },
                tabs: _tabs,
              ),
            ),
          ),
          drawer: const AppDrawer(),
          body: _DiaryTabs(_tabController),
        ),
      );
    });
  }

  void _setTab() {
    Future.delayed(Duration.zero, () {
      debugPrint('>>> _setTab');
      final index = _tabController.index;
      _diaryViewTypeHandler(index);
    });
  }

  void _diaryViewTypeHandler(int index) {
    debugPrint('>>> _diaryViewTypeHandler');
    final firstDayOfWeek = ref.read(appSettingsProvider).firstDayOfWeek;
    if (index == 0) {
      ref.read(appStateProvider.notifier).setDiaryType(DiaryType.day, firstDayOfWeek!);
    } else {
      ref.read(appStateProvider.notifier).setDiaryType(DiaryType.week, firstDayOfWeek!);
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

  bool _selectableDays(DateTime dateTime, String firstDayOfWeek) {
    final day = firstDayOfWeek == AppSettingsConstants.firstDayOfWeek[0] ? 7 : 1;
    if (dateTime.weekday == day) {
      return true;
    }
    return false;
  }

  Widget buildDatePicker(WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final appSettings = ref.watch(appSettingsProvider);
    return InkWell(
      child: Builder(
        builder: (context) {
          if (appState.diaryType == DiaryType.day) {
            return Text(
              DateFormat(appSettings.dateFormat).format(appState.displayedDate!.toLocal()),
            );
          } else {
            // TODO: Relocate to provider
            final weekStartDate = appState.displayedDate;
            final weekEndDate = weekStartDate!.add(const Duration(days: 6));
            final weekStartDateFormatted = DateFormat(appSettings.dateFormat).format(weekStartDate.toLocal());
            final weekEndDateFormatted = DateFormat(appSettings.dateFormat).format(weekEndDate.toLocal());
            return Row(children: <Widget>[AutoSizeText('$weekStartDateFormatted - $weekEndDateFormatted', maxLines: 1)]);
          }
        },
      ),
      onTap: () async {
        final currentDate = DateTime.now().toUtc();
        final displayedDate = await showDatePicker(
          context: context,
          initialDate: appState.displayedDate!,
          firstDate: DateTime.utc(2020),
          lastDate: DateTime.utc(currentDate.year + 5),
          selectableDayPredicate: (dateTime) => (appState.diaryType == DiaryType.week) ? _selectableDays(dateTime, appSettings.firstDayOfWeek!) : true,
          locale: ref.read(appSettingsProvider).firstDayOfWeek == AppSettingsConstants.firstDayOfWeek[1] ? const Locale('en', 'GB') : null,
          builder: (context, child) => Theme(
            data: appSettings.darkMode! ? AlconometerTheme.datePickerDark() : AlconometerTheme.datePickerLight(),
            child: child!,
          ),
        );
        if (displayedDate != null) {
          var date = DateTime(displayedDate.year, displayedDate.month, displayedDate.day).toLocal();
          ref.read(appStateProvider.notifier).setDisplayedDate(date);
        }
      },
    );
  }

  void _arrowLeft(WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    ref.read(appStateProvider.notifier).prevDisplayedDate();
    debugPrint('appState: $appState');
  }

  void _arrowRight(WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    ref.read(appStateProvider.notifier).nextDisplayedDate();
    debugPrint('appState: $appState');
  }
}

class _DiaryTabs extends ConsumerWidget {
  final TabController _tabController;
  const _DiaryTabs(this._tabController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        DayView(),
        WeekView(),
      ],
    );
  }
}
