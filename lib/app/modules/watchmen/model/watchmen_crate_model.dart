import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class WatchmenCreateResponse {
  bool? isSuccess;
  String? vMessage;
  WatchmenData? data;

  WatchmenCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory WatchmenCreateResponse.fromJson(dynamic json) =>
      _$WatchmenCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WatchmenCreateResponseToJson(this);
}

WatchmenCreateResponse _$WatchmenCreateResponseFromJson(
        Map<String, dynamic> json) =>
    WatchmenCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? WatchmenData.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$WatchmenCreateResponseToJson(
        WatchmenCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };
