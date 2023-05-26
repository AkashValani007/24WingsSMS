import 'package:json_annotation/json_annotation.dart';

import 'assets_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class AssetsCreateResponse {
  bool? isSuccess;
  String? vMessage;
  AssetModel? data;

  AssetsCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory AssetsCreateResponse.fromJson(dynamic json) =>
      _$AssetsCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsCreateResponseToJson(this);
}

AssetsCreateResponse _$AssetsCreateResponseFromJson(Map<String, dynamic> json) =>
    AssetsCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ?  AssetModel.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$AssetsCreateResponseToJson(AssetsCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };