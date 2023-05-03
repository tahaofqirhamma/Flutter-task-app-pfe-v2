import 'package:flutter/material.dart';

Future<void> showUpdateUserInfoDialog(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('Update user informations'),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        );
      }));
}
