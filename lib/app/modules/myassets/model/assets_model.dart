import 'package:json_annotation/json_annotation.dart';

import '../../../constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class AssetsResponse {
  bool? isSuccess;
  String? vMessage;
  List<AssetModel>? data = [];

  AssetsResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory AssetsResponse.fromJson(dynamic json) => _$AssetsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsResponseToJson(this);
}

AssetsResponse _$AssetsResponseFromJson(Map<String, dynamic> json) => AssetsResponse(
  isSuccess: json['isSuccess'],
  vMessage: json['vMessage'],
  data: json.containsKey('data') && json['data'] != null
      ? List<AssetModel>.from(json['data'].map((x) => AssetModel.fromJson(x)))
      : [],
);

Map<String, dynamic> _$AssetsResponseToJson(AssetsResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class AssetModel {
  int? iAssetsId;
  int? iSocietyWingId;
  int? iUserId;
  String? vAssetName;
  String? iQty;

  AssetModel({
    required this.iAssetsId,
    required this.iSocietyWingId,
    required this.vAssetName,
    required this.iUserId,
    required this.iQty,
  });

  factory AssetModel.fromJson(dynamic json) => _$AssetsFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsToJson(this);
}

AssetModel _$AssetsFromJson(Map<String, dynamic> json) => AssetModel(
  iAssetsId: typecast(json,'iAssetsId'),
  iSocietyWingId: typecast(json,'iSocietyWingId'),
  iUserId: typecast(json,'iUserId'),
  vAssetName: json['vAssetName'],
  iQty: json['iQty'],
);

Map<String, dynamic> _$AssetsToJson(AssetModel instance) => <String, dynamic>{
  'iAssetsId': instance.iAssetsId,
  'iSocietyWingId': instance.iSocietyWingId,
  'iUserId': instance.iUserId,
  'vAssetName': instance.vAssetName,
  'iQty': instance.iQty,
};