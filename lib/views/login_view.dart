import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;


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
            decoration: const InputDecoration(
              hintText: 'enter your email'
            ),
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
                final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email, 
                  password: password,
                );
                log(userCredential.toString());
                Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (_) => false);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  log('user not found');
                } else if (e.code == 'wrong-password') {
                  log('wrong password');
                } else {
                  log('something else happened');
                  log(e.code); 
                }
              }
            },
            child: const Text('Login', selectionColor: Colors.blue,)
          ),
          TextButton(
            onPressed:  () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/', 
                (route) => false
              );
            },
            child: const Text('Not registered yet? Registere here')
          ),
        ],
      ),
    );
  }
}