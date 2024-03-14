// import 'dart:developer';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/enums/menu_action.dart';
import 'package:notesapp/sevices/auth/auth_service.dart';
import 'package:notesapp/sevices/cloud/firebase_cloud_storage.dart';
// import 'package:notesapp/sevices/crud/notes_service.dart';
import 'package:notesapp/utilities/dialogues/logout_dialog.dart';
import 'package:notesapp/views/notes/note_list_view.dart';
import 'package:notesapp/sevices/cloud/cloud_note.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    // _notesService.open();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('myNotes'),
            backgroundColor: Colors.greenAccent,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createUpdateNotesRoute);
                },
                icon: const Icon(Icons.add),
              ),
              PopupMenuButton<MenuItems>(onSelected: (value) async {
                switch (value) {
                  case MenuItems.logout:
                    final shouldLogOut =
                        await logOutDialogueBox(context); // show logout dialog
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
        // backgroundColor: const Color.fromARGB(255, 200, 200, 200),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allnotes = snapshot.data as Iterable<CloudNote>;
                  log(allnotes.toString());
                  return NotesListView(
                    notes: allnotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                        documentId: note.documentId,
                      );
                    },
                    onTap: (note) async {
                      Navigator.of(context).pushNamed(
                        createUpdateNotesRoute,
                        arguments: note,
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
        ));
  }
}
/* 
Future<bool> logOutDialogueBox(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text(
            'Confirm Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
 */