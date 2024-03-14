import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' show log;
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/sevices/auth/auth_exceptions.dart';
import 'package:notesapp/sevices/auth/bloc/auth_bloc.dart';
import 'package:notesapp/sevices/auth/bloc/auth_events.dart';
import 'package:notesapp/utilities/dialogues/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
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
                try {
                  context.read<AuthBloc>().add(AuthEventLogIn(
                        email: email,
                        password: password,
                      ));
                } on UserNotFoundAuthException {
                  log('User not found');
                  if (context.mounted) {
                    await showErrorDialogue(
                      context,
                      'user not found',
                    );
                  }
                } on WrongPasswordAuthException {
                  log('Wrong password');
                  if (context.mounted) {
                    await showErrorDialogue(
                      context,
                      'wrong password',
                    );
                  }
                } on GenericAuthExceptions {
                  log('Something else happened');
                  // log(e.code);
                  if (context.mounted) {
                    await showErrorDialogue(
                      context,
                      'Authentication error',
                    );
                  }
                }
              },
              child: const Text(
                'Login',
                selectionColor: Colors.blue,
              )),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Registere here')),
        ],
      ),
    );
  }
}
