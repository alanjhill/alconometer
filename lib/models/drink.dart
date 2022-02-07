import 'package:alconometer/models/drink_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Drink extends Equatable {
  Drink({
    this.id,
    required this.name,
    required this.type,
    required this.abv,
  });

  String? id;
  final String name;
  final DrinkType type;
  final double abv;

  @override
  List<Object> get props => [id!, name, type, abv];

  @override
  bool get stringify => true;

  Drink.empty()
      : id = null,
        name = '',
        type = DrinkType.unassigned,
        abv = 0.0;

  static Drink fromMap(String key, Map<String, dynamic> drinkJson) {
    //debugPrint('drinkJson: $drinkJson');
    try {
      return Drink(
        id: key,
        name: drinkJson['name'],
        type: DrinkType.values.firstWhere((dt) => dt.toString() == drinkJson['type']),
        abv: drinkJson['abv'].toDouble(),
      );
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      rethrow;
    }
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

  Drink copyWith({
    String? id,
    String? name,
    DrinkType? type,
    double? abv,
    bool? archived,
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

//final beer = Drink(id: '', name: 'BRIDGE BREWING IRONWORKERS IPA', type: DrinkType.beer, abv: 0.05);
//final wine = Drink(id: '', name: 'SUMAC RIDGE SAUVIGNON BLANC', type: DrinkType.wine, abv: 0.12);
//final whisky = Drink(id: '', name: 'JACK DANIEL\'S', type: DrinkType.spirit, abv: 0.40);
