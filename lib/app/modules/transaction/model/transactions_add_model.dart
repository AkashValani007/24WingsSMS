import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_model.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class TransactionsAddResponse {
  bool? isSuccess;
  String? vMessage;
  List<TransactionData>? data = [];

  TransactionsAddResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory TransactionsAddResponse.fromJson(dynamic json) =>
      _$TransactionsAddResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsAddResponseToJson(this);
}

TransactionsAddResponse _$TransactionsAddResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionsAddResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? List<TransactionData>.from(
          json['data'].map((x) => TransactionData.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$TransactionsAddResponseToJson(
    TransactionsAddResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };
