import 'dart:async';
import 'package:notesapp/sevices/auth/auth_exceptions.dart';
import 'package:notesapp/sevices/auth/auth_provider.dart';
import 'package:notesapp/sevices/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();
      test('Should not be initialised to begin with', () {
        expect(provider.isInitialised, false);
      });
      test('cannot log out if not initialised', () {
        expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitialisedException>()),
        );
      });
      test('should be able to be initialised', () async {
        await provider.initialise();
        expect(provider.isInitialised, true);
      });
      test('user should be null after initialisation', () {
        expect(provider.currentUser, null);
      });
      test('initialisation should not take more than 2 sec', () async {
        await provider.initialise();
        expect(provider.isInitialised, true);
      }, timeout: const Timeout(Duration(seconds: 2)));
      test('user should be redirected to logIn function', () async {
        final badEmailUser = provider.createUser(
          email: 'foobar@baz.com',
          password: 'anypassword',
        );
        expect(badEmailUser,
            throwsA(const TypeMatcher<UserNotFoundAuthException>()));

        final badPassword = provider.createUser(
          email: 'dheerujaanu@gmail.com',
          password: 'hello',
        );
        expect(badPassword,
            throwsA(const TypeMatcher<WrongPasswordAuthException>()));

        final user = await provider.createUser(
          email: 'goober@gmail.com',
          password: 'yoyoy',
        );
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      });
      test('new user should able to send email verification', () {
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      });
      test('should be able to log out and log in again', () async {
        await provider.logOut();
        await provider.logIn(
          email: 'email',
          password: 'password',
        );
        final user = provider.currentUser;
        expect(user, isNotNull);
      });
    },
  );
}

class NotInitialisedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialised = false;
  bool get isInitialised => _isInitialised;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialised) throw NotInitialisedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialise() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialised = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialised) throw NotInitialisedException();
    if (email == 'foobar@baz.com') throw UserNotFoundAuthException();
    if (password == 'hello') throw WrongPasswordAuthException();
    var user = AuthUser(isEmailVerified: false, email: email, id: '123');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialised) throw NotInitialisedException();
    await Future.delayed(const Duration(seconds: 1));
    if (_user == null) throw UserNotFoundAuthException();
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialised) throw NotInitialisedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    var newUser = AuthUser(isEmailVerified: true, email: user.email, id: '123');
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    if (!isInitialised) {
      throw NotInitialisedException();
    }
    if (toEmail == 'djkhaled@gmail.com') throw UserNotFoundAuthException();
    _user = await createUser(email: toEmail, password: ' ');
    throw NotInitialisedException();
  }
}
