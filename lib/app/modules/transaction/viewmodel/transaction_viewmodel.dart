import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintaince/app/modules/login/model/login_model.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_create_model.dart';
import 'package:maintaince/app/modules/transaction/model/transaction_model.dart';
import 'package:maintaince/app/modules/transaction/model/transactions_add_model.dart';
import 'package:maintaince/app/modules/user/model/user_model.dart';
import 'package:maintaince/app/modules/watchmen/model/watchmen_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionViewModel extends BaseApiService {
  TransactionViewModel(BuildContext context) : super(context);

  Future<TransactionResponse?> getTransaction(
      int iSocietyWingId, String vStartDate, String vEndDate, int iType) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(client.getTransaction(token ?? "",
        iSocietyWingId: iSocietyWingId,
        vStartDate: vStartDate,
        vEndDate: vEndDate,
        iType: iType));
  }

  Future<TransactionResponse?> getMyTransaction(int iUserId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    return await callApi(
        client.getMyTransaction(token ?? "", iUserId: iUserId));
  }

  Future<UserResponse?> getUser(int iSocietyWingId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var timeMillisecond = prefs.getInt("user_timestamp_$iSocietyWingId");
    var timeStamp = "";
    if (timeMillisecond != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(timeMillisecond);
      timeStamp = DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
    }
    return await callApi(client.getUser(token ?? "",
        iSocietyWingId: iSocietyWingId, timeStamp: timeStamp));
  }

  Future<WatchmenResponse?> getWatchmen() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var userData =
        UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    return await callApi(client.getWatchmen(token ?? "",
        iSocietyWingId: userData.wings[0].iSocietyWingId ?? 0));
  }

  Future<TransactionCreateResponse?> createTransaction(
      int iSocietyWingId,
      int iUserId,
      int iTransactionType,
      String vPaymentType,
      int iAmount,
      String dPaymentDate,
      String vPaymentDetails,
      String vTransactionDetails) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var userData =
        UserData.fromJson(jsonDecode(prefs.getString("userData") ?? ""));
    return callApi(
      client.createTransaction(token ?? "",
          iUserId: iUserId,
          iSocietyWingId: iSocietyWingId,
          iTransactionType: iTransactionType,
          vPaymentType: vPaymentType,
          iAmount: iAmount,
          dPaymentDate: dPaymentDate,
          vPaymentDetails: vPaymentDetails,
          vTransactionDetails: vTransactionDetails,
          iAddId: userData.iUserId ?? 0),
    );
  }

  Future<TransactionsAddResponse?> addTransactions(
      List<dynamic> listTransaction) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return callApi(
        client.addTransactions(token ?? "", listTransaction: listTransaction));
  }
}
