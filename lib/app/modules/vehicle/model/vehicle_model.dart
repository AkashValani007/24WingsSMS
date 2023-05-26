import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class VehicleResponse {
  bool? isSuccess;
  String? vMessage;
  List<Vehicle>? data = [];

  VehicleResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory VehicleResponse.fromJson(dynamic json) => _$WatchmenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WatchmenResponseToJson(this);
}

VehicleResponse _$WatchmenResponseFromJson(Map<String, dynamic> json) =>
    VehicleResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? List<Vehicle>.from(
              json['data'].map((x) => Vehicle.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$WatchmenResponseToJson(VehicleResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };
