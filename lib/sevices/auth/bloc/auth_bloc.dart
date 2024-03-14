import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/sevices/auth/auth_provider.dart';
import 'package:notesapp/sevices/auth/bloc/auth_events.dart';
import 'package:notesapp/sevices/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialise>(
      (event, emit) async {
        await provider.initialise();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut());
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLogInFailure(exception: e));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLogOutFailure(exception: e));
      }
    });
  }
}
