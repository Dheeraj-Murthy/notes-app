import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogues/generic_dialogue.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
