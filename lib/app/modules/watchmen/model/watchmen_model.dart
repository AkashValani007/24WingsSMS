import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class WatchmenResponse {
  bool? isSuccess;
  String? vMessage;
  List<WatchmenData>? data = [];

  WatchmenResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory WatchmenResponse.fromJson(dynamic json) =>
      _$WatchmenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WatchmenResponseToJson(this);
}

WatchmenResponse _$WatchmenResponseFromJson(Map<String, dynamic> json) =>
    WatchmenResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? List<WatchmenData>.from(
              json['data'].map((x) => WatchmenData.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$WatchmenResponseToJson(WatchmenResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class WatchmenData {
  int? iWatchmenId;
  String? vWatchmenName;
  String? vWatchmenNumber;
  String? vWatchmenAddress;
  int? vWatchmenType;
  int? iDeleted;
  int? iSocietyWingId;
  int? iOnDuty;

  WatchmenData({
    required this.iWatchmenId,
    required this.vWatchmenName,
    required this.vWatchmenNumber,
    required this.vWatchmenAddress,
    required this.vWatchmenType,
    required this.iDeleted,
    required this.iSocietyWingId,
    required this.iOnDuty,
  });

  factory WatchmenData.fromJson(dynamic json) => _$WatchmenDataFromJson(json);

  Map<String, dynamic> toJson() => _$WatchmenDataToJson(this);
}

WatchmenData _$WatchmenDataFromJson(Map<String, dynamic> json) => WatchmenData(
      iWatchmenId: typecast(json, 'iWatchmenId'),
      vWatchmenName: json['vWatchmenName'],
      vWatchmenNumber: json['vWatchmenNumber'],
      vWatchmenAddress: json['vWatchmenAddress'],
      vWatchmenType: typecast(json, 'vWatchmenType'),
      iDeleted: typecast(json, 'iDeleted'),
      iSocietyWingId: typecast(json, 'iSocietyWingId'),
      iOnDuty: typecast(json, 'iOnDuty'),
    );

Map<String, dynamic> _$WatchmenDataToJson(WatchmenData instance) =>
    <String, dynamic>{
      'iWatchmenId': instance.iWatchmenId,
      'vWatchmenName': instance.vWatchmenName,
      'vWatchmenNumber': instance.vWatchmenNumber,
      'vWatchmenAddress': instance.vWatchmenAddress,
      'vWatchmenType': instance.vWatchmenType,
      'iDeleted': instance.iDeleted,
      'iSocietyWingId': instance.iSocietyWingId,
      'iOnDuty': instance.iOnDuty,
    };
