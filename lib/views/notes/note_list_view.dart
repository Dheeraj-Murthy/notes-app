import 'dart:developer';
import 'package:notesapp/sevices/cloud/cloud_note.dart';
import 'package:flutter/material.dart';
// import 'package:notesapp/sevices/crud/notes_service.dart';
import 'package:notesapp/utilities/dialogues/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        log(note.toString());
        return Container(
          foregroundDecoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 200, 200, 200), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          color: const Color.fromARGB(255, 243, 243, 243),
          margin: const EdgeInsets.all(0.1),
          padding: const EdgeInsets.all(3),
          child: ListTile(
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialoge(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
            onTap: () {
              onTap(note);
            },
          ),
        );
      },
    );
  }
}
