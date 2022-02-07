import 'package:alconometer/features/drinks/drink_item.dart';
import 'package:alconometer/models/diary_entry.dart';
import 'package:alconometer/models/drink.dart';
import 'package:alconometer/models/drink_type.dart';
import 'package:alconometer/providers/top_level_providers.dart';
import 'package:alconometer/widgets/empty_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final diaryEntriesStreamProvider = StreamProvider.autoDispose<List<DiaryEntry>>(
  (ref) {
    final database = ref.watch(databaseProvider);
    return database.diaryEntriesStream();
  },
);

class DrinksList extends ConsumerWidget {
  const DrinksList({Key? key, required this.drinkType, required this.drinks}) : super(key: key);
  final DrinkType drinkType;
  final AsyncValue<List<Drink>> drinks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return drinks.when(
      data: (items) => items.isNotEmpty ? _buildList(ref, items) : const EmptyContent(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now: $error, $stackTrace',
      ),
    );
  }
}

Widget _buildList(WidgetRef ref, List<Drink> drinks) {
  final diaryEntriesProvider = ref.watch(diaryEntriesStreamProvider);
  List<DiaryEntry> diaryEntries = [];
  diaryEntriesProvider.whenData((items) {
    diaryEntries = [...items];
  });

  // Sort the drinks
  drinks.sort((a, b) => a.name.compareTo(b.name));
  return SlidableAutoCloseBehavior(
    child: CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return DrinkItem(
                diaryEntries: diaryEntries,
                drink: drinks[index],
                index: index,
              );
            },
            childCount: drinks.length,
          ),
        ),
      ],
    ),
  );
}

/*
class _DrinksList extends StatelessWidget {
  final List<Drink> drinks;

  const _DrinksList({Key? key, required this.drinks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: drinks.length,
        itemBuilder: (content, index) => DrinkItem(drink: drinks[index], index: index),
      )
    ]);
  }
}
*/
