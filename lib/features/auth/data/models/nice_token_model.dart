import 'package:equatable/equatable.dart';

class NiceTokenModel extends Equatable {
  final String tokenVersionId;
  final String encData;
  final String integrityValue;
  final String keyiv;

  const NiceTokenModel({
    required this.tokenVersionId,
    required this.encData,
    required this.integrityValue,
    required this.keyiv,
  });

  factory NiceTokenModel.fromJson(Map<String, dynamic> json) {
    return NiceTokenModel(
      tokenVersionId: json['token_version_id'] as String,
      encData: json['enc_data'] as String,
      integrityValue: json['integrity_value'] as String,
      keyiv: json['keyiv'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'token_version_id': tokenVersionId,
    'enc_data': encData,
    'integrity_value': integrityValue,
    'keyiv': keyiv,
  };

  @override
  List<Object?> get props => [tokenVersionId, encData, integrityValue, keyiv];
}
