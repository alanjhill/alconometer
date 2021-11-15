import 'package:flutter/foundation.dart';

enum DrinkType { unassigned, beer, wine, spirit }

@immutable
class Drink {
  final String? id;
  final String name;
  final DrinkType type;
  final double? abv;

  const Drink({required this.id, required this.name, required this.type, required this.abv});

  const Drink.empty()
      : id = null,
        name = '',
        type = DrinkType.unassigned,
        abv = 0.0;

  Drink copyWith({
    String? id,
    String? name,
    DrinkType? type,
    double? abv,
  }) {
    return Drink(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      abv: abv ?? this.abv,
    );
  }

  bool filterByName(String filter) {
    debugPrint('filter: $filter');
    return name.contains(filter);
  }
}

final beer = Drink(id: '', name: 'BRIDGE BREWING IRONWORKERS IPA', type: DrinkType.beer, abv: 0.05);
final wine = Drink(id: '', name: 'SUMAC RIDGE SAUVIGNON BLANC', type: DrinkType.wine, abv: 0.12);
final whisky = Drink(id: '', name: 'JACK DANIEL\'S', type: DrinkType.spirit, abv: 0.40);
