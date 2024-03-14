import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialise extends AuthEvent {
  const AuthEventInitialise();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn({required this.email, required this.password});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
