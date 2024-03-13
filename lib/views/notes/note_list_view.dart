import 'package:flutter/material.dart';
import 'package:notesapp/sevices/crud/notes_service.dart';
import 'package:notesapp/utilities/dialogues/delete_dialog.dart';

typedef DeleteNodeCallback = void Function(DatabaseNotes note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNotes> notes;
  final DeleteNodeCallback onDeleteNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
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
              note.notes,
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
          ),
        );
      },
    );
  }
}
