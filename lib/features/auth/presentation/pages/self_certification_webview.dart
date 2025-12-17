import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';
import 'package:flutter_hyotalk_app/features/auth/data/models/nice_token_model.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_name.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 본인인증 결과 데이터
class CertificationResult {
  final String ci;
  final String cd;
  final Map<String, dynamic>? extraData;

  CertificationResult({required this.ci, required this.cd, this.extraData});

  @override
  String toString() => 'CertificationResult(ci: $ci, cd: $cd)';
}

/// 본인인증 전용 웹뷰 위젯
class SelfCertificationWebViewPage extends StatefulWidget {
  final String? nextRoute;

  const SelfCertificationWebViewPage({super.key, this.nextRoute});

  @override
  State<SelfCertificationWebViewPage> createState() => _SelfCertificationWebViewPageState();
}

class _SelfCertificationWebViewPageState extends State<SelfCertificationWebViewPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  String? _certificationUrl;
  bool _isWebViewInitialized = false;

  @override
  void initState() {
    super.initState();
    AppLoggerService.i('SelfCertificationWebViewPage - nextRoute: ${widget.nextRoute}');

    // Bloc을 통해 NiceToken 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthBloc>().add(NiceTokenRequested());
      }
    });
  }

  /// NiceToken을 사용하여 본인인증 URL 생성
  String _buildCertificationUrl(NiceTokenModel niceToken) {
    // TODO: 실제 본인인증 서비스 URL 형식에 맞게 구현
    // Nice 본인인증 서비스에 따라 URL 형식이 다를 수 있음
    return 'https://example.com/certification?'
        'token_version_id=${niceToken.tokenVersionId}&'
        'enc_data=${niceToken.encData}&'
        'integrity_value=${niceToken.integrityValue}&'
        'keyiv=${niceToken.keyiv}';
  }

  void _initializeWebView(NiceTokenModel niceToken) {
    if (_isWebViewInitialized) return;

    _certificationUrl = _buildCertificationUrl(niceToken);
    AppLoggerService.i('CertificationWebView - URL: $_certificationUrl');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            AppLoggerService.i('CertificationWebView - Page started: $url');
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
            _checkCertificationResult(url);
          },
          onPageFinished: (String url) {
            AppLoggerService.i('CertificationWebView - Page finished: $url');
            setState(() {
              _isLoading = false;
            });
            _checkCertificationResult(url);
          },
          onWebResourceError: (WebResourceError error) {
            AppLoggerService.e('CertificationWebView - Error: ${error.description}');
            setState(() {
              _isLoading = false;
              _errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            _checkCertificationResult(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'CertificationChannel',
        onMessageReceived: (JavaScriptMessage message) {
          _handleJavaScriptMessage(message.message);
        },
      )
      ..loadRequest(Uri.parse(_certificationUrl!));

    _isWebViewInitialized = true;
  }

  /// JavaScript 메시지 처리 (본인인증 서비스에서 사용)
  void _handleJavaScriptMessage(String message) {
    try {
      AppLoggerService.i('CertificationWebView - JS Message: $message');
      final data = jsonDecode(message) as Map<String, dynamic>;

      if (data.containsKey('ci') && data.containsKey('cd')) {
        final result = CertificationResult(
          ci: data['ci'] as String,
          cd: data['cd'] as String,
          extraData: data,
        );
        _onCertificationSuccess(result);
      }
    } catch (e) {
      AppLoggerService.e('CertificationWebView - JS Message parse error: $e');
    }
  }

  /// URL에서 본인인증 결과 확인
  void _checkCertificationResult(String url) {
    AppLoggerService.i('CertificationWebView - Checking URL: $url');

    // 실패 케이스 확인 (먼저 체크)
    if (_checkCertificationFailure(url)) {
      return;
    }

    // 성공 케이스 확인
    // 방법 1: URL 쿼리 파라미터에서 ci, cd 추출
    final uri = Uri.tryParse(url);
    if (uri != null) {
      final ci = uri.queryParameters['ci'];
      final cd = uri.queryParameters['cd'];

      if (ci != null && cd != null) {
        final result = CertificationResult(ci: ci, cd: cd, extraData: uri.queryParameters);
        _onCertificationSuccess(result);
        return;
      }
    }

    // 방법 2: 커스텀 URL 스키마 감지
    if (url.startsWith('hyotalk://certification')) {
      final uri = Uri.parse(url);
      final ci = uri.queryParameters['ci'];
      final cd = uri.queryParameters['cd'];

      if (ci != null && cd != null) {
        final result = CertificationResult(ci: ci, cd: cd, extraData: uri.queryParameters);
        _onCertificationSuccess(result);
        return;
      }
    }

    // 방법 3: 본인인증 완료 경로 감지
    if (url.contains('/certification/success') || url.contains('/certification/complete')) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        final ci = uri.queryParameters['ci'];
        final cd = uri.queryParameters['cd'];

        if (ci != null && cd != null) {
          final result = CertificationResult(ci: ci, cd: cd, extraData: uri.queryParameters);
          _onCertificationSuccess(result);
        }
      }
    }
  }

  /// 본인인증 실패 확인
  bool _checkCertificationFailure(String url) {
    // 실패 URL 패턴 감지
    if (url.contains('/certification/fail') ||
        url.contains('/certification/error') ||
        url.contains('/certification/failure')) {
      final uri = Uri.tryParse(url);
      String? errorMessage;

      if (uri != null) {
        // URL에서 에러 메시지 추출
        errorMessage =
            uri.queryParameters['message'] ??
            uri.queryParameters['error'] ??
            '본인인증에 실패했습니다. 다시 시도해주세요.';
      } else {
        errorMessage = '본인인증에 실패했습니다. 다시 시도해주세요.';
      }

      _onCertificationFailure(errorMessage);
      return true;
    }

    // 이미 가입된 회원인 경우
    if (url.contains('/certification/already-registered') ||
        url.contains('/certification/duplicate')) {
      _onCertificationFailure('이미 가입된 회원입니다.');
      return true;
    }

    return false;
  }

  /// 본인인증 성공 처리
  void _onCertificationSuccess(CertificationResult result) {
    AppLoggerService.i('CertificationWebView - Success: $result');

    if (widget.nextRoute != null) {
      // ci, cd 값을 queryParameters로 전달하여 다음 페이지로 이동
      context.pushNamed(widget.nextRoute!, queryParameters: {'ci': result.ci, 'cd': result.cd});
    } else {
      // nextRoute가 없으면 이전 페이지로 돌아가기
      context.pop(result);
    }
  }

  /// 본인인증 실패 처리
  void _onCertificationFailure(String errorMessage) {
    AppLoggerService.e('CertificationWebView - Failure: $errorMessage');

    // SelfCertificationPage로 돌아가면서 에러 메시지 전달
    context.pop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        context.goNamed(
          AppRouterName.selfCertificationName,
          queryParameters: {
            if (widget.nextRoute != null) 'nextRoute': widget.nextRoute!,
            'error': errorMessage,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is NiceTokenCompleted) {
          // 토큰 로드 완료 시 웹뷰 초기화
          setState(() {
            _isLoading = false;
            _errorMessage = null;
          });
          _initializeWebView(state.niceToken);
        } else if (state is NiceTokenFailure) {
          // 토큰 로드 실패 시 에러 표시
          setState(() {
            _isLoading = false;
            _errorMessage = state.message;
          });
        } else if (state is NiceTokenLoading) {
          // 로딩 상태
          setState(() {
            _isLoading = true;
            _errorMessage = null;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('본인인증')),
        body: Stack(
          children: [
            if (_errorMessage != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('오류가 발생했습니다'),
                    const SizedBox(height: 8),
                    Text(_errorMessage!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                        // NiceToken 다시 요청
                        context.read<AuthBloc>().add(NiceTokenRequested());
                      },
                      child: const Text('다시 시도'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // SelfCertificationPage로 돌아가기
                        context.pop();
                      },
                      child: const Text('돌아가기'),
                    ),
                  ],
                ),
              )
            else if (_controller != null && _isWebViewInitialized)
              WebViewWidget(controller: _controller!),
            if (_isLoading && _errorMessage == null)
              Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
