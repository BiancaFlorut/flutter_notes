import 'package:flutter/material.dart';
import 'package:notes/utilities/dialog/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () {
      return {'Cancel': false, 'Log out': true};
    },
  ).then((value) => value ?? false);
}
