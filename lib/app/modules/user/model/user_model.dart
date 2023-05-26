import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import '../../../constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserResponse {
  bool? isSuccess;
  String? vMessage;
  List<User>? data = [];

  UserResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory UserResponse.fromJson(dynamic json) => _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? List<User>.from(json['data'].map((x) => User.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

@JsonSerializable(fieldRename: FieldRename.none)
  @Entity(tableName: 'user')
class User {
  @primaryKey
  int? iUserId;
  String? vUserName;
  String? vMobile;
  String? vEmail;
  int? vHouseNo;
  String? vBusinessName;
  String? vBusinessAddress;
  int? iMobilePrivacy;
  int? iAddressPrivacy;
  int? iSocietyWingId;
  VillageData? village;

  User({
    required this.vUserName,
    required this.vMobile,
    required this.vEmail,
    required this.vHouseNo,
    required this.iUserId,
    required this.vBusinessName,
    required this.vBusinessAddress,
    required this.village,
    required this.iMobilePrivacy,
    required this.iAddressPrivacy,
    required this.iSocietyWingId,
  });

  factory User.fromJson(dynamic json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

User _$UserFromJson(Map<String, dynamic> json) => User(
      iUserId: typecast(json, 'iUserId'),
      vUserName: json['vUserName'],
      vMobile: json['vMobile'],
      vEmail: json['vEmail'],
      vHouseNo: typecast(json, 'vHouseNo'),
      vBusinessName: json['vBusinessName'],
      vBusinessAddress: json['vBusinessAddress'],
      village: json.containsKey('village') && json['village'] != null
          ? _$VillageDataFromJson(json['village'])
          : null,
      iMobilePrivacy: typecast(json, 'iMobilePrivacy'),
      iAddressPrivacy: typecast(json, 'iAddressPrivacy'),
      iSocietyWingId: typecast(json, 'iSocietyWingId'),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'vUserName': instance.vUserName,
      'vMobile': instance.vMobile,
      'vEmail': instance.vEmail,
      'vHouseNo': instance.vHouseNo,
      'iUserId': instance.iUserId,
      'vBusinessName': instance.vBusinessName,
      'vBusinessAddress': instance.vBusinessAddress,
      'village': instance.village != null
          ? _$VillageDataToJson(instance.village!)
          : null,
      'iMobilePrivacy': instance.iMobilePrivacy,
      'iAddressPrivacy': instance.iAddressPrivacy,
      'iSocietyWingId': instance.iSocietyWingId,
    };

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
