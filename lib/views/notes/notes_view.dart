// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/enums/menu_action.dart';
import 'package:notesapp/sevices/auth/auth_service.dart';
import 'package:notesapp/sevices/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('myNotes'),
          backgroundColor: Colors.greenAccent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuItems>(onSelected: (value) async {
              switch (value) {
                case MenuItems.logout:
                  final shouldLogOut = await logOutDialogueBox(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allnotes = snapshot.data as List<DatabaseNotes>;
                        return ListView.builder(
                          itemCount: allnotes.length,
                          itemBuilder: (context, index) {
                            final note = allnotes[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(251, 209, 209, 1),
                                    width: 3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(2),
                              padding: const EdgeInsets.all(3),
                              child: ListTile(
                                title: Text(note.notes),
                              ),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
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
