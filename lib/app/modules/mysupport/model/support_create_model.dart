import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';

import 'support_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class SupportCreateResponse {
  bool? isSuccess;
  String? vMessage;
  MySupport? data;

  SupportCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory SupportCreateResponse.fromJson(dynamic json) =>
      _$SupportCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportCreateResponseToJson(this);
}

SupportCreateResponse _$SupportCreateResponseFromJson(Map<String, dynamic> json) =>
    SupportCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ?  MySupport.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$SupportCreateResponseToJson(SupportCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };