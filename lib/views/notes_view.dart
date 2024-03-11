import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';

enum MenuItems { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('myNotes'),
          backgroundColor: Colors.greenAccent,
          actions: [
            PopupMenuButton<MenuItems>(onSelected: (value) async {
              switch (value) {
                case MenuItems.logout:
                  final shouldLogOut = await logOutDialogueBox(context);
                  if (shouldLogOut) {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                  }
                  break;
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuItems>(
                  value: MenuItems.logout,
                  child: Text('Log out'),
                )
              ];
            })
          ]),
      body: const Center(child: Text('this is a list of all of my notes')),
    );
  }
}

Future<bool> logOutDialogueBox(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('LogOut')),
          ]);
    },
  ).then((value) => value ?? false);
}
