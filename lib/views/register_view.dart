import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:developer' show log;
import 'package:notesapp/sevices/auth/auth_exceptions.dart';
import 'package:notesapp/sevices/auth/bloc/auth_bloc.dart';
import 'package:notesapp/sevices/auth/bloc/auth_events.dart';
import 'package:notesapp/sevices/auth/bloc/auth_state.dart';
import 'package:notesapp/utilities/dialogues/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialogue(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialogue(context, 'Email already in use');
          } else if (state.exception is GenericAuthExceptions) {
            await showErrorDialogue(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialogue(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: Colors.greenAccent,
        ),
        body: Column(children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'enter your email'),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              hintText: 'enter your password',
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventRegister(
                      email: email,
                      password: password,
                    ));
              },
              child: const Text(
                'Register',
                selectionColor: Colors.blue,
              )),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text("Already registered? Click here to login")),
        ]),
      ),
    );
  }
}
