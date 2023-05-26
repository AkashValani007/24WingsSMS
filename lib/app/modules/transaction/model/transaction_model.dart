import 'package:json_annotation/json_annotation.dart';
import 'package:maintaince/app/constant/common.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class TransactionResponse {
  bool? isSuccess;
  String? vMessage;
  List<TransactionData>? data = [];

  TransactionResponse({
    required this.isSuccess,
    required this.vMessage,
    required this.data,
  });

  factory TransactionResponse.fromJson(dynamic json) => _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      isSuccess: json['isSuccess'],
      vMessage: json['vMessage'],
      data: json.containsKey('data') && json['data'] != null
          ? List<TransactionData>.from(
              json['data'].map((x) => TransactionData.fromJson(x)))
          : [],
    );

Map<String, dynamic> _$TransactionResponseToJson(TransactionResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'vMessage': instance.vMessage,
      'data': instance.data,
    };

class TransactionData {
  int? iTransactionId;
  int? iUserId;
  int? iSocietyWingId;
  int? iTransactionType;
  String? vPaymentType;
  int? iAmount;
  String? dPaymentDate;
  String? dtCreated;
  String? vPaymentDetails;
  String? vTransactionDetails;
  int? iAddId;
  String? vHouseNo;
  String? vUserName;
  int? iDeleted;

  TransactionData({
    required this.iTransactionId,
    required this.iUserId,
    required this.iSocietyWingId,
    required this.iTransactionType,
    required this.vPaymentType,
    required this.iAmount,
    required this.dPaymentDate,
    required this.dtCreated,
    required this.vPaymentDetails,
    required this.vTransactionDetails,
    required this.iAddId,
    required this.vHouseNo,
    required this.vUserName,
    required this.iDeleted,
  });

  factory TransactionData.fromJson(dynamic json) => _$TransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData(
      iTransactionId: typecast(json, 'iTransactionId'),
      iUserId: typecast(json, 'iUserId'),
      iSocietyWingId: typecast(json, 'iSocietyWingId'),
      iTransactionType: typecast(json, 'iTransactionType'),
      vPaymentType: json['vPaymentType'],
      iAmount: typecast(json, 'iAmount'),
      dPaymentDate: json['dPaymentDate'],
      dtCreated: json['dtCreated'],
      vPaymentDetails: json['vPaymentDetails'],
      vTransactionDetails: json['vTransactionDetails'],
      iAddId: typecast(json, 'iAddId'),
      vHouseNo: json['vHouseNo'],
      vUserName: json['vUserName'],
      iDeleted: typecast(json, 'iDeleted'),
    );

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'iTransactionId': instance.iTransactionId,
      'iUserId': instance.iUserId,
      'iSocietyWingId': instance.iSocietyWingId,
      'iTransactionType': instance.iTransactionType,
      'vPaymentType': instance.vPaymentType,
      'iAmount': instance.iAmount,
      'dPaymentDate': instance.dPaymentDate,
      'dtCreated': instance.dtCreated,
      'vPaymentDetails': instance.vPaymentDetails,
      'vTransactionDetails': instance.vTransactionDetails,
      'iAddId': instance.iAddId,
      'vHouseNo': instance.vHouseNo,
      'vUserName': instance.vUserName,
      'iDeleted': instance.iDeleted,
    };
