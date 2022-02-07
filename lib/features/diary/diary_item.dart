import 'package:alconometer/features/diary/edit_diary_entry.dart';
import 'package:alconometer/models/diary_entry_and_drink.dart';
import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/providers/app_settings.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/services/database.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class DiaryItem extends ConsumerWidget {
  final DiaryEntryAndDrink diaryEntryAndDrink;
  final int index;
  final bool displayDay;

  const DiaryItem({Key? key, required this.diaryEntryAndDrink, required this.index, this.displayDay = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(appSettingsProvider).darkMode!;
    final dateFormat = ref.watch(appSettingsProvider).dateFormat;
    final timeFormat = ref.watch(appSettingsProvider).timeFormat;
    return Column(
      key: ValueKey('drink-$index'),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        displayDay
            ? Container(
                width: double.infinity,
                color: darkMode ? Palette.primaryColor.withAlpha(100) : Palette.primaryColor.withAlpha(200),
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  DateFormat('EEEE, $dateFormat').format(diaryEntryAndDrink.diaryEntry.dateTime!.toLocal()),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              )
            : Container(),
        Slidable(
          key: Key(diaryEntryAndDrink.diaryEntry.id!),
          groupTag: 'diary_item',
          child: Container(
            padding: const EdgeInsets.all(0),
            color: getRowColor(index, darkMode),
            child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: getDrinkTypeIcon(diaryEntryAndDrink.drink.type, size: 18.0),
                title: Text(
                  diaryEntryAndDrink.drink.name,
                ),
                subtitle: Text(
                    '${DateFormat(timeFormat).format(diaryEntryAndDrink.diaryEntry.dateTime!.toLocal())} - ${diaryEntryAndDrink.drink.abv}% - ${diaryEntryAndDrink.diaryEntry.volume}ml'),
                trailing: Text('${diaryEntryAndDrink.units}\nUnits'),
                onTap: () async {
                  _editDiaryEntry(context, drinkType: diaryEntryAndDrink.drink.type, id: diaryEntryAndDrink.diaryEntry.id!);
                }),
          ),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                autoClose: true,
                icon: Icons.copy,
                backgroundColor: getRowColor(index, darkMode),
                foregroundColor: Palette.primaryColor,
                onPressed: (context) async {
                  var duplicate = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Duplicate diary entry'),
                      content: const Text('Are you sure you want to duplicate this entry?'),
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
                    await _duplicateDiaryEntry(ref, diaryEntryAndDrink: diaryEntryAndDrink);
                  }
                },
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                autoClose: true,
                icon: Icons.delete,
                backgroundColor: getRowColor(index, darkMode),
                foregroundColor: Palette.primaryColor,
                onPressed: (context) async {
                  var delete = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete diary entry'),
                      content: const Text('Are you sure you want to delete this entry?'),
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
                    await _dismissDiaryEntry(ref, id: diaryEntryAndDrink.diaryEntry.id!);
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _dismissDiaryEntry(WidgetRef ref, {required String id}) async {
    final database = ref.read<Database?>(databaseProvider)!;
    await database.deleteDiaryEntry(diaryEntryAndDrink.diaryEntry.id!);
  }

  Future<void> _duplicateDiaryEntry(WidgetRef ref, {required DiaryEntryAndDrink diaryEntryAndDrink}) async {
    final database = ref.read<Database?>(databaseProvider)!;
    await database.duplicateDiaryEntry(diaryEntryAndDrink.diaryEntry);
  }

  void _editDiaryEntry(BuildContext context, {required DrinkType drinkType, required String id}) {
    Navigator.of(context).pushNamed(
      EditDiaryEntry.routeName,
      arguments: EditDiaryEntryArguments(
        diaryEntryAndDrink: diaryEntryAndDrink,
        drinkType: drinkType,
      ),
    );
  }
}
