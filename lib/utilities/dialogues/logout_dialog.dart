import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogues/generic_dialogue.dart';

Future<bool> logOutDialogueBox(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionBuilder: () => {
      'Cancel': false,
      'Logout': true,
    },
  ).then((value) => value ?? false);
}
