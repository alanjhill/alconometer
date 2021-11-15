import 'package:alconometer/features/drinks/drinks_tab_view.dart';
import 'package:alconometer/widgets/custom_app_bar.dart';
import 'package:alconometer/features/home/drinks_tab_manager.dart';
import 'package:alconometer/providers/app_state_manager.dart';
import 'package:alconometer/providers/drink.dart';
import 'package:alconometer/providers/drinks.dart';
import 'package:alconometer/widgets/app_drawer.dart';
import 'package:alconometer/widgets/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrinksScreen extends StatefulWidget {
  static const routeName = '/drinks';

  const DrinksScreen({Key? key}) : super(key: key);

  @override
  State<DrinksScreen> createState() => _DrinksScreenState();
}

class _DrinksScreenState extends State<DrinksScreen> with SingleTickerProviderStateMixin {
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length, initialIndex: 0);
    _tabController.addListener(_setTab);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = Provider.of<DrinksTabManager>(context).selectedTab;
    _tabController.animateTo(selectedTab);
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Drinks'),
        bottom: CustomTabBar(
          color: Theme.of(context).canvasColor,
          tabBar: TabBar(
            overlayColor: MaterialStateProperty.all(Colors.green),
            indicatorColor: Colors.blueGrey,
            controller: _tabController,
            padding: const EdgeInsets.all(0.0),
            onTap: _drinksViewTypeHandler,
            tabs: _tabs,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _DrinksTabs(_tabController),
    );
  }

  void _setTab() {
    _tabController.animateTo(_tabController.index);
    _drinksViewTypeHandler(_tabController.index);
  }

  void _drinksViewTypeHandler(int index) {
    if (index == 0) {
      Provider.of<AppStateManager>(context, listen: false).setDrinkType(DrinkType.beer);
    } else if (index == 1) {
      Provider.of<AppStateManager>(context, listen: false).setDrinkType(DrinkType.wine);
    } else {
      Provider.of<AppStateManager>(context, listen: false).setDrinkType(DrinkType.spirit);
    }
  }
}

class _DrinksTabs extends StatelessWidget {
  final TabController _tabController;

  const _DrinksTabs(this._tabController);

  @override
  Widget build(BuildContext context) {
    final drinksData = Provider.of<Drinks>(context);
    final drinks = drinksData.items;
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        DrinksTabView(drinkType: DrinkType.beer, drinks: drinks),
        DrinksTabView(drinkType: DrinkType.wine, drinks: drinks),
        DrinksTabView(drinkType: DrinkType.spirit, drinks: drinks),
      ],
    );
  }
}
