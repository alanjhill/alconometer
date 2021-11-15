import 'dart:async';

import 'package:alconometer/constants.dart';
import 'package:alconometer/features/diary/edit_diary_entry.dart';
import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/providers/diary_entries.dart';
import 'package:alconometer/providers/diary_entry.dart';
import 'package:alconometer/theme/palette.dart';
import 'package:alconometer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DiaryItem extends StatelessWidget {
  final DiaryEntry diaryEntry;
  final int index;

  DiaryItem({Key? key, required this.diaryEntry, required this.index});

  @override
  Widget build(BuildContext context) {
    final darkMode = Provider.of<AppSettingsManager>(context).darkMode;
    return Slidable(
      key: Key(diaryEntry.id!),
      movementDuration: const Duration(milliseconds: 500),
      actionPane: const SlidableBehindActionPane(),
      actionExtentRatio: 0.2,
      actions: [
        IconSlideAction(
          icon: Icons.copy,
          color: getRowColor(index, darkMode),
          onTap: () async {
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
              await _duplicateDiaryEntry(context, diaryEntry: diaryEntry);
            }
          },
        )
      ],
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: getRowColor(index, darkMode),
          onTap: () async {
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
              await _dismissDiaryEntry(context, id: diaryEntry.id!);
            }
          },
        )
      ],
      child: Container(
        padding: const EdgeInsets.all(0),
        color: getRowColor(index, darkMode),
        child: ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: getDrinkTypeIcon(diaryEntry.drink!.type, size: 18.0),
            title: Text(
              diaryEntry.drink!.name,
            ),
            subtitle: Text('${diaryEntry.volume}ml - ${diaryEntry.drink!.abv}%'),
            trailing: Text('${diaryEntry.units}\nUnits'),
            onTap: () async {
              _editDiaryEntry(context, id: diaryEntry.id!);
            }),
      ),
    );
  }

  Future<void> _dismissDiaryEntry(BuildContext context, {required String id}) async {
    Provider.of<DiaryEntries>(context, listen: false).deleteDiaryEntry(id);
  }

  Future<bool> _duplicateDiaryEntry(BuildContext context, {required DiaryEntry diaryEntry}) async {
    Provider.of<DiaryEntries>(context, listen: false).duplicateDiaryEntry(diaryEntry);
    return true;
  }

  void _editDiaryEntry(BuildContext context, {required String id}) {
    Navigator.of(context).pushNamed(
      EditDiaryEntry.routeName,
      arguments: EditDiaryEntryArguments(
        drink: diaryEntry.drink,
        drinkType: diaryEntry.drink!.type,
        id: id,
      ),
    );
  }
}
