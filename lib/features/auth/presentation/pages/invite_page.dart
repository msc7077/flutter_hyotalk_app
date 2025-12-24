import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_text_styles.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:go_router/go_router.dart';

/// 초대 딥링크 진입용 페이지
///
/// 현재는 inviteId를 확인할 수 있는 최소 UI만 제공한다.
/// (간편회원가입/가입 프로세스는 추후 연결)
class InvitePage extends StatelessWidget {
  const InvitePage({super.key, required this.inviteId});

  final String inviteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('초대')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('inviteId: $inviteId', style: AppTextStyles.text16blackW400),
            const SizedBox(height: 12),
            Text(
              '초대 링크로 앱에 진입했습니다.\n'
              '다음 단계에서 이 inviteId로 간편회원가입 화면을 연결할 예정입니다.',
              style: AppTextStyles.text13blackW400,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRouterPath.login),
              child: const Text('로그인 화면으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}


