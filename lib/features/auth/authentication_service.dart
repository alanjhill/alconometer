import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  AuthenticationService(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<String> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> logout() async {
    try {
      await _firebaseAuth.signOut();
      return 'Signed Out';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
