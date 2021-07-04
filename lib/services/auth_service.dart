import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Monitor de estado do usuário
  Stream<User> get currentUser => _auth.authStateChanges();

  //Autenticação - Sign in with credential
  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  //Log out
  Future<void> logout() => _auth.signOut();
}
