import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LoginResponse {
  bool? isSuccess;
  String? vMessage;
  UserData? data;
  //List<UserData> data = [];


  LoginResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory LoginResponse.fromJson(dynamic json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? _$UserDataFromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data != null ? _$UserDataToJson(instance.data!) : null,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class UserData {
  int? iUserId;
  String? vUserName;
  String? vMobile;
  int? iGender;
  String? dtDOB;
  String? vEmail;
  String? vBusinessName;
  String? vBusinessAddress;
  int? iMobilePrivacy;
  int? iAddressPrivacy;
  String? token;
  List<WingData> wings = [];
  VillageData? village;
  List<VehicleData> vehicle = [];

  UserData({
    required this.vUserName,
    required this.vMobile,
    required this.iGender,
    required this.dtDOB,
    required this.vEmail,
    required this.iUserId,
    required this.vBusinessName,
    required this.vBusinessAddress,
    required this.token,
    required this.wings,
    required this.village,
    required this.iMobilePrivacy,
    required this.iAddressPrivacy,
    required this.vehicle,
  });

  factory UserData.fromJson(dynamic json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      vUserName: json['vUserName'],
      vMobile: json['vMobile'],
      iGender: typecast(json, 'iGender'),
      dtDOB: json['dtDOB'],
      vEmail: json['vEmail'],
      iUserId: typecast(json, 'iUserId'),
      vBusinessName: json['vBusinessName'],
      vBusinessAddress: json['vBusinessAddress'],
      token: json['token'],
      wings: json.containsKey('wings') && json['wings'] != null
          ? List<WingData>.from(json['wings'].map((x) => WingData.fromJson(x)))
          : [],
      village: json.containsKey('village') && json['village'] != null
          ? _$VillageDataFromJson(json['village'])
          : null,
      iMobilePrivacy: typecast(json, 'iMobilePrivacy'),
      iAddressPrivacy: typecast(json, 'iAddressPrivacy'),
      vehicle: json.containsKey('vehicle') && json['vehicle'] != null
          ? List<VehicleData>.from(
              json['vehicle'].map((x) => VehicleData.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'vUserName': instance.vUserName,
      'vMobile': instance.vMobile,
      'dtDOB': instance.dtDOB,
      'vEmail': instance.vEmail,
      'iUserId': instance.iUserId,
      'vBusinessName': instance.vBusinessName,
      'vBusinessAddress': instance.vBusinessAddress,
      'dtDOB': instance.dtDOB,
      'token': instance.token,
      'wings': instance.wings,
      'village': instance.village != null
          ? _$VillageDataToJson(instance.village!)
          : null,
      'iMobilePrivacy': instance.iMobilePrivacy,
      'iAddressPrivacy': instance.iAddressPrivacy,
      'vehicle': instance.vehicle,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class SocietyData {
  int? iSocietyId;
  int? iSocietyTypeId;
  String? vSocietyName;
  String? vSocietyAddress;
  int? iPincode;
  String? vCity;
  String? vLat;
  String? vLong;
  int? iBuilderId;
  int? iDeleted;

  SocietyData({
    required this.iSocietyId,
    required this.iSocietyTypeId,
    required this.vSocietyName,
    required this.vSocietyAddress,
    required this.iPincode,
    required this.vCity,
    required this.vLat,
    required this.vLong,
    required this.iBuilderId,
    required this.iDeleted,
  });

  factory SocietyData.fromJson(dynamic json) => _$SocietyDataFromJson(json);

  Map<String, dynamic> toJson() => _$SocietyDataToJson(this);
}

SocietyData _$SocietyDataFromJson(Map<String, dynamic> json) => SocietyData(
      iSocietyId: typecast(json, 'iSocietyId'),
      iSocietyTypeId: typecast(json, 'iSocietyTypeId'),
      vSocietyName: json['vSocietyName'],
      vSocietyAddress: json['vSocietyAddress'],
      iPincode: typecast(json, 'iPincode'),
      vCity: json['vCity'],
      vLat: json['vLat'],
      vLong: json['vLong'],
      iBuilderId: typecast(json, 'iBuilderId'),
      iDeleted: typecast(json, 'iDeleted'),
    );

Map<String, dynamic> _$SocietyDataToJson(SocietyData instance) =>
    <String, dynamic>{
      'iSocietyId': instance.iSocietyId,
      'iSocietyTypeId': instance.iSocietyTypeId,
      'vSocietyName': instance.vSocietyName,
      'vSocietyAddress': instance.vSocietyAddress,
      'iPincode': instance.iPincode,
      'vCity': instance.vCity,
      'vLat': instance.vLat,
      'vLong': instance.vLong,
      'iBuilderId': instance.iBuilderId,
      'iDeleted': instance.iDeleted,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class VehicleData {
  int? iSocietyWingId;
  String? vWingName;
  List<Vehicle> vehicleList = [];

  VehicleData({
    required this.iSocietyWingId,
    required this.vWingName,
    required this.vehicleList,
  });

  factory VehicleData.fromJson(dynamic json) => _$VehicleDataFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDataToJson(this);
}

VehicleData _$VehicleDataFromJson(Map<String, dynamic> json) => VehicleData(
      iSocietyWingId: typecast(json, 'iSocietyWingId'),
      vWingName: json['vWingName'],
      vehicleList:
          json.containsKey('vehicleList') && json['vehicleList'] != null
              ? List<Vehicle>.from(
                  json['vehicleList'].map((x) => Vehicle.fromJson(x)))
              : [],
    );

Map<String, dynamic> _$VehicleDataToJson(VehicleData instance) =>
    <String, dynamic>{
      'iSocietyWingId': instance.iSocietyWingId,
      'vWingName': instance.vWingName,
      'vehicleList': instance.vehicleList,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class Vehicle {
  int? iVehicleId;
  int? iOwnerUserId;
  int? iVehicleType;
  String? vVehicleNumber;
  String? vHouseNo;
  String? vOwnerName;
  String? vMobile;

  Vehicle({
    required this.iVehicleId,
    required this.iOwnerUserId,
    required this.iVehicleType,
    required this.vVehicleNumber,
    required this.vHouseNo,
    required this.vOwnerName,
    required this.vMobile,
  });

  factory Vehicle.fromJson(dynamic json) => _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      iVehicleId: typecast(json, 'iVehicleId'),
      iOwnerUserId: typecast(json, 'iOwnerUserId'),
      iVehicleType: typecast(json, 'iVehicleType'),
      vVehicleNumber: json['vVehicleNumber'],
      vHouseNo: json['vHouseNo'],
      vOwnerName: json['vOwnerName'],
      vMobile: json['vMobile'],
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'iVehicleId': instance.iVehicleId,
      'iOwnerUserId': instance.iOwnerUserId,
      'iVehicleType': instance.iVehicleType,
      'vVehicleNumber': instance.vVehicleNumber,
      'vHouseNo': instance.vHouseNo,
      'vOwnerName': instance.vOwnerName,
      'vMobile': instance.vMobile,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class VillageData {
  String? vVillageName;
  String? vSubDistrictName;
  String? vDistrictName;
  String? vStateName;

  VillageData({
    required this.vVillageName,
    required this.vSubDistrictName,
    required this.vDistrictName,
    required this.vStateName,
  });

  factory VillageData.fromJson(dynamic json) => _$VillageDataFromJson(json);

  Map<String, dynamic> toJson() => _$VillageDataToJson(this);
}

VillageData _$VillageDataFromJson(Map<String, dynamic> json) => VillageData(
      vVillageName: json['vVillageName'],
      vSubDistrictName: json['vSubDistrictName'],
      vDistrictName: json['vDistrictName'],
      vStateName: json['vStateName'],
    );

Map<String, dynamic> _$VillageDataToJson(VillageData instance) =>
    <String, dynamic>{
      'vVillageName': instance.vVillageName,
      'vSubDistrictName': instance.vSubDistrictName,
      'vDistrictName': instance.vDistrictName,
      'vStateName': instance.vStateName,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class WingData {
  int? iSocietyId;
  String? vSocietyName;
  String? vSocietyAddress;
  String? iPincode;
  String? vCity;
  String? vLat;
  String? vLong;
  int? iUserWingId;
  int? iSocietyWingId;
  String? vHouseNo;
  String? vWingName;
  int? iHouseId;
  int? iUserTypeId;
  int? isOwner;
  int? isCommitteeMember;
  List<HouseData> houseList = [];

  WingData({
    required this.iSocietyId,
    required this.vSocietyName,
    required this.vSocietyAddress,
    required this.iPincode,
    required this.vCity,
    required this.vLat,
    required this.vLong,
    required this.iUserWingId,
    required this.iSocietyWingId,
    required this.vHouseNo,
    required this.vWingName,
    required this.iHouseId,
    required this.iUserTypeId,
    required this.isOwner,
    required this.isCommitteeMember,
    required this.houseList,
  });

  factory WingData.fromJson(dynamic json) => _$WingDataFromJson(json);

  Map<String, dynamic> toJson() => _$WingDataToJson(this);
}

WingData _$WingDataFromJson(Map<String, dynamic> json) => WingData(
      iSocietyId: typecast(json, 'iSocietyId'),
      vSocietyName: json['vSocietyName'],
      vSocietyAddress: json['vSocietyAddress'],
      iPincode: json['iPincode'],
      vCity: json['vCity'],
      vLat: json['vLat'],
      vLong: json['vLong'],
      iUserWingId: typecast(json, 'iUserWingId'),
      iSocietyWingId: typecast(json, 'iSocietyWingId'),
      vHouseNo: json['vHouseNo'],
      vWingName: json['vWingName'],
      iHouseId: typecast(json, 'iHouseId'),
      iUserTypeId: typecast(json, 'iUserTypeId'),
      isOwner: typecast(json, 'isOwner'),
      isCommitteeMember: typecast(json, 'isCommitteeMember'),
      houseList: json.containsKey('houseList') && json['houseList'] != null
          ? List<HouseData>.from(
              json['houseList'].map((x) => HouseData.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$WingDataToJson(WingData instance) => <String, dynamic>{
      'iSocietyId': instance.iSocietyId,
      'vSocietyName': instance.vSocietyName,
      'vSocietyAddress': instance.vSocietyAddress,
      'iPincode': instance.iPincode,
      'vCity': instance.vCity,
      'vLat': instance.vLat,
      'vLong': instance.vLong,
      'iUserWingId': instance.iUserWingId,
      'iSocietyWingId': instance.iSocietyWingId,
      'vHouseNo': instance.vHouseNo,
      'vWingName': instance.vWingName,
      'iHouseId': instance.iHouseId,
      'iUserTypeId': instance.iUserTypeId,
      'isOwner': instance.isOwner,
      'isCommitteeMember': instance.isCommitteeMember,
      'houseList': instance.houseList,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class HouseData {
  int? iHouseId;
  int? iSocietyWingId;
  String? vHouseNo;

  HouseData({
    required this.iHouseId,
    required this.iSocietyWingId,
    required this.vHouseNo,
  });

  factory HouseData.fromJson(dynamic json) => _$HouseDataFromJson(json);

  Map<String, dynamic> toJson() => _$HouseDataToJson(this);
}

HouseData _$HouseDataFromJson(Map<String, dynamic> json) => HouseData(
      iHouseId: typecast(json, 'iHouseId'),
      iSocietyWingId: typecast(json, 'iSocietyWingId'),
      vHouseNo: json['vHouseNo'],
    );

Map<String, dynamic> _$HouseDataToJson(HouseData instance) => <String, dynamic>{
      'iHouseId': instance.iHouseId,
      'iSocietyWingId': instance.iSocietyWingId,
      'vHouseNo': instance.vHouseNo,
    };
