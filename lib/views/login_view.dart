import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/sevices/auth/auth_exceptions.dart';
import 'package:notesapp/sevices/auth/bloc/auth_bloc.dart';
import 'package:notesapp/sevices/auth/bloc/auth_events.dart';
import 'package:notesapp/sevices/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialogue(
                context, 'Cannot find user with the entered credentials');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialogue(context, 'wrong credentials.');
          } else if (state.exception is GenericAuthExceptions) {
            await showErrorDialogue(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.greenAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(''),
              const Text(
                  style: TextStyle(
                    color: Color.fromARGB(255, 2, 131, 0),
                    fontWeight: FontWeight.bold,
                  ),
                  'Please log into your account to create and edit notes'),
              const Text(''),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  hintText: 'enter your email',
                  border: OutlineInputBorder(),
                ),
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _password,
                decoration: const InputDecoration(
                  hintText: 'enter your password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const Text(''),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      if (email == '' && password == '') {
                        await showErrorDialogue(
                          context,
                          'email and password text boxes cannot be empty',
                        );
                      } else {
                        context.read<AuthBloc>().add(AuthEventLogIn(
                              email: email,
                              password: password,
                            ));
                      }
                    },
                    child: const Text(
                      'Login',
                      selectionColor: Colors.blue,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: const Text('Forgot Password'),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text('Not registered yet? Registere here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
