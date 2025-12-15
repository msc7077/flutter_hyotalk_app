import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// 기관 정보 로드 요청 (기관 아이디로)
class AgencyInfoLoadRequested extends HomeEvent {
  final String agencyId;

  const AgencyInfoLoadRequested(this.agencyId);

  @override
  List<Object?> get props => [agencyId];
}

