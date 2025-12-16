import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:go_router/go_router.dart';

class AppErrorDialog extends StatelessWidget {
  final String message;
  final String title;
  final VoidCallback? onConfirm;

  const AppErrorDialog({
    super.key,
    required this.message,
    this.title = AppTexts.error,
    this.onConfirm,
  });

  static void show(BuildContext context, String message, {String? title, VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) =>
          AppErrorDialog(message: message, title: title ?? AppTexts.error, onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            onConfirm?.call();
          },
          child: const Text(AppTexts.confirm),
        ),
      ],
    );
  }
}
