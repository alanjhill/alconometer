import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/services/api_service.dart';
import 'package:alconometer/services/authentication_service.dart';
import 'package:alconometer/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>((ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final appSettingsManagerProvider = Provider<AppSettingsManager>(
  (ref) {
    return AppSettingsManager();
  },
);

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService(FirebaseAuth.instance);
});

final databaseProvider = Provider<Database>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.asData?.value?.uid != null) {
    return Database(uid: auth.asData!.value!.uid);
  }
  throw UnimplementedError();
});
