import 'package:flutter/material.dart';
import 'package:notes/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () {
      return {'OK': null};
    },
  );
}
