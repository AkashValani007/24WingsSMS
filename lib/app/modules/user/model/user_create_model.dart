import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserCreateResponse {
  bool? isSuccess;
  String? vMessage;
  UserData? data;

  UserCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory UserCreateResponse.fromJson(dynamic json) =>
      _$UserCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreateResponseToJson(this);
}

UserCreateResponse _$UserCreateResponseFromJson(Map<String, dynamic> json) =>
    UserCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ?  UserData.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$UserCreateResponseToJson(UserCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };