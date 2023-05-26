import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/Hallbooking/model/booking_model.dart';


@JsonSerializable(fieldRename: FieldRename.none)
class BookingCreateResponse {
  bool? isSuccess;
  String? vMessage;
  HallBooking? data;

  BookingCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory BookingCreateResponse.fromJson(dynamic json) =>
      _$BookingCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingCreateResponseToJson(this);
}

BookingCreateResponse _$BookingCreateResponseFromJson(Map<String, dynamic> json) =>
    BookingCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ?  HallBooking.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$BookingCreateResponseToJson(BookingCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };