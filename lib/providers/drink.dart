import 'package:alconometer/models/drink_type.dart';
import 'package:flutter/foundation.dart';

//enum DrinkType { unassigned, beer, wine, spirit }

@immutable
class _Drink {
  final String? id;
  final String name;
  final DrinkType type;
  final double? abv;

  const _Drink({
    required this.id,
    required this.name,
    required this.type,
    required this.abv,
  });

  const _Drink.empty()
      : id = null,
        name = '',
        type = DrinkType.unassigned,
        abv = 0.0;

  static _Drink fromMap(String key, Map<String, dynamic> drinkJson) {
    return _Drink(
      id: key,
      name: drinkJson['name'],
      type: DrinkType.values.firstWhere((dt) => dt.toString() == drinkJson['type']),
      abv: drinkJson['abv'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'type': type.toString(),
      'abv': abv,
    };
    return map;
  }

  _Drink copyWith({
    String? id,
    String? name,
    DrinkType? type,
    double? abv,
  }) {
    return _Drink(
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

  @override
  String toString() {
    return 'Drink{id: $id, name: $name, type: $type, abv: $abv}';
  }
}

final beer = _Drink(id: '', name: 'BRIDGE BREWING IRONWORKERS IPA', type: DrinkType.beer, abv: 0.05);
final wine = _Drink(id: '', name: 'SUMAC RIDGE SAUVIGNON BLANC', type: DrinkType.wine, abv: 0.12);
final whisky = _Drink(id: '', name: 'JACK DANIEL\'S', type: DrinkType.spirit, abv: 0.40);
