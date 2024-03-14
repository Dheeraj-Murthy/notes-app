import 'package:flutter/material.dart' show immutable;
import 'package:notesapp/sevices/auth/auth_user.dart';

//these are the states to be used in bloc
@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLogInFailure extends AuthState {
  final Exception exception;
  const AuthStateLogInFailure({required this.exception});
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure({required this.exception});
}
