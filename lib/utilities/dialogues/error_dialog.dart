import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogues/generic_dialogue.dart';

Future<void> showErrorDialogue(
  BuildContext context,
  String text,
) {
  return showGenericDialogue(
      context: context,
      title: 'Error:',
      content: text,
      optionBuilder: () => {
            'OK': null,
          });
}
