import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';

class SelfCertificationPage extends StatefulWidget {
  final String? nextRoute;
  final String? errorMessage;

  const SelfCertificationPage({super.key, this.nextRoute, this.errorMessage});

  @override
  State<SelfCertificationPage> createState() => _SelfCertificationPageState();
}

class _SelfCertificationPageState extends State<SelfCertificationPage> {
  @override
  void initState() {
    super.initState();
    AppLoggerService.i(
      'SelfCertificationPage - nextRoute: ${widget.nextRoute}, error: ${widget.errorMessage}',
    );

    // 에러 메시지가 있으면 다이얼로그 표시
    if (widget.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showErrorDialog(widget.errorMessage!);
        }
      });
    }
  }

  /// 에러 다이얼로그 표시
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('본인인증 실패'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('확인')),
        ],
      ),
    );
  }

  /// 본인인증 웹뷰로 이동
  void _onCertification() {
    if (widget.nextRoute != null) {
      context.pushNamed(
        AppRouterName.selfCertificationWebViewName,
        queryParameters: {'nextRoute': widget.nextRoute!},
      );
    } else {
      // nextRoute가 없으면 이전 페이지로 돌아가기
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('본인인증')),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const Icon(Icons.verified_user, size: 64, color: Colors.blue),
      //       const SizedBox(height: 24),
      //       const Text('본인인증이 필요합니다', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //       const SizedBox(height: 8),
      //       const SizedBox(height: 32),
      //       ElevatedButton(
      //         onPressed: _onCertification,
      //         style: ElevatedButton.styleFrom(
      //           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      //         ),
      //         child: Text('본인인증 하기', style: AppTextStyles.text10blackW400),
      //       ),
      //     ],
      //   ),
      // ),
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '본인인증으로 찾기',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: const Text(
                  '본인 명의의 휴대폰 인증을 통해\n해당하는 회원 정보를 찾습니다.',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
              GestureDetector(
                onTap: _onCertification,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0),
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone_android_sharp, size: 60.0),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: const Text("휴대폰 인증", style: TextStyle(fontSize: 17)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 80.0),
                child: const Text(
                  '유의사항',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: const Text(
                  '본인 인증 후 회원가입 시, 제공된 휴대폰 번호는 계정관리 및\n서비스 이용을 위해 해당기관에 저장됩니다',
                  style: TextStyle(color: Colors.black38, fontSize: 13.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
