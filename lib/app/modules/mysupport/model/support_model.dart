import 'package:json_annotation/json_annotation.dart';

import '../../../constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class SupportResponse {
  bool? isSuccess;
  String? vMessage;
  List<MySupport>? data = [];

  SupportResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory SupportResponse.fromJson(dynamic json) => _$SupportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportResponseToJson(this);
}

SupportResponse _$SupportResponseFromJson(Map<String, dynamic> json) => SupportResponse(
  isSuccess: json['isSuccess'],
  vMessage: json['vMessage'],
  data: json.containsKey('data') && json['data'] != null
      ? List<MySupport>.from(json['data'].map((x) => MySupport.fromJson(x)))
      : [],
);

Map<String, dynamic> _$SupportResponseToJson(SupportResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class MySupport {
  int? iSupportId;
  String? vSupportDetails;
  int? iStatus;
  String? dtCreated;

  MySupport({
    required this.iSupportId,
    required this.vSupportDetails,
    required this.iStatus,
    required this.dtCreated,
  });

  factory MySupport.fromJson(dynamic json) => _$SupportFromJson(json);

  Map<String, dynamic> toJson() => _$SupportToJson(this);
}

MySupport _$SupportFromJson(Map<String, dynamic> json) => MySupport(
  iSupportId: typecast(json, 'iSupportId'),
  vSupportDetails: json['vSupportDetails'],
  iStatus: typecast(json,'iStatus'),
  dtCreated: json['dtCreated'],
);

Map<String, dynamic> _$SupportToJson(MySupport instance) => <String, dynamic>{
  'iSupportId': instance.iSupportId,
  'vSupportDetails': instance.vSupportDetails,
  'iStatus': instance.iStatus,
  'dtCreated': instance.dtCreated,
};