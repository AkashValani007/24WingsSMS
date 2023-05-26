import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class ChangePasswordResponse {
  bool? isSuccess;
  String? vMessage;

  ChangePasswordResponse({
    required this.isSuccess,
    required this.vMessage,
  });

  factory ChangePasswordResponse.fromJson(dynamic json) =>
      _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}

ChangePasswordResponse _$ChangePasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
    );

Map<String, dynamic> _$ChangePasswordResponseToJson(
        ChangePasswordResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
    };
