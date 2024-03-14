import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/sevices/auth/bloc/auth_bloc.dart';
import 'package:notesapp/sevices/auth/bloc/auth_events.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(children: [
        const Text(
            'We have sent you a verification email. Please confirm your email by clicking on the link.'),
        TextButton(
          onPressed: () async {
            context.read<AuthBloc>().add(
                  const AuthEventSendEmailVerification(),
                );
          },
          child: const Text('resend email'),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
          },
          child: const Text('Restart Process'),
        ),
      ]),
    );
  }
}
