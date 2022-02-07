import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  AuthenticationService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  String? get userId {
    return currentUser().uid;
  }

  String? get token {
    currentUser().getIdToken().then((idToken) {
      return idToken;
    });
    return null;
  }

  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  User? user() {
    return _firebaseAuth.currentUser;
  }

/*  Stream<User?> get authStateChanges {
    debugPrint('changes....');
    return _firebaseAuth.authStateChanges();
  }*/

  User currentUser() {
    return _firebaseAuth.currentUser!;
  }

  Future<String> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
        email: email,
        password: password,
      ));

      final idToken = await userCredential.user!.getIdToken();
      debugPrint('idToken: $idToken');
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<String> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final idToken = await userCredential.user!.getIdToken();
      debugPrint('idToken: $idToken');
      return 'Signed up';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
