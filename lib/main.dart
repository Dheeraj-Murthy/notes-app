import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/helpers/loading/loading_screen.dart';
import 'package:notesapp/sevices/auth/bloc/auth_bloc.dart';
import 'package:notesapp/sevices/auth/bloc/auth_events.dart';
import 'package:notesapp/sevices/auth/bloc/auth_state.dart';
import 'package:notesapp/sevices/auth/firebase_auth_provider.dart';
import 'package:notesapp/views/login_view.dart';
import 'package:notesapp/views/notes/create_update_note_view.dart';
import 'package:notesapp/views/notes/forgot_password_view.dart';
import 'package:notesapp/views/notes/notes_view.dart';
import 'package:notesapp/views/register_view.dart';
import 'package:notesapp/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 37, 191, 40)),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        registerRoute: (context) => const RegisterView(),
        createUpdateNotesRoute: (context) => const CreateUpdateNotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialise());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Please wait a moment',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }
}
