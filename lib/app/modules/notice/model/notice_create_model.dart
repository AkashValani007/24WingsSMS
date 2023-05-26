import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';

import 'notice_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class NoticeCreateResponse {
  bool? isSuccess;
  String? vMessage;
  Notice? data;

  NoticeCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory NoticeCreateResponse.fromJson(dynamic json) =>
      _$NoticeCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeCreateResponseToJson(this);
}

NoticeCreateResponse _$NoticeCreateResponseFromJson(Map<String, dynamic> json) =>
    NoticeCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ?  Notice.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$NoticeCreateResponseToJson(NoticeCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };