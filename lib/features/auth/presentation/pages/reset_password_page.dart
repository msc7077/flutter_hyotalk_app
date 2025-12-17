import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/core/widget/dialog/app_common_dialog.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? ci;
  final String? cd;

  const ResetPasswordPage({
    super.key,
    this.ci,
    this.cd,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _isValidating = true;

  @override
  void initState() {
    super.initState();
    AppLoggerService.i('ResetPasswordPage - ci: ${widget.ci}, cd: ${widget.cd}');

    if (widget.ci == null || widget.cd == null) {
      // ci/cd가 없으면 본인인증 페이지로 리다이렉트
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppCommonDialog.show(
            context,
            '본인인증이 필요합니다.',
            title: AppTexts.error,
            onConfirm: () {
              context.pushNamed(
                AppRouterName.selfCertificationName,
                queryParameters: {'nextRoute': AppRouterName.resetPasswordName},
              );
            },
          );
        }
      });
    } else {
      setState(() {
        _isValidating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isValidating || widget.ci == null || widget.cd == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('비밀번호 재설정')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 재설정')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('비밀번호 재설정 페이지'),
            const SizedBox(height: 16),
            Text('CI: ${widget.ci}'),
            Text('CD: ${widget.cd}'),
            // TODO: 비밀번호 재설정 폼 구현
          ],
        ),
      ),
    );
  }
}
