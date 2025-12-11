import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppErrorDialog extends StatelessWidget {
  final String message;
  final String title;

  const AppErrorDialog({super.key, required this.message, this.title = '오류'});

  static void show(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => AppErrorDialog(message: message, title: title ?? '오류'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [TextButton(onPressed: () => context.pop(), child: const Text('확인'))],
    );
  }
}
