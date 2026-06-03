import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;

  static Future<User> signUp(
      {required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    return user;
  }

  static Future<User> logIn(
      {required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    return user;
  }

  static Future<bool> isThisEmailToken({required String email}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: 'check_only_dummy_123!',
      );
      // Se chegou aqui, email não existia — deleta o usuário criado
      await _firebaseAuth.currentUser?.delete();
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true;
      }
      return false;
    }
  }

  static Future signOut() async => await _firebaseAuth.signOut();
}
