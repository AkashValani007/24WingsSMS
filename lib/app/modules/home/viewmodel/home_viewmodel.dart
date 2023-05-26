
import 'package:flutter/material.dart';
import 'package:maintaince/app/modules/home/model/balance_model.dart';
import 'package:maintaince/app/modules/home/model/constant_model.dart';
import 'package:maintaince/network/base_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends BaseApiService {
  HomeViewModel(BuildContext context) : super(context);

  Future<ConstantResponse?> constant() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(client.constant(token ?? ""), doShowLoader: false);
  }

  Future<BalanceResponse?> getBalance(int iSocietyWingId) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return await callApi(
        client.getBalance(token ?? "", iSocietyWingId: iSocietyWingId),
        doShowLoader: false);
  }
}
