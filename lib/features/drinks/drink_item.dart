import 'package:alconometer/alert_dialogs/alert_dialogs.dart';
import 'package:alconometer/features/diary/edit_diary_entry.dart';
import 'package:alconometer/features/drinks/edit_drink.dart';
import 'package:alconometer/models/diary_entry.dart';
import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/models/drink.dart';
import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/services/database.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DrinkItem extends ConsumerStatefulWidget {
  const DrinkItem({Key? key, required this.diaryEntries, required this.drink, required this.index}) : super(key: key);
  final List<DiaryEntry> diaryEntries;
  final Drink drink;
  final int index;

  @override
  _DrinkItemState createState() => _DrinkItemState();
}

class _DrinkItemState extends ConsumerState<DrinkItem> with SingleTickerProviderStateMixin {
  late AnimationController snackBarAnimationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    snackBarAnimationController = SnackBar.createAnimationController(vsync: this);
    snackBarAnimationController.duration = const Duration(seconds: 4);
    snackBarAnimationController.reverseDuration = const Duration(seconds: 4);
    animation = Tween<double>(begin: 0, end: 1).animate(snackBarAnimationController);
  }

  @override
  void dispose() {
    super.dispose();
    snackBarAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(appSettingsProvider).darkMode;
    return Column(
      key: ValueKey('drink-${widget.index}'),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slidable(
          key: Key(widget.drink.id!),
          groupTag: 'drink_item',
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.2,
            children: [
              CustomSlidableAction(
                backgroundColor: Palette.primaryColor,
                autoClose: true,
                onPressed: null,
                child: GestureDetector(
                  child: const Icon(Icons.more_vert),
                  onTapDown: (details) async {
                    final position = details.globalPosition;
                    final left = position.dx;
                    final top = position.dy;
                    final menuOption =
                        await showMenu<int>(context: context, position: RelativeRect.fromLTRB(0, top, 0, 0), items: _popupMenuItems(context, ref));
                    await _handleStartMenu(context, ref, menuOption!);
                  },
                ),
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                icon: Icons.delete,
                backgroundColor: Palette.primaryColor,
                autoClose: true,
                onPressed: (ctx) async {
                  var delete = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete drink'),
                      content: const Text('Are you sure you want to delete this drink?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                        ),
                      ],
                    ),
                  );
                  if (delete!) {
                    final count = await _dismissDrink(ref, drinkId: widget.drink.id!);
                    if (count == 0) {
                      Flushbar(
                        message: 'Drink deleted',
                        duration: const Duration(seconds: 3),
                        flushbarStyle: FlushbarStyle.GROUNDED,
                        backgroundColor: Palette.primaryColor,
                      ).show(context);
                    } else {
                      showAlertDialog(
                        context: context,
                        title: 'Drink cannot be deleted',
                        content: 'This drink is used in your diary and cannot be deleted.\n\nYou can always move it to the archive instead.',
                        defaultActionText: 'OK',
                      );
                    }
                  }
                },
              )
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(0),
            child: ListTile(
                dense: true,
                tileColor: getRowColor(widget.index, darkMode!),
                visualDensity: VisualDensity.compact,
                //leading: getDrinkTypeIcon(drink.type),
                title: Text(
                  widget.drink.name,
                ),
                //subtitle: Text('${getDrinkTypeText(drink.type)} - ${drink.abv}%'),
                subtitle: Text('${widget.drink.abv}%'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add drink to diary',
                  onPressed: () {
                    _addDrinkToDiary(widget.drink);
                  },
                  splashRadius: 28.0,
                ),
                onTap: () async {
                  _editDrink(context, drink: widget.drink);
                }),
          ),
        ),
      ],
    );
  }

  void _addDrinkToDiary(Drink drink) {
    Navigator.of(context).pushNamed(
      EditDiaryEntry.routeName,
      arguments: EditDiaryEntryArguments(
        drinkType: drink.type,
        drink: drink,
      ),
    );
  }

  List<PopupMenuItem<int>> _popupMenuItems(BuildContext context, WidgetRef ref) {
    return [
      _archivePopupMenuItem(context, ref),
      _duplicatePopupMenuItem(context, ref),
    ];
  }

  Future<void> _handleStartMenu(BuildContext context, WidgetRef ref, int menuOption) async {
    if (menuOption == 0) {
      var archive = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Archive drink'),
          content: const Text('Are you sure you want to move this drink to the archive?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        ),
      );
      if (archive!) {
        await _archiveDrink(ref, drinkId: widget.drink.id!);
      }
    } else if (menuOption == 1) {
      var duplicate = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Duplicate drink'),
          content: const Text('Are you sure you want to duplicate this drink?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
            ),
          ],
        ),
      );
      if (duplicate!) {
        await _duplicateDrink(ref, drink: widget.drink);
      }
    }
  }

  PopupMenuItem<int> _archivePopupMenuItem(BuildContext context, WidgetRef ref) {
    return const PopupMenuItem(
      value: 0,
      child: Text("Archive"),
      onTap: null,
    );
  }

  PopupMenuItem<int> _duplicatePopupMenuItem(BuildContext context, WidgetRef ref) {
    return const PopupMenuItem(
      value: 1,
      child: Text("Duplicate"),
      onTap: null,
    );
  }

  Future<int> _dismissDrink(WidgetRef ref, {required String drinkId}) async {
    final matchingDiaryEntries = widget.diaryEntries.where((diaryEntry) => diaryEntry.drinkId == drinkId);
    final count = matchingDiaryEntries.length;
    debugPrint('count: $count');
    if (count == 0) {
      final database = ref.watch(databaseProvider);
      await database.deleteDrink(drinkId);
    }
    return Future.value(count);
  }

  Future<void> _archiveDrink(WidgetRef ref, {required String drinkId}) async {
    final database = ref.read<Database?>(databaseProvider)!;
    await database.archiveDrink(drinkId);
  }

  Future<void> _duplicateDrink(WidgetRef ref, {required Drink drink}) async {
    final database = ref.read<Database?>(databaseProvider)!;
    await database.duplicateDrink(drink);
  }

  void _editDrink(BuildContext context, {required Drink drink}) {
    Navigator.of(context).pushNamed(
      EditDrink.routeName,
      arguments: EditDrinkArguments(
        drinkType: drink.type,
        drink: drink,
      ),
    );
  }
}
