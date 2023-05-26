import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class TransactionCreateResponse {
  bool? isSuccess;
  String? vMessage;
  TransactionData? data;

  TransactionCreateResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory TransactionCreateResponse.fromJson(dynamic json) =>
      _$TransactionCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionCreateResponseToJson(this);
}

TransactionCreateResponse _$TransactionCreateResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionCreateResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? TransactionData.fromJson(json['data'])
          : null,
    );

Map<String, dynamic> _$TransactionCreateResponseToJson(
        TransactionCreateResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };
