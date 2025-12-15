import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:go_router/go_router.dart';

class AppErrorDialog extends StatelessWidget {
  final String message;
  final String title;

  const AppErrorDialog({super.key, required this.message, this.title = AppTexts.error});

  static void show(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => AppErrorDialog(message: message, title: title ?? AppTexts.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [TextButton(onPressed: () => context.pop(), child: const Text(AppTexts.confirm))],
    );
  }
}
