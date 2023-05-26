import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/addbookableproperty/model/bookable_property_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BookablePropertyCreateResponse {
  bool? isSuccess;
  String? vMessage;
  BookableProperty? data;

  BookablePropertyCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory BookablePropertyCreateResponse.fromJson(dynamic json) =>
      _$BookablePropertyCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookablePropertyCreateResponseToJson(this);
}

BookablePropertyCreateResponse _$BookablePropertyCreateResponseFromJson(Map<String, dynamic> json) =>
    BookablePropertyCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ?  BookableProperty.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$BookablePropertyCreateResponseToJson(BookablePropertyCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      // 'data': instance.data,
    };