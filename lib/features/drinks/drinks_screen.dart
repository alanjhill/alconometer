import 'package:alconometer/features/drinks/drinks_state.dart';
import 'package:alconometer/features/drinks/drinks_tab_view.dart';
import 'package:alconometer/models/drink.dart';
import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/providers/app_state.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/widgets/app_drawer.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:alconometer/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// >>> Providers
final drinksByTypeStreamProvider = StreamProvider.autoDispose.family<List<Drink>, DrinkType>(
  (ref, drinkType) {
    final database = ref.watch(databaseProvider);
    return database.drinksByTypeStream(drinkType);
  },
);

class DrinksScreen extends ConsumerStatefulWidget {
  static const routeName = '/drinks';

  const DrinksScreen({Key? key}) : super(key: key);

  @override
  _DrinksScreenState createState() => _DrinksScreenState();
}

class _DrinksScreenState extends ConsumerState<DrinksScreen> with SingleTickerProviderStateMixin {
  final List<Tab> _tabs = <Tab>[
    const Tab(
      icon: Icon(FontAwesomeIcons.beer),
      text: 'beer',
    ),
    const Tab(
      icon: Icon(FontAwesomeIcons.wineGlassAlt),
      text: 'wine',
    ),
    const Tab(
      icon: Icon(FontAwesomeIcons.glassWhiskey),
      text: 'spirits',
    ),
  ];
  late TabController _tabController;
  static final _drinksScreenKey = GlobalKey<_DrinksScreenState>();
  late List<Drink> drinks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length, initialIndex: 0);
    _tabController.addListener(_setTab);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_setTab);
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, __) {
      final drinksState = ref.watch(drinksStateProvider);
      final selectedTab = drinksState.selectedTab;
      //_tabController.animateTo(selectedTab!);
      return Scaffold(
        appBar: CustomAppBar(
          title: const Text('Drinks'),
          bottom: CustomTabBar(
            color: Theme.of(context).canvasColor,
            tabBar: TabBar(
              indicatorColor: Colors.blueGrey,
              controller: _tabController,
              padding: const EdgeInsets.all(0.0),
              onTap: (index) {
                _drinksViewTypeHandler(ref, index);
              },
              tabs: _tabs,
            ),
          ),
        ),
        drawer: const AppDrawer(),
        body: _DrinksTabs(_tabController),
      );
    });
  }

  void _setTab() {
    _tabController.animateTo(_tabController.index);
  }

  void _drinksViewTypeHandler(WidgetRef ref, int index) {
    if (index == 0) {
      ref.read(appStateProvider.notifier).setDrinkType(DrinkType.beer);
    } else if (index == 1) {
      ref.read(appStateProvider.notifier).setDrinkType(DrinkType.wine);
    } else {
      ref.read(appStateProvider.notifier).setDrinkType(DrinkType.spirit);
    }
  }
}

class _DrinksTabs extends ConsumerWidget {
  final TabController _tabController;
  const _DrinksTabs(this._tabController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinksBeerAsyncValue = ref.watch(drinksByTypeStreamProvider(DrinkType.beer));
    final drinksWineAsyncValue = ref.watch(drinksByTypeStreamProvider(DrinkType.wine));
    final drinksSpiritAsyncValue = ref.watch(drinksByTypeStreamProvider(DrinkType.spirit));
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        DrinksTabView(drinkType: DrinkType.beer, drinks: drinksBeerAsyncValue),
        DrinksTabView(drinkType: DrinkType.wine, drinks: drinksWineAsyncValue),
        DrinksTabView(drinkType: DrinkType.spirit, drinks: drinksSpiritAsyncValue),
      ],
    );
  }
}
