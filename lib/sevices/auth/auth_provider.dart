// import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/sevices/auth/auth_user.dart';

/* class AuthProvider {
  final User? user;
  const AuthProvider(this.user);

  factory AuthProvider.fromFirebase() =>
      AuthProvider(FirebaseAuth.instance.currentUser);
} */

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
