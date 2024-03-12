import 'package:flutter/material.dart';
// import 'dart:developer' show log;
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/sevices/auth/auth_exceptions.dart';
import 'package:notesapp/sevices/auth/auth_service.dart';
import 'package:notesapp/utilities/show_error_dialogue.dart';

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
    return Scaffold(
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
              try {
                // final userCredential =
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                if (context.mounted) {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
                // log(userCredential.toString());
              } on EmailAlreadyInUseAuthException {
                if (context.mounted) {
                  await showErrorDialogue(
                    context,
                    'Email Already in Use',
                  );
                }
              } on WeakPasswordAuthException {
                if (context.mounted) {
                  await showErrorDialogue(
                    context,
                    'Password is too weak: \n consider using Uppercase, Lowercase, numbers and special characters to strengthen your password',
                  );
                }
              } on InvalidEmailAuthException {
                if (context.mounted) {
                  await showErrorDialogue(
                    context,
                    'please enter a valid email address',
                  );
                }
              } on GenericAuthExceptions {
                if (context.mounted) {
                  await showErrorDialogue(
                    context,
                    'Failed to register',
                  );
                }
              }
            },
            child: const Text(
              'Register',
              selectionColor: Colors.blue,
            )),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Already registered? Click here to login")),
      ]),
    );
  }
}
