import 'package:flutter/foundation.dart';

@immutable
class AuthToken {
  final String? id;
  final DateTime? dateTime;
  final String? drinkId;
  final double? volume;
  final double? units;

  static AuthToken fromMap(String key, Map<String, dynamic> authToken) {
    return AuthToken(
      id: key,
      drinkId: authToken['drinkId'],
      dateTime: authToken['name'],
      volume: authToken['volume'],
    );
  }

  AuthToken copyWith({
    String? id,
    DateTime? dateTime,
    String? drinkId,
    double? volume,
    double? units,
  }) {
    return AuthToken(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      drinkId: drinkId ?? this.drinkId,
      volume: volume ?? this.volume,
      units: units ?? this.units,
    );
  }

  const AuthToken({
    required this.id,
    required this.dateTime,
    required this.drinkId,
    required this.volume,
    this.units,
  });
}
