import 'package:json_annotation/json_annotation.dart';

import '../../../constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BookingResponse {
  bool? isSuccess;
  String? vMessage;
  List<HallBooking>? data = [];

  BookingResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory BookingResponse.fromJson(dynamic json) => _$BookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingResponseToJson(this);
}

BookingResponse _$BookingResponseFromJson(Map<String, dynamic> json) => BookingResponse(
  isSuccess: json['isSuccess'],
  vMessage: json['vMessage'],
  data: json.containsKey('data') && json['data'] != null
      ? List<HallBooking>.from(json['data'].map((x) => HallBooking.fromJson(x)))
      : [],
);

Map<String, dynamic> _$BookingResponseToJson(BookingResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class HallBooking {
  int? iBookingId;
  String? dtBooking;
  int? iUserId;
  String? vUserName;
  String? vMobile;
  String? vAltMobile;
  String? vAddress;
  String? vBookingType;
  String? iAdvance;
  String? iRent;
  String? iStatus;

  HallBooking({
    required this.iBookingId,
    required this.dtBooking,
    required this.iUserId,
    required this.vUserName,
    required this.vMobile,
    required this.vAltMobile,
    required this.vAddress,
    required this.vBookingType,
    required this.iAdvance,
    required this.iRent,
    required this.iStatus,
  });

  factory HallBooking.fromJson(dynamic json) => _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}

HallBooking _$BookingFromJson(Map<String, dynamic> json) => HallBooking(
  iBookingId: typecast(json, 'iBookingId'),
  dtBooking: json['dtBooking'],
  iUserId: typecast(json,'iUserId'),
  vUserName: json['vUserName'],
  vMobile: json['vMobile'],
  vAltMobile: json['vAltMobile'],
  vAddress: json['vAddress'],
  vBookingType: json['vBookingType'],
  iAdvance: json['iAdvance'],
  iRent: json['iRent'],
  iStatus: json['iStatus'],
);

Map<String, dynamic> _$BookingToJson(HallBooking instance) => <String, dynamic>{
  'iBookingId': instance.iBookingId,
  'dtBooking': instance.dtBooking,
  'iUserId': instance.iUserId,
  'vUserName': instance.vUserName,
  'vMobile': instance.vMobile,
  'vAltMobile': instance.vAltMobile,
  'vAddress': instance.vAddress,
  'vBookingType': instance.vBookingType,
  'iAdvance': instance.iAdvance,
  'iRent': instance.iRent,
  'iStatus': instance.iStatus,
};