import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class VehicleCreateResponse {
  bool? isSuccess;
  String? vMessage;
  Vehicle? data;

  VehicleCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory VehicleCreateResponse.fromJson(dynamic json) =>
      _$VehicleCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleCreateResponseToJson(this);
}

VehicleCreateResponse _$VehicleCreateResponseFromJson(
        Map<String, dynamic> json) =>
    VehicleCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? Vehicle.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$VehicleCreateResponseToJson(
        VehicleCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };
