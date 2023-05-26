/// isSuccess : true
/// vMessage : "Success"
/// data : [{"iStateId":"1","vStateName":"Gujarat","listDistrict":[{"iDistrictId":"1","iStateId":"1","vDistrictName":"Surat","listSubDistrict":[]},{"iDistrictId":"2","iStateId":"1","vDistrictName":"Amreli","listSubDistrict":[{"iSubDistrictId":"1","iDistrictId":"2","vSubDistrictName":"Kunkavav Vadia"}]}]}]
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class ConstantCityResponse {
  bool? isSuccess;
  String? vMessage;
  List<ConstantCityData>? data = [];

  ConstantCityResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory ConstantCityResponse.fromJson(dynamic json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

ConstantCityResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    ConstantCityResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? List<ConstantCityData>.from(
              json['data'].map((x) => ConstantCityData.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$LoginResponseToJson(ConstantCityResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

class ConstantCityData {
  String? iStateId;
  String? vStateName;
  List<ConstantDisData>? listDistrict = [];


  ConstantCityData({
    required this.iStateId,
    required this.vStateName,
    required this.listDistrict,

  });

  factory ConstantCityData.fromJson(dynamic json) =>
      _$ConstantCityDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConstantCityDataToJson(this);
}

ConstantCityData _$ConstantCityDataFromJson(Map<String, dynamic> json) =>
    ConstantCityData(
      iStateId: json['iStateId'],
      vStateName: json['vStateName'],
      listDistrict:
          json.containsKey('listDistrict') && json['listDistrict'] != null
              ? List<ConstantDisData>.from(
                  json['listDistrict'].map((x) => ConstantDisData.fromJson(x)))
              : [],

    );

Map<String, dynamic> _$ConstantCityDataToJson(ConstantCityData instance) =>
    <String, dynamic>{
      'iStateId': instance.iStateId,
      'vStateName': instance.vStateName,
      'listDistrict': instance.listDistrict,
    };

class ConstantDisData {
  String? iDistrictId;
  String? iStateId;
  String? vDistrictName;
  List<ConstantSubDisData>? listSubDistrict = [];

  ConstantDisData({
    required this.iDistrictId,
    required this.iStateId,
    required this.vDistrictName,
    required this.listSubDistrict,
  });

  factory ConstantDisData.fromJson(dynamic json) =>
      _$ConstantDisDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConstantDisDataToJson(this);
}

ConstantDisData _$ConstantDisDataFromJson(Map<String, dynamic> json) =>
    ConstantDisData(
      iDistrictId: json['iDistrictId'],
      iStateId: json['iStateId'],
      vDistrictName: json['vDistrictName'],
      listSubDistrict: json.containsKey('listSubDistrict') && json['listSubDistrict'] != null
          ? List<ConstantSubDisData>.from(
          json['listSubDistrict'].map((x) => ConstantSubDisData.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$ConstantDisDataToJson(ConstantDisData instance) =>
    <String, dynamic>{
      'iDistrictId': instance.iDistrictId,
      'iStateId': instance.iStateId,
      'vDistrictName': instance.vDistrictName!,
      'listSubDistrict': instance.listSubDistrict!,
    };

class ConstantSubDisData {
  String? iSubDistrictId;
  String? iDistrictId;
  String? vSubDistrictName;

  ConstantSubDisData({
    required this.iSubDistrictId,
    required this.iDistrictId,
    required this.vSubDistrictName,
  });

  factory ConstantSubDisData.fromJson(dynamic json) =>
      _$ConstantSubDisDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConstantSubDisDataToJson(this);
}

ConstantSubDisData _$ConstantSubDisDataFromJson(Map<String, dynamic> json) =>
    ConstantSubDisData(
      iSubDistrictId: json['iSubDistrictId'],
      iDistrictId: json['iDistrictId'],
      vSubDistrictName: json['vSubDistrictName'],
    );

Map<String, dynamic> _$ConstantSubDisDataToJson(ConstantSubDisData instance) =>
    <String, dynamic>{
      'iSubDistrictId': instance.iSubDistrictId,
      'iDistrictId': instance.iDistrictId,
      'vSubDistrictName': instance.vSubDistrictName!,
    };
