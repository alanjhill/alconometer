import 'package:alconometer/providers/app_settings_manager.dart';
import 'package:alconometer/services/api_service.dart';
import 'package:alconometer/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
