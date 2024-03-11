import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' show log;
import 'package:notesapp/constants/routes.dart';
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                if (context.mounted) {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
                // log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  // log('email already in use');
                  if (context.mounted) {
                    await showErrorDialogue(
                      context,
                      'Email Already in Use',
                    );
                  }
                } else if (e.code == 'weak-password') {
                  // log('password too weak');
                  if (context.mounted) {
                    await showErrorDialogue(
                      context,
                      'Password is too weak: \n consider using Uppercase, Lowercase, numbers and special characters to strengthen your password',
                    );
                  }
                } else {
                  // log(e.code);
                  if (context.mounted) {
                    await showErrorDialogue(
                      context,
                      'error: $e',
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  await showErrorDialogue(
                    context,
                    'error: $e',
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
