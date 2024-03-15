import 'package:flutter/widgets.dart';
import 'package:notesapp/utilities/dialogues/generic_dialogue.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Password Reset',
    content:
        'We have now sent you an email to reset your password. Click the link in the email to reset your passowrd',
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
