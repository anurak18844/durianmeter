import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithCrediential(AuthCredential authCredential) =>
      _auth.signInWithCredential(authCredential);

  Future<void> logout() => _auth.signOut();

  Stream<User?> get currentUser => _auth.authStateChanges();
}

