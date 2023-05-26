import 'package:json_annotation/json_annotation.dart';

import '../../../constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BookablePropertyResponse {
  bool? isSuccess;
  String? vMessage;
  List<BookableProperty>? data = [];

  BookablePropertyResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory BookablePropertyResponse.fromJson(dynamic json) => _$BookablePropertyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookablePropertyResponseToJson(this);
}

BookablePropertyResponse _$BookablePropertyResponseFromJson(Map<String, dynamic> json) => BookablePropertyResponse(
  isSuccess: json['isSuccess'],
  vMessage: json['vMessage'],
  data: json.containsKey('data') && json['data'] != null
      ? List<BookableProperty>.from(json['data'].map((x) => BookableProperty.fromJson(x)))
      : [],
);

Map<String, dynamic> _$BookablePropertyResponseToJson(BookablePropertyResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

@JsonSerializable(fieldRename: FieldRename.none)
class BookableProperty {
  int? iSBookablePropertyId;
  String? vPropertyName;

  BookableProperty({
    required this.iSBookablePropertyId,
    required this.vPropertyName,
  });

  factory BookableProperty.fromJson(dynamic json) => _$BookablePropertyFromJson(json);

  Map<String, dynamic> toJson() => _$BookablePropertyToJson(this);
}

BookableProperty _$BookablePropertyFromJson(Map<String, dynamic> json) => BookableProperty(
  iSBookablePropertyId: typecast(json, 'iSBookablePropertyId'),
  vPropertyName: json['vPropertyName'],
);

Map<String, dynamic> _$BookablePropertyToJson(BookableProperty instance) => <String, dynamic>{
  'iSBookablePropertyId': instance.iSBookablePropertyId,
  'vPropertyName': instance.vPropertyName,
};