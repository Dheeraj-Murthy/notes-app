import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogues/generic_dialogue.dart';

Future<bool> showDeleteDialoge(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete this note?',
    optionBuilder: () => {
      'Yes': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}
