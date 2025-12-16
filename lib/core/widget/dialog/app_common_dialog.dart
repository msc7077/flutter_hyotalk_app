import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:go_router/go_router.dart';

/// 공통 다이얼로그
///
class AppCommonDialog extends StatelessWidget {
  final String message;
  final String? title; // nullable로 변경
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel; // 취소 콜백 추가
  final bool showCancel; // 취소 버튼 표시 여부

  const AppCommonDialog({
    super.key,
    required this.message,
    this.title,
    this.onConfirm,
    this.onCancel,
    this.showCancel = false, // 기본값: 취소 버튼 없음
  });

  static void show(
    BuildContext context,
    String message, {
    String? title,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AppCommonDialog(
        message: message,
        title: title,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showCancel: showCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title이 null이면 표시하지 않음
      title: title != null ? Text(title!) : null,
      content: Text(message),
      actions: [
        // 취소 버튼 (showCancel이 true일 때만 표시)
        if (showCancel)
          TextButton(
            onPressed: () {
              context.pop();
              onCancel?.call();
            },
            child: const Text(AppTexts.cancel),
          ),
        // 확인 버튼
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
