import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final String title;

  const ErrorDialog({super.key, required this.message, this.title = '오류'});

  static void show(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(message: message, title: title ?? '오류'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    );
  }
}
