import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';

/// 앱에서 사용하는 로딩 인디케이터
///
/// 사용 예시:
/// ```dart
/// // 기본 사용 (기본 크기, 검은색)
/// AppLoadingIndicator()
///
/// // 작은 크기 (기본 검은색)
/// AppLoadingIndicator.small()
///
/// // 작은 크기, 흰색 (버튼 내부용)
/// AppLoadingIndicator.small(color: AppColors.white)
///
/// // 커스텀 크기와 색상
/// AppLoadingIndicator(
///   size: 24,
///   color: AppColors.primary,
///   strokeWidth: 3,
/// )
/// ```
class AppLoadingIndicator extends StatelessWidget {
  /// 로딩 인디케이터 크기
  final double? size;

  /// 로딩 인디케이터 색상
  final Color? color;

  /// 선 두께
  final double strokeWidth;

  /// 일반 리스트 로딩 인디케이터 생성
  ///
  /// 기본 색상: 검은색 (테마 primary 색상 사용 방지)
  const AppLoadingIndicator({
    super.key,
    this.size,
    this.color = AppColors.black,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
    );

    if (size != null) {
      return SizedBox(width: size, height: size, child: indicator);
    }

    return indicator;
  }
}
