// ignore_for_file: camel_case_types

import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class ConstantResponse {
  bool? isSuccess;
  String? vMessage;
  ConstantData? data;

  ConstantResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory ConstantResponse.fromJson(dynamic json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

ConstantResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    ConstantResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? _$ConstantDataFromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$LoginResponseToJson(ConstantResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data':
          instance.data != null ? _$ConstantDataToJson(instance.data!) : null,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class ConstantData {
  List<UserTypeData>? tblUserTypeMaster = [];
  List<SocietyTypeData>? tblSocietyTypeMaster = [];
  List<VehicleTypeData>? tblVehicleTypeMaster = [];
  List<AdsData>? tblAds = [];
  List<BookingType>? tblBookingType = [];
  List<String>? creditType = [];
  List<String>? debitType = [];
  List<String>? amountType = [];
  List<String>? creditType_gj = [];
  List<String>? debitType_gj = [];
  List<String>? amountType_gj = [];
  List<String>? creditType_hi = [];
  List<String>? debitType_hi = [];
  List<String>? amountType_hi = [];




  bool? isPurchase;
  int? totalDays;
  int? remainDays;

  ConstantData({
    required this.tblUserTypeMaster,
    required this.tblSocietyTypeMaster,
    required this.tblVehicleTypeMaster,
    required this.tblAds,
    required this.tblBookingType,
    required this.creditType,
    required this.debitType,
    required this.amountType,
    required this.creditType_gj,
    required this.debitType_gj,
    required this.amountType_gj,
    required this.creditType_hi,
    required this.debitType_hi,
    required this.amountType_hi,
    required this.isPurchase,
    required this.totalDays,
    required this.remainDays,
  });

  factory ConstantData.fromJson(dynamic json) => _$ConstantDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConstantDataToJson(this);
}

ConstantData _$ConstantDataFromJson(Map<String, dynamic> json) => ConstantData(
      tblUserTypeMaster: json.containsKey('tblUserTypeMaster') &&
              json['tblUserTypeMaster'] != null
          ? List<UserTypeData>.from(
              json['tblUserTypeMaster'].map((x) => UserTypeData.fromJson(x)))
          : [],
      tblSocietyTypeMaster: json.containsKey('tblSocietyTypeMaster') &&
              json['tblSocietyTypeMaster'] != null
          ? List<SocietyTypeData>.from(json['tblSocietyTypeMaster']
              .map((x) => SocietyTypeData.fromJson(x)))
          : [],
      tblVehicleTypeMaster: json.containsKey('tblVehicleTypeMaster') &&
              json['tblVehicleTypeMaster'] != null
          ? List<VehicleTypeData>.from(json['tblVehicleTypeMaster']
              .map((x) => VehicleTypeData.fromJson(x)))
          : [],
      tblAds: json.containsKey('tblAds') && json['tblAds'] != null
          ? List<AdsData>.from(json['tblAds'].map((x) => AdsData.fromJson(x)))
          : [],
      tblBookingType:
          json.containsKey('tblBookingType') && json['tblBookingType'] != null
              ? List<BookingType>.from(
                  json['tblBookingType'].map((x) => BookingType.fromJson(x)))
              : [],
      creditType: json.containsKey('creditType') && json['creditType'] != null
          ? List<String>.from(json['creditType'].map((x) => x))
          : [],
      debitType: json.containsKey('debitType') && json['debitType'] != null
          ? List<String>.from(json['debitType'].map((x) => x))
          : [],
      amountType: json.containsKey('amountType') && json['amountType'] != null
          ? List<String>.from(json['amountType'].map((x) => x))
          : [],

      creditType_gj: json.containsKey('creditType_gj') && json['creditType_gj'] != null
              ? List<String>.from(json['creditType_gj'].map((x) => x))
              : [],
      debitType_gj: json.containsKey('debitType_gj') && json['debitType_gj'] != null
              ? List<String>.from(json['debitType_gj'].map((x) => x))
              : [],
      amountType_gj: json.containsKey('amountType_gj') && json['amountType_gj'] != null
              ? List<String>.from(json['amountType_gj'].map((x) => x))
              : [],

      creditType_hi: json.containsKey('creditType_hi') && json['creditType_hi'] != null
          ? List<String>.from(json['creditType_hi'].map((x) => x))
          : [],
      debitType_hi: json.containsKey('debitType_hi') && json['debitType_hi'] != null
          ? List<String>.from(json['debitType_hi'].map((x) => x))
          : [],
      amountType_hi: json.containsKey('amountType_hi') && json['amountType_hi'] != null
          ? List<String>.from(json['amountType_hi'].map((x) => x))
          : [],


      isPurchase: json['isPurchase'],
      totalDays: typecast(json, 'totalDays'),
      remainDays: typecast(json, 'remainDays'),
    );

Map<String, dynamic> _$ConstantDataToJson(ConstantData instance) =>
    <String, dynamic>{
      'tblUserTypeMaster': instance.tblUserTypeMaster,
      'tblSocietyTypeMaster': instance.tblSocietyTypeMaster,
      'tblVehicleTypeMaster': instance.tblVehicleTypeMaster,
      'tblAds': instance.tblAds,
      'tblBookingType': instance.tblBookingType,
      'creditType': instance.creditType,
      'debitType': instance.debitType,
      'amountType': instance.amountType,
      'creditType_gj': instance.creditType_gj,
      'debitType_gj': instance.debitType_gj,
      'amountType_gj': instance.amountType_gj,
      'creditType_hi': instance.creditType_hi,
      'debitType_hi': instance.debitType_hi,
      'amountType_hi': instance.amountType_hi,
      'isPurchase': instance.isPurchase,
      'totalDays': instance.totalDays,
      'remainDays': instance.remainDays,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class UserTypeData {
  int? iUserTypeId;
  String? vUserTypeName;
  String? vUserTypeName_gj;
  String? vUserTypeName_hi;

  UserTypeData({
    required this.iUserTypeId,
    required this.vUserTypeName,
    required this.vUserTypeName_gj,
    required this.vUserTypeName_hi,
  });

  factory UserTypeData.fromJson(dynamic json) => _$UserTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserTypeDataToJson(this);
}

UserTypeData _$UserTypeDataFromJson(Map<String, dynamic> json) => UserTypeData(
      iUserTypeId: typecast(json, 'iUserTypeId'),
      vUserTypeName: json['vUserTypeName'],
      vUserTypeName_gj: json['vUserTypeName_gj'],
      vUserTypeName_hi: json['vUserTypeName_hi'],
    );

Map<String, dynamic> _$UserTypeDataToJson(UserTypeData instance) =>
    <String, dynamic>{
      'iUserTypeId': instance.iUserTypeId,
      'vUserTypeName': instance.vUserTypeName,
      'vUserTypeName_gj': instance.vUserTypeName_gj,
      'vUserTypeName_hi': instance.vUserTypeName_hi,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class SocietyTypeData {
  int? iSocietyTypeId;
  String? vSocietyType;

  SocietyTypeData({
    required this.iSocietyTypeId,
    required this.vSocietyType,
  });

  factory SocietyTypeData.fromJson(dynamic json) =>
      _$SocietyTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$SocietyTypeDataToJson(this);
}

SocietyTypeData _$SocietyTypeDataFromJson(Map<String, dynamic> json) =>
    SocietyTypeData(
      iSocietyTypeId: typecast(json, 'iSocietyTypeId'),
      vSocietyType: json['vSocietyType'],
    );

Map<String, dynamic> _$SocietyTypeDataToJson(SocietyTypeData instance) =>
    <String, dynamic>{
      'iSocietyTypeId': instance.iSocietyTypeId,
      'vSocietyType': instance.vSocietyType,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class VehicleTypeData {
  int? iVehicleType;
  String? vVehicleName;
  String? vVehicleName_gj;
  String? vVehicleName_hi;

  VehicleTypeData({
    required this.iVehicleType,
    required this.vVehicleName,
    required this.vVehicleName_gj,
    required this.vVehicleName_hi,
  });

  factory VehicleTypeData.fromJson(dynamic json) =>
      _$VehicleTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleTypeDataToJson(this);
}

VehicleTypeData _$VehicleTypeDataFromJson(Map<String, dynamic> json) =>
    VehicleTypeData(
      iVehicleType: typecast(json, 'iVehicleType'),
      vVehicleName: json['vVehicleName'],
      vVehicleName_gj: json['vVehicleName_gj'],
      vVehicleName_hi: json['vVehicleName_hi'],
    );

Map<String, dynamic> _$VehicleTypeDataToJson(VehicleTypeData instance) =>
    <String, dynamic>{
      'iVehicleType': instance.iVehicleType,
      'vVehicleName': instance.vVehicleName,
      'vVehicleName_gj': instance.vVehicleName_gj,
      'vVehicleName_hi': instance.vVehicleName_hi,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class AdsData {
  int? iAdId;
  String? vAdName;
  String? vAdLink;
  String? vAdImageUrl;

  AdsData({
    required this.iAdId,
    required this.vAdName,
    required this.vAdLink,
    required this.vAdImageUrl,
  });

  factory AdsData.fromJson(dynamic json) => _$AdsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AdsDataToJson(this);
}

AdsData _$AdsDataFromJson(Map<String, dynamic> json) => AdsData(
      iAdId: typecast(json, 'iAdId'),
      vAdName: json['vAdName'],
      vAdLink: json['vAdLink'],
      vAdImageUrl: json['vAdImageUrl'],
    );

Map<String, dynamic> _$AdsDataToJson(AdsData instance) => <String, dynamic>{
      'iAdId': instance.iAdId,
      'vAdName': instance.vAdName,
      'vAdLink': instance.vAdLink,
      'vAdImageUrl': instance.vAdImageUrl,
    };

class BookingType {
  BookingType({
    String? iBookingTypeId,
    String? vBookingType,
    String? vBookingType_gj,
    String? vBookingType_hi,
  }) {
    iBookingTypeId = iBookingTypeId;
    _vBookingType = vBookingType;
    _vBookingType_gj = vBookingType_gj;
    _vBookingType_hi = vBookingType_hi;
  }

  BookingType.fromJson(dynamic json) {
    _iBookingTypeId = json['iBookingTypeId'];
    _vBookingType = json['vBookingType'];
    _vBookingType_gj = json['vBookingType_gj'];
    _vBookingType_hi = json['vBookingType_hi'];
  }

  String? _iBookingTypeId;
  String? _vBookingType;
  String? _vBookingType_gj;
  String? _vBookingType_hi;

  BookingType copyWith({
    String? iBookingTypeId,
    String? vBookingType,
    String? vBookingType_gj,
    String? vBookingType_hi,
  }) =>
      BookingType(
        iBookingTypeId: iBookingTypeId ?? iBookingTypeId,
        vBookingType: vBookingType ?? _vBookingType,
        vBookingType_gj: vBookingType_gj ?? _vBookingType_gj,
        vBookingType_hi: vBookingType_hi ?? _vBookingType_hi,
      );

  String? get iBookingTypeId => _iBookingTypeId;

  String? get vBookingType => _vBookingType;

  String? get vBookingType_gj => _vBookingType_gj;

  String? get vBookingType_hi => _vBookingType_hi;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['iBookingTypeId'] = _iBookingTypeId;
    map['vBookingType'] = _vBookingType;
    map['vBookingType_gj'] = _vBookingType_gj;
    map['vBookingType_hi'] = _vBookingType_hi;
    return map;
  }
}

@JsonSerializable(fieldRename: FieldRename.none)
class listDistrict {
  int? iDistrictId;
  int? iStateId;
  String? vDistrictName;

  listDistrict({
    required this.iDistrictId,
    required this.iStateId,
    required this.vDistrictName,
  });

  factory listDistrict.fromJson(dynamic json) => _$listDistrictFromJson(json);

  Map<String, dynamic> toJson() => _$listDistrictToJson(this);
}

listDistrict _$listDistrictFromJson(Map<String, dynamic> json) => listDistrict(
      iDistrictId: typecast(json, 'iDistrictId'),
      iStateId: json['iStateId'],
      vDistrictName: json['vDistrictName'],
    );

Map<String, dynamic> _$listDistrictToJson(listDistrict instance) =>
    <String, dynamic>{
      'iDistrictId': instance.iDistrictId,
      'iStateId': instance.iStateId,
      'vDistrictName': instance.vDistrictName,
    };
