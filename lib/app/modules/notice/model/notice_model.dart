import 'package:json_annotation/json_annotation.dart';
import '../../../constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class NoticeResponse {
  bool? isSuccess;
  String? vMessage;
  List<Notice>? data = [];

  NoticeResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory NoticeResponse.fromJson(dynamic json) => _$NoticeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeResponseToJson(this);
}

NoticeResponse _$NoticeResponseFromJson(Map<String, dynamic> json) => NoticeResponse(
  isSuccess: json['isSuccess'],
  vMessage: json['vMessage'],
  data: json.containsKey('data') && json['data'] != null
      ? List<Notice>.from(json['data'].map((x) => Notice.fromJson(x)))
      : [],
);

Map<String, dynamic> _$NoticeResponseToJson(NoticeResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class Notice {
  int? iNoticeId;
  int? iSocietyWingId;
  String? vNoticeDetail;
  int? iUserId;
  String? dCreatedDate;
  int? isActive;

  Notice({
    required this.iNoticeId,
    required this.iSocietyWingId,
    required this.vNoticeDetail,
    required this.iUserId,
    required this.dCreatedDate,
    required this.isActive,
  });

  factory Notice.fromJson(dynamic json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

Notice _$UserFromJson(Map<String, dynamic> json) => Notice(
  iNoticeId: typecast(json,'iNoticeId'),
  iSocietyWingId: typecast(json,'iSocietyWingId'),//1
  vNoticeDetail: json['vNoticeDetail'],
  iUserId: typecast(json,'iUserId'),//2
  dCreatedDate: json['dCreatedDate'],
  isActive: typecast(json,'isActive'),
);

Map<String, dynamic> _$UserToJson(Notice instance) => <String, dynamic>{
  'iNoticeId': instance.iNoticeId,
  'iSocietyWingId': instance.iSocietyWingId,
  'vNoticeDetail': instance.vNoticeDetail,
  'iUserId': instance.iUserId,
  'dCreatedDate': instance.dCreatedDate,
  'isActive': instance.isActive,

};