import 'package:firebase_auth/firebase_auth.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register(String name, String email, String password) async {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;

  }

  Future<User?> signIn(String email, String password) async {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;

  }
}
