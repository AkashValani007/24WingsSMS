import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BalanceResponse {
  bool? isSuccess;
  String? vMessage;
  int? data;

  BalanceResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory BalanceResponse.fromJson(dynamic json) =>
      _$BalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceResponseToJson(this);
}

BalanceResponse _$BalanceResponseFromJson(Map<String, dynamic> json) =>
    BalanceResponse(
        isSuccess: json['isSuccess'],
        vMessage: json['vMessage'],
        data: typecast(json, 'data'));

Map<String, dynamic> _$BalanceResponseToJson(BalanceResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };
